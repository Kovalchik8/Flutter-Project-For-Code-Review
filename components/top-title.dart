import 'package:flutter/material.dart';
import 'package:vigidas_pack/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vigidas_pack/screens/login-screen.dart';
// import '../services/connectivity.dart';

class TopTitle extends StatelessWidget {
  final String text;
  TopTitle(this.text);

  @override
  Widget build(BuildContext context) {
    // Future<void> _signOut() async {
    //   ConnectivityService.cancelSubscription();
    //   await FirebaseAuth.instance.signOut();
    //   Navigator.pushNamed(context, LoginScreen.id);
    // }

    return Container(
      constraints: BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: kColorBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                text,
                style: kTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            // TextButton(
            //   onPressed: () async => {_signOut()},
            //   child: Text('sign out'),
            // )
          ],
        ),
      ),
    );
  }
}
