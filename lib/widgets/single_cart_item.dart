import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/models/product_model.dart';

import '../provider/app_provider.dart';

class SingleCartItem extends StatefulWidget {
  final ProductModel singleProduct;
  final Function(ProductModel) onQuantityChanged;

  const SingleCartItem({
    Key? key,
    required this.singleProduct,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  int qty = 1;

  @override
  void initState() {
    qty = widget.singleProduct.qty ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
                          onPressed: () {
                            if (qty >= 1) {
                              setState(() {
                                qty--;
                                widget.onQuantityChanged(widget.singleProduct.copyWith(qty: qty));
                              });
                            }
                          },
                          padding: EdgeInsets.zero,
                          child: CircleAvatar(
                            maxRadius: 13,
                            backgroundColor: Colors.redAccent,
                            child: Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        Text(
                          qty.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              qty++;
                              widget.onQuantityChanged(widget.singleProduct.copyWith(qty: qty));
                            });
                          },
                          padding: EdgeInsets.zero,
                          child: CircleAvatar(
                            maxRadius: 13,
                            backgroundColor: Colors.redAccent,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (!appProvider.getFavoriteProductList.contains(widget.singleProduct)) {
                              appProvider.addFavoriteProduct(widget.singleProduct);
                              Fluttertoast.showToast(msg: "Added to WishList");
                            } else {
                              appProvider.removeFavoriteProduct(widget.singleProduct);
                              Fluttertoast.showToast(msg: "Removed to WishList");
                            }
                          },
                          child: Text(
                            appProvider.getFavoriteProductList.contains(widget.singleProduct)
                                ? "Remove to WishList"
                                : "Add to WishList",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        SizedBox(width: 50,),
                        FittedBox(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
                              appProvider.removeCartProduct(widget.singleProduct);
                              Fluttertoast.showToast(msg: "Removed to cart");
                            },
                            child: CircleAvatar(
                              maxRadius: 15,
                              backgroundColor: Colors.redAccent,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}