import 'package:flutter/material.dart';
import 'package:team3_shopping_app/screens/auth_ui/controller/auth_controller.dart';
import 'package:team3_shopping_app/screens/main_ui/home.dart';

import '../auth_ui/controller/auth_controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthController _authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo-color.png',
              width: 400,
              height: 400,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nút được nhấn, chuyển đến trang LoginPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Start'),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                AuthController.instance.logOut();
              },
              child: TextButton(
                onPressed: () {
                  // Xử lý khi nút logout được nhấn
                  _authController.logOut();
                },
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red, // Màu đỏ cho nút logout
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
