import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../services/localstorage.dart';
import '../services/report.dart';

class ConnectivityService {
  static final Connectivity connectivity = Connectivity();
  static ConnectivityResult connectionStatus = ConnectivityResult.none;
  // ignore: cancel_subscriptions
  static late StreamSubscription<ConnectivityResult> connectivitySubscription;
  static bool isInited = false;

  // set initial internet connection status
  static Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await ConnectivityService.connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    return ConnectivityService.updateConnectionStatus(result);
  }

  // update internet connection status
  static Future<void> updateConnectionStatus(ConnectivityResult result) async {
    ConnectivityService.connectionStatus = result;
    if (ConnectivityService.connectionStatus != ConnectivityResult.none &&
        await LocalStorage.hasQueuedTasks() == 'true') {
      try {
        await ReportSenderService().sendQueuedTasksReports();
      } catch (error) {
        print(error);
      }
    }
  }

  // init internet connection status and subscribe to its changes
  static init() async {
    if (ConnectivityService.isInited == false) {
      await initConnectivity();
      ConnectivityService.connectivitySubscription = ConnectivityService
          .connectivity.onConnectivityChanged
          .listen(updateConnectionStatus);
      ConnectivityService.isInited = true;
    }
  }

  // cancel connectivity subscription
  static cancelSubscription() {
    ConnectivityService.connectivitySubscription.cancel();
    ConnectivityService.isInited = false;
  }
}
