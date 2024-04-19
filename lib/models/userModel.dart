import 'dart:convert';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  String id;
  String name;
  String email;
  String? image;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "image" : image,
  };

  UserModel copyWith({
    String? name,
    String? image, // Specify the type
  }) => UserModel(
    id: id,
    name: name ?? this.name,
    email: email,
    image: image ?? this.image,
  );
}

String userModelToJson(UserModel data) => json.encode(data.toJson());

UserModel userModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));
