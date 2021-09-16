import '../models/quantity-tile.dart';

class CurrentTask {
  static String userName = '';
  static String measurementName = '';
  static String lengthName = '';
  static dynamic selectedTask = '';
  static List<QuantityTile> diameters = [];
  static num totalCount = 0;
  static dynamic totalCBM = 0.0;
  static String dateString = '';
  static int measurementIndex = 0;

  static set setUserName(String userEmail) {
    userName = userEmail.substring(
      0,
      userEmail.indexOf('@'),
    );
  }

  static get getDiameters {
    Map<String, dynamic> diametersAsMap = new Map();
    for (int i = 0; i < diameters.length; i++)
      if (diameters[i].count != 0)
        diametersAsMap[diameters[i].name] = diameters[i].count;
    return diametersAsMap;
  }
}
