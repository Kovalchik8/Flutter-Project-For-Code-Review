import 'package:flutter/material.dart';
import 'package:vigidas_pack/constants.dart';

class Button extends StatelessWidget {
  final String text;
  final double height;
  final Function()? onPress;

  Button(this.text, this.height, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      color: kColorGray78,
      borderRadius: BorderRadius.circular(8.0),
      child: MaterialButton(
        onPressed: onPress,
        minWidth: double.infinity,
        height: height,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
