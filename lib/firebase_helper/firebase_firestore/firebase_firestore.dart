import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team3_shopping_app/models/banner_model.dart';
import 'package:team3_shopping_app/models/categoryModel.dart';
import 'package:team3_shopping_app/models/order_model.dart';
import 'package:team3_shopping_app/models/product_model.dart';

import '../../models/userModel.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  Future<List<BannerModel>> getBanners() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("banners").get();

      List<BannerModel> bannersList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> e) =>
              BannerModel.fromJson(e.data()!))
          .toList();

      return bannersList;
    } catch (e) {
      // Xử lý lỗi ở đây (ví dụ: in ra console hoặc báo cáo lỗi)
      print("Error fetching banners: $e");
      return [];
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> e) =>
              CategoryModel.fromJson(e.data()!))
          .toList();

      return categoriesList;
    } catch (e) {
      // Xử lý lỗi ở đây (ví dụ: in ra console hoặc báo cáo lỗi)
      print("Error fetching categories: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore.collectionGroup("products").get();

      List<ProductModel> productsList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> e) =>
          ProductModel.fromJson(e.data()!))
          .toList();

      // Lặp và in để kiểm tra docs
      // for (var element in querySnapshot.docs) {
      //   print(element.data());
      // }

      return productsList;
    } catch (e) {
      // Xử lý lỗi ở đây (ví dụ: in ra console hoặc báo cáo lỗi)
      print("Error fetching products: $e");
      return [];
    }
  }

  // Hàm lọc sản phẩm
  Future<List<ProductModel>> getProductsByType(String productType) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup("products")
              .where("type",
                  isEqualTo:
                      productType) // Thêm điều kiện lọc theo loại sản phẩm
              .get();

      List<ProductModel> productsList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> e) =>
              ProductModel.fromJson(e.data()!))
          .toList();

      return productsList;
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories")
              .doc(id)
              .collection("products")
              .get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> e) =>
              ProductModel.fromJson(e.data()!))
          .toList();

      return productModelList;
    } catch (e) {
      // Xử lý lỗi ở đây (ví dụ: in ra console hoặc báo cáo lỗi)
      print("Error fetching products: $e");
      return [];
    }
  }

  Future<void> addRating(String productId, int rating, String userId) async {
    try {
      await ratingsCollection.add({
        'productId': productId,
        'rating': rating,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      showMessage('Rating added successfully!');
    } catch (e) {
      showMessage('Error adding rating to Firestore: $e');
    }
  }

  Future<UserModel?> getUserById() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      if (userSnapshot.exists) {
        return UserModel.fromJson(userSnapshot.data()!);
      } else {
        // User with the given ID does not exist
        return null;
      }
    } catch (e) {
      // Handle errors here
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<bool> uploadOrderedProductFirebase(
      List<ProductModel> list, BuildContext context, String payment) async {
    try {
      double totalPrice = 0.0;

      // Calculate total price
      for (var element in list) {
        totalPrice += element.price * element.qty!;
      }

      // Show loading indicator
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Generate orderId
      String orderId = _generateOrderId();

      // Upload order to Firebase
      DocumentReference documentReference = _firebaseFirestore
          .collection("usersOrders")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(orderId);

      DocumentReference admin =
          _firebaseFirestore.collection("orders").doc(orderId);

      admin.set({
        "orderId": orderId,
        "products": list.map((e) => e.toJson()).toList(),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderTime": DateTime.now().toUtc().toIso8601String(),
        // Thêm thời gian đặt hàng
      });

      documentReference.set({
        "orderId": orderId,
        "products": list.map((e) => e.toJson()).toList(),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderTime": DateTime.now().toUtc().toIso8601String(),
        // Thêm thời gian đặt hàng
      });

      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      // Show success message
      showMessage("Order placed successfully!");
      return true;
    } catch (e) {
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();

      // Show error message
      showMessage("Error: ${e.toString()}");

      return false;
    }
  }

  String _generateOrderId() {
    // You can implement your own logic to generate a unique orderId
    // For example, you can use a combination of timestamp and user ID
    // to ensure uniqueness.
    return DateTime.now().millisecondsSinceEpoch.toString() +
        FirebaseAuth.instance.currentUser!.uid;
  }

  // Get User Orders
  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("usersOrders")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .get();

      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();
      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void updateTokenFromFirebase() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "notificationToken": token,
        });
        print("Notification token updated successfully.");
      } else {
        print("Failed to retrieve notification token.");
      }
    } catch (e) {
      print("Error updating notification token: $e");
    }
  }


  // Tìm kiếm sản phẩm
  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
          .collectionGroup("products")
          .where("name", isGreaterThanOrEqualTo: keyword)
          .where("name", isLessThan: keyword + 'z') // Nếu muốn tìm kiếm chính xác hơn, bạn có thể sử dụng toàn bộ từ khóa thay vì keyword + 'z'
          .get();

      List<ProductModel> productsList = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> e) =>
          ProductModel.fromJson(e.data()!))
          .toList();
      print("Products found: ${productsList.length}");
      return productsList;
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }
}
