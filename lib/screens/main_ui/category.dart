import 'package:flutter/material.dart';
import 'package:team3_shopping_app/screens/main_ui/product_details.dart';
import 'package:team3_shopping_app/widgets/top_titles/top_tiles_option.dart';
import '../../constants/routes.dart';
import '../../firebase_helper/firebase_firestore/firebase_firestore.dart';
import '../../models/categoryModel.dart';
import '../../models/product_model.dart';
import '../../widgets/top_titles/top_titles.dart';

class Category extends StatefulWidget {
  final CategoryModel categoryModel;

  const Category({Key? key, required this.categoryModel}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<ProductModel> productByCategoryList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });
    productByCategoryList =
    await FirebaseFirestoreHelper.instance.getProductsByCategory(widget.categoryModel.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: 'Category',),
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
                    children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0, bottom: 12.0),
              child: Text("${widget.categoryModel.name}".toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),),
            ),
            productByCategoryList.isEmpty
                ? Center(child: Text("Products are Empty"))
                : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                // Chặn scroll vùng này để vùng ngoài bao nó scroll đồng bộ
                physics: NeverScrollableScrollPhysics(),
                // Disable scrolling for GridView
                itemCount: productByCategoryList.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (ctx, index) {
                  ProductModel singleProduct =
                  productByCategoryList[index];
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
            SizedBox(height: 12.0,),
                    ],
                  ),
          ),
    );
  }
}
