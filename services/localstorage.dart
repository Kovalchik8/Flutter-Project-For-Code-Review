import 'package:vigidas_pack/models/current-task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/image-holder.dart';
import '../models/quantity-tile.dart';

class LocalStorage {
  // save task to local storage
  static encodeAndSaveCurrentTask(
    context,
    List<ImageHolder> imageHolders,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic existingQueuedTasks = prefs.getString('queued_tasks');

    if (existingQueuedTasks != null && existingQueuedTasks != '') {
      existingQueuedTasks = json.decode(existingQueuedTasks);
      existingQueuedTasks.removeWhere(
          (task) => task['selectedTask']?['id'] == CurrentTask.selectedTask.id);
    } else
      existingQueuedTasks = [];

    var newTask = {
      'userName': CurrentTask.userName,
      'measurementName': CurrentTask.measurementName,
      'lengthName': CurrentTask.lengthName,
      'totalCount': CurrentTask.totalCount,
      'totalCBM': CurrentTask.totalCBM,
      'dateString': CurrentTask.dateString,
      'measurementIndex': CurrentTask.measurementIndex,
      'selectedTask': {
        'id': CurrentTask.selectedTask.id,
        'container': CurrentTask.selectedTask.container,
        'date': CurrentTask.selectedTask.date,
        'isDone': CurrentTask.selectedTask.isDone,
        'title': CurrentTask.selectedTask.title,
        'time': CurrentTask.selectedTask.time,
      }
    };

    newTask['images'] = [];
    for (int i = 0; i < imageHolders.length; i++) {
      newTask['images']
          .add(imageHolders[i].pickedFile?.path ?? imageHolders[i].imageUrl);
    }

    newTask['diameters'] = jsonEncode(CurrentTask.diameters);

    existingQueuedTasks.add(newTask);
    await prefs.setString('queued_tasks', json.encode(existingQueuedTasks));
    await prefs.setString('has_queued_tasks', 'true');
  }

  // delete task from local storage
  static deleteTaskFromQueue(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic existingQueuedTasks = prefs.getString('queued_tasks');

    if (existingQueuedTasks != null) {
      existingQueuedTasks = json.decode(existingQueuedTasks);
      existingQueuedTasks
          .removeWhere((task) => task['selectedTask']['id'] == id);

      await prefs.setString('queued_tasks', json.encode(existingQueuedTasks));
    }

    if (existingQueuedTasks == null || existingQueuedTasks?.length <= 0)
      await prefs.setString('has_queued_tasks', '');
  }

  // get queued tasks
  static Future<List<dynamic>> getQueuedTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    late dynamic existingQueuedTasks = prefs.getString('queued_tasks');

    if (existingQueuedTasks != null && existingQueuedTasks != '') {
      existingQueuedTasks = json.decode(existingQueuedTasks);
      var quantityTilesJson;

      // decode tasks diameters into list of QuantityTile objects
      for (int i = 0; i < existingQueuedTasks.length; i++) {
        quantityTilesJson =
            jsonDecode(existingQueuedTasks[i]['diameters']) as List;
        existingQueuedTasks[i]['diameters'] = quantityTilesJson
            .map((quantityTileJson) => QuantityTile.fromJson(quantityTileJson))
            .toList();
      }
    }

    return existingQueuedTasks != null ? existingQueuedTasks : [];
  }

  // check if queued tasks exists
  static Future<String> hasQueuedTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic hasQueuedTasks = prefs.getString('has_queued_tasks');
    return hasQueuedTasks ?? '';
  }
}
