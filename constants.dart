import 'package:flutter/material.dart';

const kColorGray78 = Color(0xff78909C),
    kColorGray54 = Color(0xff546E7A),
    kColorBlue = Color(0xffECEFF1);

// simple text style
const kTextSTyle =
    TextStyle(fontWeight: FontWeight.w400, color: kColorGray78, fontSize: 18);

// title style
const kTitleStyle = TextStyle(
  color: kColorGray54,
  fontWeight: FontWeight.w400,
  fontSize: 28.0,
  height: 1.3,
  fontFamily: 'OpenSans',
);

final kProgressIndicator = CircularProgressIndicator(
  valueColor: new AlwaysStoppedAnimation<Color>(kColorGray78),
);

// input decoration
const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintText: 'Enter your email',
  hintStyle: TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.3),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kColorGray78, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kColorGray78, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
