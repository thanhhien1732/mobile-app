import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class SearchProvider extends ChangeNotifier {
  List<ProductModel> _searchList = [];

  List<ProductModel> get searchList => _searchList;

  TextEditingController? searchController;

  void setSearchController(TextEditingController controller) {
    searchController = controller;
    notifyListeners();
  }

  bool get isUserTyping => searchController?.text.isNotEmpty ?? false;

  void setSearchList(List<ProductModel> newList) {
    _searchList = newList;
    notifyListeners();
  }
}
