import 'package:team3_shopping_app/models/product_model.dart';

class OrderModel {
  OrderModel({
    required this.orderId,
    required this.payment,
    required this.status,
    required this.products,
    required this.totalPrice,
    required this.orderTime,
  });

  String orderId;
  String? payment;
  String? status;
  List<ProductModel> products;
  double totalPrice;
  DateTime orderTime;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> productMap = json["products"];
    return OrderModel(
      orderId: json["orderId"],
      products: productMap.map((e) => ProductModel.fromJson(e)).toList(),
      payment: json["payment"],
      status: json["status"],
      totalPrice: json["totalPrice"],
      orderTime: DateTime.parse(json["orderTime"]), // Chuyển đổi chuỗi thời gian thành DateTime
    );
  }
}
