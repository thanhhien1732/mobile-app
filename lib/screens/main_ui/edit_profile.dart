import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/constants/constants.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_storage/firebase_storage_helper.dart';
import 'package:team3_shopping_app/models/userModel.dart';
import 'package:team3_shopping_app/screens/main_ui/account.dart';
import 'package:team3_shopping_app/widgets/primary_button/primary_button.dart';
import 'package:team3_shopping_app/widgets/top_titles/top_tiles_option.dart';

import '../../constants/routes.dart';
import '../../provider/app_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;

  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: "Edit Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
           image == null ? CupertinoButton(
            onPressed: () {
              takePicture();
            },
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.camera_alt, color: Colors.white)
            ),
          ) : CupertinoButton(
             onPressed: () {
               takePicture();
             },
             child: CircleAvatar(
                 radius: 70,
                 backgroundImage: FileImage(image!),
             ),
           ),
          TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: appProvider.getUserById?.name,
            ),
          ),
          SizedBox(height: 12.0),
          PrimaryButton (
            title: "Update",
            backgroundColor: Colors.redAccent,
            titleColor: Colors.white,
            onPressed: () async {
              UserModel? userModel = appProvider.getUserById?.copyWith(name: textEditingController.text);
              appProvider.updateUserInforFirebase(context, userModel!, image!);
              showMessage("Sucessfully updated profile");
              Routes.push(widget: AccountScreen(), context: context);
            },
          ),
        ],
      ),
    );
  }
}
