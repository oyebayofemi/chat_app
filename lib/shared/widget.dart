import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

InputDecoration textFormFieldDecoration() {
  return InputDecoration(
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    filled: true,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.green)),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    //focusColor: Colors.green[100],
  );
}

TextStyle profileHeader() {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}

TextStyle profileText() {
  return TextStyle(
    //fontWeight: FontWeight.bold,
    fontSize: 17,
  );
}

TextStyle conversationDateText() {
  return TextStyle(
    //fontWeight: FontWeight.bold,
    fontSize: 35.h,
  );
}

TextStyle authHeadersText() {
  return TextStyle(
      fontSize: 80.sp,
      fontWeight: FontWeight.w700,
      color: Colors.green,
      letterSpacing: 1);
}
