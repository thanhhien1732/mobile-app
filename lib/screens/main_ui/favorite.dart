import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team3_shopping_app/widgets/single_favorite_item.dart';

import '../../provider/app_provider.dart';
import '../../widgets/single_cart_item.dart';
import '../../widgets/top_titles/top_tiles_option.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: "Favorite"),
      ),
      body: appProvider.getFavoriteProductList.isEmpty ?
      Center(child: Text("Empty"),
      ) : ListView.builder(
        itemCount: appProvider.getFavoriteProductList.length,
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (ctx, index) {
          return SingleFavoriteItem(
            singleProduct: appProvider.getFavoriteProductList[index],
          );
        },
      ),
    );
  }
}
