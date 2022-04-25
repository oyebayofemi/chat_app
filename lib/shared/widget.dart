import 'package:flutter/material.dart';

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
