import 'package:flutter/material.dart';
import 'package:vigidas_pack/models/current-task.dart';
import 'task.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/quantity-tile.dart';
import 'dart:convert';
import '../models/measurement.dart';
import '../services/firebase.dart';

class TasksProvider extends ChangeNotifier {
  DataSnapshot? databaseSnapshot;

  // fetch and save firebase snapshot
  Future<DataSnapshot?> setDatabaseSnapshot() async {
    databaseSnapshot = await FirebaseService.getFirebaseSnapshot();
    return databaseSnapshot;
  }

  // tasks cards
  List<Task> tasks = [];

  initTasks([bool notify = false]) {
    DateTime dateTime = DateTime.now();
    String timeString = '';
    String userName = CurrentTask.userName;

    CurrentTask.dateString =
        '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    tasks = [];
    for (int i = 0; i < databaseSnapshot!.value[userName]?.length; i++) {
      if (databaseSnapshot!.value[userName][i]['Measurement'] ==
              CurrentTask.measurementName &&
          databaseSnapshot!.value[userName][i]['Length'] ==
              CurrentTask.lengthName) {
        dateTime = DateTime.parse(databaseSnapshot!.value[userName][i]['Date']);
        if (CurrentTask.dateString ==
            '${dateTime.year}-${dateTime.month}-${dateTime.day}') {
          dateTime =
              DateTime.parse(databaseSnapshot!.value[userName][i]['Time']);
          timeString = '${dateTime.hour}:${dateTime.minute}';
          tasks.add(
            Task(
              databaseSnapshot!.value[userName][i]['Name'].toString(),
              databaseSnapshot!.value[userName][i]['Container'].toString(),
              CurrentTask.dateString,
              timeString.length < 5 ? '${timeString}0' : timeString,
              databaseSnapshot!.value[userName][i]['Done'],
              databaseSnapshot!.value[userName][i]['id'].toString(),
            ),
          );
        }
      }
    }
    if (notify) notifyListeners();
  }

  List<Task> get getTasks {
    return tasks;
  }

  int get tasksLen {
    return tasks.length;
  }

  // quantity tiles
  List<QuantityTile> quantityTilesList = [];

  List<QuantityTile> get getQuantityTiles {
    return quantityTilesList;
  }

  int get quantityTilesLen {
    return quantityTilesList.length;
  }

  num quantityTotalPicked = 0;
  dynamic calculatedCBM = 0;

  setQuantityValue(int index, num value) {
    getQuantityTiles[index].count = value;
    calculateQuantities();
    notifyListeners();
  }

  calculateQuantities() {
    quantityTotalPicked = 0;
    calculatedCBM = 0;

    for (int i = 0; i < quantityTilesLen; i++)
      if (getQuantityTiles[i].count != 0) {
        quantityTotalPicked += getQuantityTiles[i].count;
        calculatedCBM += measurements[CurrentTask.measurementIndex]
                .diameterValue
                .values
                .elementAt(i) *
            getQuantityTiles[i].count;
      }

    calculatedCBM = calculatedCBM.toStringAsFixed(3);
  }

  initQuantityTiles(String taskID) {
    String diametersJson = databaseSnapshot!.value[CurrentTask.userName]
        [int.parse(taskID)]['Diameters'];
    Map<String, dynamic> currentQuantities = diametersJson.length > 0
        ? json.decode(databaseSnapshot!.value[CurrentTask.userName]
            [int.parse(taskID)]['Diameters'])
        : new Map();

    for (int i = 0; i < measurements.length; i++) {
      if (CurrentTask.lengthName == measurements[i].lengthName &&
          CurrentTask.measurementName == measurements[i].measurementName) {
        CurrentTask.measurementIndex = i;
        break;
      }
    }

    quantityTilesList = [];
    String diameterName = '';
    int diameterValue = 0;

    for (int i = 0;
        i < measurements[CurrentTask.measurementIndex].diameterValue.length;
        i++) {
      diameterName =
          'Beam ${measurements[CurrentTask.measurementIndex].diameterValue.keys.elementAt(i)}CM';
      diameterValue = currentQuantities[diameterName] != null
          ? currentQuantities[diameterName]
          : 0;
      quantityTilesList.add(
        QuantityTile(diameterValue, diameterName),
      );
    }
    calculateQuantities();
    CurrentTask.diameters = quantityTilesList;
  }
}
