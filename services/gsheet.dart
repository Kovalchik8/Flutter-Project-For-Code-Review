import 'package:gsheets/gsheets.dart';
import 'dart:convert';
import '../models/measurement.dart';
import '../services/localstorage.dart';

class GSheetsService {
// google auth credentials
  static final credentials = '';

  static final String tasksSpreadsheetId =
      '1JWGsiC5D_TB6aWhToLYRW3X4dWar023plHZPHJXFPZM';

  // send report to the google sheets
  static Future<dynamic> sendReport(task, imageUrls) async {
    bool success = true;
    final gsheets = GSheets(credentials);

    // send quantity report to Vigidas Pack Reports sheet
    dynamic reportsSheet = '';
    try {
      reportsSheet = await gsheets
          .spreadsheet('1Am57bpZZrg4dl7j1lmVRI6F9YaSMa6DWEbaeQEcbCm4');
    } on Exception catch (e) {
      return e.toString();
    }

    num reportUnitVolume = 0;
    final String reportTabName =
        '${task['userName']}_${task['dateString']}[${task['selectedTask']['id']}]${task['selectedTask']['title']}';
    Worksheet? reportTab = reportsSheet.worksheetByTitle(reportTabName);
    await reportTab?.clear();
    reportTab ??= await reportsSheet.addWorksheet(reportTabName);
    String reportTabUrl =
        'https://docs.google.com/spreadsheets/d/${reportTab?.spreadsheetId}/edit#gid=${reportTab?.id}';

    // generate report table rows
    List<Map<String, dynamic>> reportRows = [];

    for (int i = 0; i < task['diameters'].length; i++) {
      reportUnitVolume = measurements[task['measurementIndex']]
              .diameterValue
              .values
              .elementAt(i) *
          task['diameters'][i].count;

      reportRows.add(
        {
          'Measurement': task['measurementName'],
          'Diameter': task['diameters'][i].name,
          'Length': task['lengthName'],
          'Value': measurements[task['measurementIndex']]
              .diameterValue
              .values
              .elementAt(i),
          'Log count': task['diameters'][i].count,
          'm3': reportUnitVolume.toStringAsFixed(3),
          'Container': i == 0 ? task['selectedTask']['container'] : '',
          'Date': i == 0 ? task['dateString'] : '',
          'Images': i < imageUrls.length ? imageUrls[i] : '',
        },
      );
    }

    reportRows.add({
      'Log count': 'Total count: ${task['totalCount']}',
      'm3': 'Total CBM: ${task['totalCBM']}',
    });

    // write report table rows
    if (await reportTab?.values.map
            .appendRows(reportRows, appendMissing: true) !=
        true) success = false;

    // send report to Vigidas Pack Tasks sheet
    dynamic tasksSheet = '';
    try {
      tasksSheet = await gsheets.spreadsheet(tasksSpreadsheetId);
    } on Exception catch (e) {
      return e.toString();
    }
    final tasksTab = tasksSheet.worksheetByTitle(task['userName']);
    final int taskRowNumber = int.parse(task['selectedTask']['id']) + 2;

    // convert list of QuantityTile object to map with non zero count values
    Map<String, dynamic> diametersAsMap = new Map();
    for (int i = 0; i < task['diameters'].length; i++)
      if (task['diameters'][i].count != 0)
        diametersAsMap[task['diameters'][i].name] = task['diameters'][i].count;

    List<dynamic> taskRowNewValues = [
      task['selectedTask']['id'],
      task['selectedTask']['title'],
      task['measurementName'],
      task['lengthName'],
      task['selectedTask']['container'],
      task['dateString'],
      task['selectedTask']['time'],
      'TRUE',
      task['totalCount'],
      task['totalCBM'],
      json.encode(diametersAsMap),
      reportTabUrl,
    ];

    // update task row data in tasks sheet
    if (await tasksTab?.values.insertRow(taskRowNumber, taskRowNewValues) !=
        true) success = false;

    // delete task from queue after sending
    if (success == true)
      await LocalStorage.deleteTaskFromQueue(task['selectedTask']['id']);

    return success;
  }
}
