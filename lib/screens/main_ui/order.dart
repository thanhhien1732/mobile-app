import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_firestore/firebase_firestore.dart';

import '../../models/order_model.dart';
import '../../widgets/top_titles/top_tiles_option.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: "Your Orders"),
      ),
      body: FutureBuilder(
          future: FirebaseFirestoreHelper.instance.getUserOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty ||
                snapshot.data == null ||
                !snapshot.hasData) {
              return Center(
                child: Text("No Order found"),
              );
            }
            return ListView.builder(
                padding: EdgeInsets.all(12.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  OrderModel orderModel = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Colors.redAccent, width: 1.3)),
                      title: Row(
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
                                    orderModel.products[0].image,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderModel.products[0].name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  orderModel.products.isNotEmpty
                                      ? Column(
                                          children: [
                                            Text(
                                              "Quantity: ${orderModel.products[0].qty}",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Total price: \$${orderModel.products[0].price}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Order Status: ${orderModel.status}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Order Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(orderModel.orderTime.toLocal())}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: orderModel.products.isNotEmpty
                          ? [
                            const Text("Details"),
                            const Divider(color: Colors.redAccent,),
                              ...orderModel.products
                                  .map((singleProduct) => Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, left: 6.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  height: 80,
                                                  width: 80,
                                                  child: Center(
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: SizedBox(
                                                        width: 140,
                                                        height: 140,
                                                        child: Image.asset(
                                                          singleProduct.image,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          singleProduct.name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Text(
                                                          "Quantity: ${singleProduct.qty}",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Text(
                                                          "Price: \$${singleProduct.price}",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList()
                            ]
                          : [],
                    ),
                  );
                });
          }),
    );
  }
}
