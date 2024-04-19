import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team3_shopping_app/models/userModel.dart';
import 'package:team3_shopping_app/screens/auth_ui/login/login.dart';
import 'package:team3_shopping_app/screens/main_ui/welcome.dart';

class AuthController extends GetxController {
  // AuthController ..instance
  static AuthController instance = Get.find();

  // email, password, name...
  late Rx<User?> _user = Rx<User?>(null);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    // User would be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print("Login Page");
      Get.offAll(() => LoginPage());
    }
    else {
      Get.offAll(() => WelcomePage());
    }
  }


  Future<bool> register(String email, String password, String name, String image) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        image: image,
      );

      // Add the user to the "users" collection
      await FirebaseFirestore.instance.collection("users").doc(userModel.id).set(
        userModel.toJson(),
      );

      return true; // Registration successful
    } catch (e) {
      var errorMessage = "An error occurred during account creation.";
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }

      Get.snackbar(
        "About User",
        "User Message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Account creation failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          errorMessage,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

      return false; // Registration failed
    }
  }


  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      var errorMessage = "An error occurred during account creation.";
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar(
        "About Login",
        "Login Message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Login failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          errorMessage,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void logOut() async {
    await auth.signOut();
  }

  void resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Password Reset',
        'Check your email for password reset instructions.',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    } catch (e) {
      var errorMessage = 'An error occurred during password reset.';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar(
        'Password Reset Failed',
        errorMessage,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          'Password reset failed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          errorMessage,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void updatePassword(String oldPassword, String newPassword, String retypePassword) async {
    try {
      if (newPassword != retypePassword) {
        Get.snackbar(
          'Update Password Failed',
          'New password and retype password do not match.',
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Password update failed',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'New password and retype password do not match.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
        return;
      }

      // Kiểm tra xác thực người dùng lại trước khi cập nhật mật khẩu
      User? user = auth.currentUser;
      if (user != null) {
        // Tạo một đối tượng Credential để xác thực lại người dùng
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);

        // Xác thực lại người dùng với Credential
        await user.reauthenticateWithCredential(credential);

        // Cập nhật mật khẩu mới
        await user.updatePassword(newPassword);

        Get.snackbar(
          'Password Updated',
          'Your password has been updated successfully.',
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Password Updated',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Your password has been updated successfully.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );

        // Đăng xuất người dùng sau khi cập nhật mật khẩu (tuỳ thuộc vào yêu cầu)
        // await logOut();
      } else {
        Get.snackbar(
          'Update Password Failed',
          'User not authenticated.',
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Password update failed',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'User not authenticated.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      var errorMessage = 'An error occurred during password update.';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar(
        'Update Password Failed',
        errorMessage,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          'Password update failed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          errorMessage,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
