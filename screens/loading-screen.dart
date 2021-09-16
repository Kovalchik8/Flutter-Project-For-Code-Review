import 'package:flutter/material.dart';
import 'package:vigidas_pack/constants.dart';
import 'package:vigidas_pack/models/current-task.dart';
import 'package:vigidas_pack/screens/login-screen.dart';
import 'package:vigidas_pack/screens/measurement-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/connectivity.dart';

class Loading extends StatefulWidget {
  static const String id = 'loading';

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  dynamic initialRoute = '';

  Future loadApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        initialRoute = LoginScreen();
      } else {
        ConnectivityService.init();
        CurrentTask.setUserName = user.email.toString();
        initialRoute = MeasurementScreen();
      }
      // push route without saving it to the navigation stack
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => initialRoute,
          transitionsBuilder: (c, a1, a2, child) =>
              FadeTransition(opacity: a1, child: child),
          transitionDuration: Duration(milliseconds: 1500),
        ),
      );
    });
  }

  @override
  void initState() {
    loadApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'logo',
            child: Container(
              height: 115,
              child: Image.asset('images/logo.png'),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Loading...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kColorGray78,
              fontSize: 22,
            ),
          )
        ],
      ),
    ));
  }
}
