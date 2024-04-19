import 'package:flutter/material.dart';
import 'package:team3_shopping_app/screens/main_ui/home.dart';

import '../../constants/routes.dart';

class ToptilesOption extends StatelessWidget {
  final String titleText;

  const ToptilesOption({Key? key, required this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.redAccent, // Đặt màu của AppBar
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.white, // Đặt màu cho nút back là trắng
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Đặt vị trí của tiêu đề ở giữa
        children: [
          Text(
            titleText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Đặt màu cho tiêu đề là trắng
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            Routes.push(widget: HomePage(), context: context);
          },
          color: Colors.white, // Đặt màu cho nút home là trắng
        ),
      ],
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}
