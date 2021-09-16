import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:vigidas_pack/constants.dart';
import '../components/button.dart';

void showModal(String title, String text, context, Function() onButtonPressed) {
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.33),
    transitionDuration: Duration(milliseconds: 300),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 60, left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(37, 90, 37, 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: kTextSTyle.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        text,
                        style: kTextSTyle.copyWith(fontSize: 20, height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Button('OK', 76,
                          onButtonPressed /*  () => Navigator.of(context).pop() */)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(
          begin: Offset(0, 1),
          end: Offset(0, 0),
        ).animate(anim1),
        child: child,
      );
    },
  );
}
