import '../services/localstorage.dart';
import 'package:vigidas_pack/services/firebase.dart';
import 'package:vigidas_pack/services/gsheet.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class ReportSenderService {
  // send all queued reports
  sendQueuedTasksReports() async {
    dynamic tasks = await LocalStorage.getQueuedTasks();
    for (int i = 0; i < tasks.length; i++)
      try {
        await sendReport(tasks[i]);
      } catch (error) {
        throw error;
      }
  }

  // send single report
  sendReport(task) async {
    late dynamic uploadedImagesUrls;
    dynamic result = false;
    try {
      uploadedImagesUrls = await uploadTaskImagesAndGetUrls(task);
      result = await GSheetsService.sendReport(task, uploadedImagesUrls);
    } catch (error) {
      print(error);
      throw error;
    }

    if (result == false) throw 'Some data can\'t be sent.\nPlease try again';

    // show a notification at top of screen.
    showSimpleNotification(
      Text(
        '"${task['selectedTask']['title']}" report sent successfully',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      background: Colors.green,
      autoDismiss: false,
      slideDismissDirection: DismissDirection.vertical,
    );
  }

  // upload task images
  Future<List<dynamic>> uploadTaskImagesAndGetUrls(task) async {
    late dynamic uploadedImagesUrls = [];
    final String currentTaskUploadPath =
        '${task['userName']}/${task['selectedTask']['date']}/${task['selectedTask']['title']}';
    String imageUploadPath = '';
    String imageUrl = '';

    for (int i = 0; i < task['images'].length; i++) {
      if (!task['images'][i].contains('firebasestorage.googleapis.com')) {
        imageUploadPath = '$currentTaskUploadPath/image${i + 1}';

        try {
          imageUrl = await FirebaseService().uploadImageToStorage(
            imageUploadPath,
            File(
              task['images'][i],
            ),
          );
          uploadedImagesUrls.add(imageUrl);
        } catch (error) {
          throw error;
        }
      } else
        uploadedImagesUrls.add(task['images'][i]);
    }

    return uploadedImagesUrls;
  }
}
