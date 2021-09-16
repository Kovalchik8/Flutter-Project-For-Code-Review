import 'package:vigidas_pack/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vigidas_pack/components/button.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vigidas_pack/models/current-task.dart';
import 'package:vigidas_pack/screens/measurement-screen.dart';
import '../components/modal.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  bool showSpinner = false;

  // login user with email and password
  void loginUser() async {
    setState(() {
      showSpinner = true;
    });

    dynamic justSignedUser = '';

    try {
      justSignedUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message.toString();
      showModal(
          'Error', errorMessage, context, () => Navigator.of(context).pop());
    }

    setState(() {
      showSpinner = false;
    });

    // redirect user after successful login
    if (justSignedUser != '') {
      CurrentTask.setUserName = justSignedUser.user.email;
      Navigator.pushNamed(context, MeasurementScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: kProgressIndicator,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Container(
                            height: 56,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Welcome to Vigidas',
                          style: kTitleStyle,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.04),
                                blurRadius: 10,
                                spreadRadius: 2),
                          ]),
                      child: TextFormField(
                        initialValue: email,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: kTextFieldDecoration,
                        onChanged: (value) => {email = value},
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.04),
                                blurRadius: 10,
                                spreadRadius: 2),
                          ]),
                      child: TextFormField(
                        initialValue: password,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: 'Password'),
                        onChanged: (value) => {password = value},
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Button('Log in', 76, () => loginUser())
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
