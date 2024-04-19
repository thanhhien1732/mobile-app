import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/models/product_model.dart';
import 'package:team3_shopping_app/provider/app_provider.dart';
import 'package:team3_shopping_app/screens/main_ui/checkout.dart';
import 'package:team3_shopping_app/widgets/top_titles/top_titles.dart';
import 'package:team3_shopping_app/widgets/rating/rating.dart';


class ProductDetail extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetail({Key? key, required this.singleProduct}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toptiles(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      widget.singleProduct.image,
                      height: 350,
                      width: 350,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.singleProduct.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.singleProduct.isFavorite = !widget.singleProduct.isFavorite;
                          });
                          if (widget.singleProduct.isFavorite) {
                            appProvider.addFavoriteProduct(widget.singleProduct);
                          } else {
                            appProvider.removeFavoriteProduct(widget.singleProduct);
                          }
                        },
                        icon: Icon(
                          appProvider.getFavoriteProductList.contains(widget.singleProduct)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${widget.singleProduct.price.toString()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.0,),
                  Text(
                    "Description",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.singleProduct.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          if(qty >= 2){
                            setState(() {
                              qty--;
                            });
                          }
                        },
                        padding: EdgeInsets.zero,
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Text(qty.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12.0),
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            qty++;
                          });
                        },
                        padding: EdgeInsets.zero,
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Expanded(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: OutlinedButton(
                            onPressed: () {
                              // Xử lý thêm vào giỏ hàng ở đây

                              ProductModel productModel = widget.singleProduct.copyWith(qty: qty);
                              appProvider.addCartProduct(productModel);
                              Fluttertoast.showToast(msg: "Added to cart");
                             },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                BorderSide(color: Colors.redAccent),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.redAccent.withOpacity(0.8);
                                }
                                return Colors.transparent;
                              }),
                            ),
                            child: const Text("ADD TO CART"),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Expanded(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: OutlinedButton(
                            onPressed: () {
                              // Xử lý mua ở đây
                              ProductModel productModel = widget.singleProduct.copyWith(qty: qty);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckOut(totalAmount: appProvider.totalPrice(), singleProduct: productModel,),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                BorderSide(color: Colors.redAccent),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.redAccent.withOpacity(0.8);
                                }
                                return Colors.transparent;
                              }),
                            ),
                            child: const Text("BUY"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  // Add the RatingBar below the existing code
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingPage(singleProduct: widget.singleProduct),
                        ),
                      );
                    },
                    child: Text('Rate this product'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
