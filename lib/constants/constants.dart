import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(String message){
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.redAccent,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}