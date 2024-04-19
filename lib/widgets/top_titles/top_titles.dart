import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/constants/routes.dart';
import 'package:team3_shopping_app/screens/main_ui/account.dart';
import 'package:team3_shopping_app/screens/main_ui/cart.dart';

import '../../firebase_helper/firebase_firestore/firebase_firestore.dart';
import '../../models/product_model.dart';
import '../../provider/search_provider.dart';
import '../../screens/main_ui/home.dart';
import '../../screens/main_ui/order.dart';

class Toptiles extends StatefulWidget {
  const Toptiles({Key? key}) : super(key: key);

  @override
  State<Toptiles> createState() => _ToptilesState();

}

class _ToptilesState extends State<Toptiles> {

  TextEditingController searchController = TextEditingController();
  List<ProductModel> productList = [];
  bool isLoading = false;

  @override
  void initState() {
    getProducts();
    Provider.of<SearchProvider>(context, listen: false).setSearchController(searchController);
    super.initState();
  }


  void getProducts() async {
    setState(() {
      isLoading = true;
    });
    productList = await FirebaseFirestoreHelper.instance.getProducts();
    setState(() {
      isLoading = false;
    });
  }


  void searchProducts(String value, BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context, listen: false);

    List<ProductModel> searchList = productList
        .where((element) =>
        element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    searchProvider.setSearchList(searchList);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Expanded(
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: TextField(
            controller: searchController,
            // Sử dụng onChanged để theo dõi thay đổi giá trị người dùng nhập vào
            onChanged: (String value) {
              searchProducts(value, context);
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      backgroundColor: Colors.redAccent,
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            // Xử lý khi người dùng nhấn nút user
            Routes.push(widget: AccountScreen(), context: context);
          },
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            // Xử lý khi người dùng nhấn nút cart
            Routes.push(widget: CartScreen(), context: context);
          },
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.checklist),
          onPressed: () {
            // Xử lý khi người dùng nhấn nút order
            Routes.push(widget: OrderScreen(), context: context);
          },
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            Routes.push(widget: HomePage(), context: context);
          },
          color: Colors.white, // Đặt màu cho nút home là trắng
        ),
      ],
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    );
  }

}
