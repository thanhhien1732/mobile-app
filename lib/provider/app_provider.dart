import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:team3_shopping_app/constants/constants.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_firestore/firebase_firestore.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_storage/firebase_storage_helper.dart';
import 'package:team3_shopping_app/models/userModel.dart';

import '../models/product_model.dart';

class AppProvider with ChangeNotifier {
  // Cart
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  UserModel? _userModel;

  UserModel? get getUserById => _userModel;

  void addCartProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartProduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  // Favorite
  final List<ProductModel> _favoriteProductList = [];

  void addFavoriteProduct(ProductModel productModel) {
    _favoriteProductList.add(productModel);
    notifyListeners();
  }

  void removeFavoriteProduct(ProductModel productModel) {
    print('Removing product from favorites: ${productModel.name}');
    _favoriteProductList.removeWhere((product) => product.id == productModel.id);
    notifyListeners();
  }

  List<ProductModel> get getFavoriteProductList => _favoriteProductList;

  void getUserInforFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserById();
    notifyListeners();
  }

  //
  void updateUserInforFirebase(BuildContext context, UserModel userModel, File? file) async {
    try {
      if (file == null) {
        // If no new image is provided, update only the name
        _userModel = _userModel?.copyWith(name: userModel.name);
      } else {
        // If a new image is provided, update both name and image
        String imageURL = await FirebaseStorageHelper.instance.uploadUserImage(file);
        _userModel = _userModel?.copyWith(name: userModel.name, image: imageURL);
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());

      notifyListeners();
    } catch (e) {
      // Handle errors here
      showMessage("Error updating user information: $e");
      // You might want to show an error message or handle the error differently
    }
  }

  // TOTAL PRICE
  double totalPriceCart() {
    if (_cartProductList.isEmpty) {
      return 0.0;
    }

    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.qty!;
    }
    notifyListeners();
    return totalPrice;
  }

  double totalPrice() {

    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      totalPrice += element.price * element.qty!;
    }
    notifyListeners();
    return totalPrice;
  }


  // Update the quantity of a product in the cart
  void updateCartProduct(ProductModel updatedProduct) {
    // Find the index of the product in the cart
    int index = _cartProductList.indexWhere((product) => product.id == updatedProduct.id);

    if (index != -1) {
      // If the product is found, update its quantity
      _cartProductList[index] = updatedProduct;
      notifyListeners();
    }
  }
  // Buy Product

  void addBuyProduct(ProductModel model) {
    _buyProductList.add(model);
    notifyListeners();
  }

  void addBuyProductCartList() {
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearCart() {
    _cartProductList.clear();
    notifyListeners();
  }

  void clearBuyProduct() {
    _buyProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;

  List<ProductModel> get getBuyProductsList => _buyProductList;

}