import 'package:flutter/material.dart';

class Routes {
  // Make the instance private
  static Routes _instance = Routes._();

  // Private constructor
  Routes._();

  // Getter for the instance
  static Routes get instance => _instance;

  static Future<dynamic> pushAndRemoveUntil({
    required Widget widget,
    required BuildContext context,
  }) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => widget),
          (route) => false,
    );
  }

  static Future<dynamic> push({
    required Widget widget,
    required BuildContext context,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => widget),
    );
  }
}
