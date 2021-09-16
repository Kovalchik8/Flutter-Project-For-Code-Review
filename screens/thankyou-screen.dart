import 'package:flutter/material.dart';
import 'package:vigidas_pack/components/top-title.dart';
import 'package:vigidas_pack/components/button.dart';
import 'package:vigidas_pack/screens/measurement-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login-screen.dart';
import '../services/connectivity.dart';

class ThankyouScreen extends StatelessWidget {
  static const String id = 'thankyou';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopTitle('Thank you'),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      'Back to tasks',
                      76,
                      () =>
                          {Navigator.pushNamed(context, MeasurementScreen.id)},
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Button(
                      'Log out',
                      76,
                      () async {
                        ConnectivityService.cancelSubscription();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
