import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/provider/app_provider.dart';
import 'package:team3_shopping_app/provider/search_provider.dart';
import 'package:team3_shopping_app/screens/auth_ui/controller/auth_controller.dart';
import 'package:team3_shopping_app/screens/main_ui/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    Get.put(AuthController());
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Handle Firebase initialization error if needed
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()), // Add this line
      ],
      child: GetMaterialApp(
        title: 'Shopping App',
        home: WelcomePage(),
      ),
    );
  }
}
