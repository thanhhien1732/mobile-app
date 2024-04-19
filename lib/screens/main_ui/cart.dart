import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/constants/constants.dart';
import 'package:team3_shopping_app/provider/app_provider.dart';
import 'package:team3_shopping_app/screens/main_ui/cart_item_checkout.dart';
import 'package:team3_shopping_app/widgets/single_cart_item.dart';
import 'package:team3_shopping_app/widgets/top_titles/top_tiles_option.dart';
import '../../constants/routes.dart';
import '../../widgets/primary_button/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: "Shopping cart"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "\$${appProvider.totalPriceCart().toString()}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            PrimaryButton(
              title: "Checkout",
              onPressed: () {
                appProvider.clearBuyProduct();
                appProvider.addBuyProductCartList();
                appProvider.clearCart();
                if(appProvider.getBuyProductsList.isEmpty) {
                  showMessage("Cart is empty");
                }
                else {
                  Routes.push(widget: const CartItemCheckout(), context: context);
                }
              },
              backgroundColor: Colors.redAccent,
              titleColor: Colors.white,
            ),
          ],
        ),
      ),
      body: appProvider.getCartProductList.isEmpty
          ? Center(child: Text("Empty"))
          : ListView.builder(
        itemCount: appProvider.getCartProductList.length,
        itemBuilder: (context, index) {
          return SingleCartItem(
            singleProduct: appProvider.getCartProductList[index],
            onQuantityChanged: (updatedProduct) {
              // Update the product in the cart with the new quantity
              appProvider.updateCartProduct(updatedProduct);
            },
          );
        },
      ),
    );
  }
}
