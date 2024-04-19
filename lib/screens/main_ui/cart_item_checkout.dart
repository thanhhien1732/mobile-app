import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_firestore/firebase_firestore.dart';
import 'package:team3_shopping_app/screens/main_ui/home.dart';
import 'package:team3_shopping_app/widgets/primary_button/primary_button.dart';

import '../../constants/routes.dart';
import '../../provider/app_provider.dart';
import '../../widgets/top_titles/top_tiles_option.dart';

class CartItemCheckout extends StatefulWidget {

  const CartItemCheckout({Key? key}) : super(key: key);

  @override
  State<CartItemCheckout> createState() => _CheckOutState();
}

class _CheckOutState extends State<CartItemCheckout> {
  int groupValue = 1;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: 'Check Out'),
      ),
      body: Column(
        children: [
          SizedBox(height: 36.0),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 12.0),
                  Radio(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value as int;
                      });
                    },
                  ),
                  const Icon(Icons.money),
                  SizedBox(width: 12.0),
                  Text(
                    "Cash On Delivery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 12.0),
                  Radio(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value as int;
                      });
                    },
                  ),
                  const Icon(Icons.money),
                  SizedBox(width: 12.0),
                  Text(
                    "Pay Online",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0, bottom: 0),
            child: PrimaryButton(
              title: "Continues",
              onPressed: () async {
                bool value = await FirebaseFirestoreHelper.instance
                    .uploadOrderedProductFirebase(
                    appProvider.getBuyProductsList, context, groupValue == 1 ? "Cash on delivery" : "Paid Online");
                appProvider.clearBuyProduct();
                if(value) {
                  Future.delayed(Duration(seconds: 2), () {
                    Routes.push(widget: HomePage(), context: context);
                  });
                }
              },
              backgroundColor: Colors.redAccent,
              titleColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
