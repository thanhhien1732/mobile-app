import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final MaterialAccentColor backgroundColor;
  final Color titleColor;
  final double buttonHeight;

  const PrimaryButton({
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.titleColor,
    this.buttonHeight = 50.0, // Default height is 50.0
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {}, // Use the provided onPressed callback or an empty function
      style: ElevatedButton.styleFrom(
        primary: backgroundColor, // Use the provided background color
        shape: RoundedRectangleBorder(
        ),
        minimumSize: Size(double.infinity, buttonHeight), // Set the height
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
      ),
    );
  }
}


