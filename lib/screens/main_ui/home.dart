import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_firestore/firebase_firestore.dart';
import 'package:team3_shopping_app/models/categoryModel.dart';
import 'package:team3_shopping_app/provider/app_provider.dart';
import 'package:team3_shopping_app/screens/main_ui/category.dart';
import 'package:team3_shopping_app/screens/main_ui/product_details.dart';

import '../../constants/routes.dart';
import '../../models/banner_model.dart';
import '../../models/product_model.dart';
import '../../provider/search_provider.dart';
import '../../widgets/top_titles/top_titles.dart';
import 'package:team3_shopping_app/DatabaseHandler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHandler _databaseHandler = DatabaseHandler();

  List<BannerModel> bannerList = [];
  List<CategoryModel> categoriesList = [];
  List<ProductModel> bestProductsList = [];
  List<ProductModel> newProductsList = [];
  List<ProductModel> salesProductList = [];
  List<ProductModel> mustbuyProductsList = [];


  bool isLoading = false;

  Routes routes = Routes.instance;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInforFirebase();

    getCategories();
    initializeData();
    super.initState();
  }

  void initializeData() async {
    await _databaseHandler.initializeDB();
  }

  int currentIndex = 0;

  void getCategories() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    bannerList = await FirebaseFirestoreHelper.instance.getBanners();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    bestProductsList =
        await FirebaseFirestoreHelper.instance.getProductsByType('best');
    newProductsList =
        await FirebaseFirestoreHelper.instance.getProductsByType('new');
    salesProductList =
        await FirebaseFirestoreHelper.instance.getProductsByType('sales');
    mustbuyProductsList =
        await FirebaseFirestoreHelper.instance.getProductsByType('must buy');

    setState(() {
      isLoading = false;
    });
  }

  List<ProductModel> searchList = [];

  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    searchList = searchProvider.searchList;

    // Check if the user is typing
    bool isUserTyping = searchProvider.isUserTyping;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toptiles(),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFormField(
                  //   controller: search,
                  //   onChanged: (String value) {
                  //     searchProducts(value);
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: 'Search products...',
                  //     prefixIcon: Icon(Icons.search),
                  //   ),
                  // ),
                  searchList.isNotEmpty && isUserTyping
                      ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchList.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (ctx, index) {
                        ProductModel singleProduct = searchList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                singleProduct.image,
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 12.0),
                              Flexible(
                                child: Text(
                                  singleProduct.name,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  "Price: \$${singleProduct.price}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              OutlinedButton(
                                onPressed: () {
                                  Routes.push(
                                    widget: ProductDetail(
                                      singleProduct: singleProduct,
                                    ),
                                    context: context,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  side: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 1.4,
                                  ),
                                  fixedSize: const Size(150, 40),
                                ),
                                child: const Text(
                                  "Buy",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                      : Container(),
                  const SizedBox(height: 20),
                  CarouselSlider(
                    items: bannerList.map((banner) {
                      return Image.asset(
                        banner.image,
                        fit: BoxFit.cover,
                        height: 300,
                        width: 300,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 300,
                      initialPage: currentIndex,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  categoriesList.isEmpty
                      ? Center(child: Text("Category is Empty"))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoriesList.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Routes.push(
                                        widget:
                                            Category(categoryModel: category),
                                        context: context);
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 6.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(category.image),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                  SizedBox(
                    height: 12.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Best Seller",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  bestProductsList.isEmpty
                      ? Center(child: Text("Best Products is Empty"))
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: bestProductsList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct =
                                  bestProductsList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      singleProduct.image,
                                      height: 100,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Flexible(
                                      child: Text(
                                        singleProduct.name,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Price: \$${singleProduct.price}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    OutlinedButton(
                                      onPressed: () {
                                        Routes.push(
                                            widget: ProductDetail(
                                                singleProduct: singleProduct),
                                            context: context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        side: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.4,
                                        ),
                                        fixedSize: const Size(150, 40),
                                      ),
                                      child: const Text(
                                        "Buy",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Must Buy",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  mustbuyProductsList.isEmpty
                      ? Center(child: Text("Must Buy Products is Empty"))
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: mustbuyProductsList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct =
                                  mustbuyProductsList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      singleProduct.image,
                                      height: 100,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Flexible(
                                      child: Text(
                                        singleProduct.name,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Price: \$${singleProduct.price}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    OutlinedButton(
                                      onPressed: () {
                                        Routes.push(
                                            widget: ProductDetail(
                                                singleProduct: singleProduct),
                                            context: context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        side: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.4,
                                        ),
                                        fixedSize: const Size(150, 40),
                                      ),
                                      child: const Text(
                                        "Buy",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "New Products",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  newProductsList.isEmpty
                      ? Center(child: Text("New Products is Empty"))
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: newProductsList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct =
                                  newProductsList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      singleProduct.image,
                                      height: 100,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Flexible(
                                      child: Text(
                                        singleProduct.name,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Price: \$${singleProduct.price}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    OutlinedButton(
                                      onPressed: () {
                                        Routes.push(
                                            widget: ProductDetail(
                                                singleProduct: singleProduct),
                                            context: context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        side: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.4,
                                        ),
                                        fixedSize: const Size(150, 40),
                                      ),
                                      child: const Text(
                                        "Buy",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Sales Products",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  salesProductList.isEmpty
                      ? Center(child: Text("Sales Products is Empty"))
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            // Chặn scroll vùng này để vùng ngoài bao nó scroll đồng bộ
                            physics: NeverScrollableScrollPhysics(),
                            // Disable scrolling for GridView
                            itemCount: salesProductList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct =
                                  salesProductList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      singleProduct.image,
                                      height: 100,
                                      width: 100,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      singleProduct.name,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Price: \$${singleProduct.price}",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6.0),
                                    OutlinedButton(
                                      onPressed: () {
                                        Routes.push(
                                            widget: ProductDetail(
                                                singleProduct: singleProduct),
                                            context: context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        side: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.4,
                                        ),
                                        fixedSize: const Size(150, 40),
                                      ),
                                      child: const Text(
                                        "Buy",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
    );
  }
}
