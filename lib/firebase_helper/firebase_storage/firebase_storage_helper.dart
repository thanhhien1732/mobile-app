import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

class FirebaseStorageHelper {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static FirebaseStorageHelper instance = FirebaseStorageHelper();

  Future<String> uploadUserImage(File image) async {
    try {
      // Get the MIME type using the file extension
      String? mimeType = lookupMimeType(image.path);

      // Check if the MIME type is an image
      if (mimeType != null && mimeType.startsWith('image/')) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        String fileName = userId + DateTime.now().millisecondsSinceEpoch.toString();

        // Upload the image to Firebase Storage
        TaskSnapshot taskSnapshot = await _storage.ref('user_images/$fileName').putFile(image);

        // Get the download URL
        String imageURL = await taskSnapshot.ref.getDownloadURL();

        return imageURL;
      } else {
        // If it's not an image, handle the error or notify the user
        throw Exception("Supports only uploading images");
      }
    } catch (e) {
      // Handle errors here
      print("Error uploading image: $e");
      throw Exception("Failed to upload image");
    }
  }
}
