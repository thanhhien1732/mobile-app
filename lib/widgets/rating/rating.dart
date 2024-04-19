import 'package:flutter/material.dart';
import 'package:team3_shopping_app/firebase_helper/firebase_firestore/firebase_firestore.dart';

import '../../models/product_model.dart';
import '../../screens/auth_ui/controller/auth_controller.dart';
import '../top_titles/top_tiles_option.dart';

String userId = 'your_user_id'; // Giá trị mặc định

class RatingPage extends StatefulWidget {
  final ProductModel singleProduct;
  const RatingPage({Key? key, required this.singleProduct}) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedRating = 0;
  List<int> ratings = [0, 0, 0, 0, 0];

  void updateRating(int rating) {
    setState(() {
      selectedRating = rating;
      ratings[rating - 1]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = getUserId(); // Lấy userId từ hệ thống xác thực người dùng

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ToptilesOption(titleText: "Rating Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Rating: $selectedRating',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int starRating = index + 1;
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: starRating <= selectedRating
                        ? Colors.amber
                        : Colors.grey,
                  ),
                  onPressed: () => updateRating(starRating),
                );
              }),
            ),
            SizedBox(height: 20),
            Text('Rating Statistics:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int starRating = index + 1;
                int percentage = ratings[index] > 0
                    ? ((ratings[index] / ratings.reduce((a, b) => a + b)) * 100).round()
                    : 0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$starRating Stars:'),
                    SizedBox(width: 10),
                    Text('$percentage%'),
                  ],
                );
              }),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Xác định productId và userId của người đánh giá
                  String productId = widget.singleProduct.id;

                  // Thực hiện lưu đánh giá lên Firestore
                  await FirebaseFirestoreHelper().addRating(productId, selectedRating, userId);

                  // Cập nhật UI hoặc thực hiện các bước khác sau khi đã rating
                } catch (e) {
                  print("Error submitting rating: $e");
                }
              },
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  String getUserId() {
    // Lấy userId từ hệ thống xác thực người dùng (Firebase Authentication)
    var user = AuthController.instance.auth.currentUser;
    return user?.uid ?? 'your_default_user_id';
  }
}
