import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team3_shopping_app/screens/auth_ui/controller/auth_controller.dart';
import 'package:team3_shopping_app/screens/auth_ui/forgot_pass/forgot_pass.dart';
import 'package:team3_shopping_app/screens/auth_ui/sign_up/sign_up.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Declare the controllers as instance variables
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers in the initState method
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image and text Login
            Column(
              children: [
                Container(
                  width: w,
                  height: h * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/wave.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: const [
                    SizedBox(height: 5),
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Input field
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(1,1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        autofillHints: const [AutofillHints.email],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(1,1),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.password), // Thay đổi biểu tượng password
                          labelText: 'Password',
                        ),
                        obscureText: true, // Ẩn ký tự password
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            // Login button
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    AuthController.instance.login(emailController.text.trim(), passwordController.text.trim());
                  },
                  child: Container(
                    width: w - 50,
                    height: h * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage("assets/images/box_red.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(left: 0, top: 0, right: 20, bottom: 0),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          text: "Forgot your password?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>ForgotPassPage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                Text(
                  "Do you have an account?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: "Create an account?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
