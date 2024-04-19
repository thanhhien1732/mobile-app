import 'dart:convert';

class ProductModel {
  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.isFavorite,
    required this.type,
    required this.qty,
  });

  String image;
  String id;
  bool isFavorite;
  String name;
  double price;
  String description;
  String type;

  int? qty;
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? "", // Kiểm tra null và gán giá trị mặc định nếu cần
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
      isFavorite: json["isFavorite"] ?? false,
      price: double.parse(json["price"].toString()),
      type: json["type"] ?? "",
      qty: json["qty"] ?? "",
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image" : image,
    "isFavorite" : isFavorite,
    "price" : price,
    "type" : type,
    "qty" : qty,
  };

  @override
  ProductModel copyWith({
    int? qty,
  }) => ProductModel(
    image: image,
    id: id,
    name: name,
    price: price,
    description: description,
    isFavorite: isFavorite,
    type: type,
    qty: qty ?? this.qty,
  );
}

// You had UserModel here, but it should be ProductModel
String productModelToJson(ProductModel data) => json.encode(data.toJson());

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));
