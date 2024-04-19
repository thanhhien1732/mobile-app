import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/models/product_model.dart';

import '../provider/app_provider.dart';

class SingleFavoriteItem extends StatefulWidget {
  final ProductModel singleProduct;

  const SingleFavoriteItem({Key? key, required this.singleProduct}) : super(key: key);

  @override
  State<SingleFavoriteItem> createState() => _SingleFavoriteItemState();
}

class _SingleFavoriteItemState extends State<SingleFavoriteItem> {

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
        context
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2.3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12.0),
            height: 140,
            width: 140,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Image.asset(
                    widget.singleProduct.image,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.singleProduct.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${widget.singleProduct.price}",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (appProvider.getFavoriteProductList.contains(widget.singleProduct)) {
                            // If the product is already in the wishlist, remove it
                            appProvider.removeFavoriteProduct(widget.singleProduct);
                            Fluttertoast.showToast(msg: "Removed from Wishlist");
                          } else {
                            // If the product is not in the wishlist, add it
                            appProvider.addFavoriteProduct(widget.singleProduct);
                            Fluttertoast.showToast(msg: "Added to Wishlist");
                          }
                        },
                        child: CircleAvatar(
                          maxRadius: 15,
                          backgroundColor: Colors.redAccent,
                          child: Icon(
                            appProvider.getFavoriteProductList.contains(widget.singleProduct)
                                ? Icons.delete
                                : Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 80,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
