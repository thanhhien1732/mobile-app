import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/screens/auth_ui/change_password/changePassword.dart';
import 'package:team3_shopping_app/screens/auth_ui/controller/auth_controller.dart';
import 'package:team3_shopping_app/screens/main_ui/favorite.dart';
import 'package:team3_shopping_app/screens/main_ui/order.dart';
import 'package:team3_shopping_app/widgets/top_titles/top_tiles_option.dart';

import '../../constants/routes.dart';
import '../../provider/app_provider.dart';
import 'edit_profile.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    // Check if the image URL is not empty and valid
    bool hasValidImage = appProvider.getUserById!.image != null &&
        appProvider.getUserById!.image!.isNotEmpty;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: 'Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 18,),
                  // Display the default icon or network image
                  appProvider.getUserById!.image != null && appProvider.getUserById!.image!.isNotEmpty
                      ? Image.network(
                    appProvider.getUserById!.image!,
                    width: 80,
                    height: 80,
                  )
                      : Icon(
                    Icons.person_outline,
                    size: 150,
                  ),
                  SizedBox(height: 20),
                  Text(
                    appProvider.getUserById!.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    appProvider.getUserById!.email,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Routes.push(widget: const EditProfile(), context: context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Routes.push(
                          widget: const OrderScreen(), context: context);
                    },
                    leading: Icon(Icons.shopping_bag),
                    title: Text("Your Orders"),
                  ),
                  ListTile(
                    onTap: () {
                      Routes.push(
                          widget: Favorite(),
                          context: context);
                    },
                    leading: Icon(Icons.favorite),
                    title: Text("Favorite"),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('About us'),
                            content: Text('This is Team 3 project, consisting of 3 members: Minh Khai, Thanh Hien, and Ngoc Hien'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Đóng'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: Icon(Icons.info),
                    title: Text("About us"),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.support_agent),
                    title: Text("Support"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangePasswordPage(), // Replace ChangePassword with the actual widget/class for the ChangePassword screen
                        ),
                      );
                    },
                    leading: Icon(Icons.change_circle_outlined),
                    title: Text("Change Password"),
                  ),
                  ListTile(
                    onTap: () {
                      AuthController.instance.logOut();
                    },
                    leading: Icon(Icons.logout),
                    title: Text("Log out"),
                  ),
                  SizedBox(height: 12.0),
                  Text("Version 1.0"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
