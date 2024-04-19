import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:team3_shopping_app/models/banner_model.dart';
import 'package:team3_shopping_app/models/categoryModel.dart';
import 'package:team3_shopping_app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    Database database = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        // Tạo các bảng cần thiết trong cơ sở dữ liệu SQLite
        await database.execute(
            '''
          CREATE TABLE Category (
            id TEXT PRIMARY KEY,
            image TEXT NOT NULL,
            name TEXT NOT NULL
          )
          '''
        );

        await database.execute(
            '''
          CREATE TABLE Product (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            image TEXT NOT NULL,
            description TEXT NOT NULL,
            isFavorite INTEGER NOT NULL,
            price REAL NOT NULL,
            status TEXT NOT NULL,
            type TEXT NOT NULL,
          )
          '''
        );

        await database.execute(
            '''
          CREATE TABLE Banner (
            id TEXT PRIMARY KEY,
            image TEXT NOT NULL
          )
          '''
        );

        await database.execute(
            '''
          CREATE TABLE "Order" (
            orderId TEXT PRIMARY KEY,
            payment TEXT NOT NULL,
            status TEXT NOT NULL,
            totalPrice REAL NOT NULL
          )
          '''
        );

        await database.execute(
            '''
          CREATE TABLE OrderProduct (
            id TEXT PRIMARY KEY,
            orderId TEXT NOT NULL,
            description TEXT NOT NULL,
            image TEXT NOT NULL,
            isFavorite INTEGER NOT NULL,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            qty INTEGER NOT NULL,
            type TEXT NOT NULL,
            status TEXT NOT NULL,
            FOREIGN KEY (orderId) REFERENCES "Order" (orderId)
          )
          '''
        );
      },
      version: 1,
    );

    // Load dữ liệu từ Firestore và thêm vào bảng Category
    await _loadCategoriesFromFirestore(database);
    await _loadProductsFromFirestore(database);
    await _loadBannerFromFirestore(database);
    await _loadOrdersFromFirestore(database);

    return database;
  }

  Future<void> _loadCategoriesFromFirestore(Database db) async {
    try {
      // Thực hiện truy vấn lấy dữ liệu từ Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("categories").get();

      // Thêm dữ liệu từ Firestore vào bảng Category
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        await db.insert(
          'Category',
          CategoryModel.fromJson(doc.data()).toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print("Error loading categories from Firestore: $e");
    }
  }

  Future<void> _loadProductsFromFirestore(Database db) async {
    try {
      // Thực hiện truy vấn lấy dữ liệu từ Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collectionGroup("products").get();

      // Thêm dữ liệu từ Firestore vào bảng Product
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        await db.insert(
          'Product',
          ProductModel.fromJson(doc.data()).toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print("Error loading products from Firestore: $e");
    }
  }

  Future<void> _loadBannerFromFirestore(Database db) async {
    try {
      // Thực hiện truy vấn lấy dữ liệu từ Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("banners").get();

      // Thêm dữ liệu từ Firestore vào bảng Banner
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        await db.insert(
          'Banner',
          BannerModel.fromJson(doc.data()).toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print("Error loading banners from Firestore: $e");
    }
  }

  Future<void> _loadOrdersFromFirestore(Database db) async {
    try {
      // Thực hiện truy vấn lấy dữ liệu từ Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("orders").get();

      // Thêm dữ liệu từ Firestore vào bảng Order
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        await db.insert(
          'Order',
          {
            'orderId': doc['orderId'],
            'payment': doc['payment'],
            'status': doc['status'],
            'totalPrice': doc['totalPrice'],
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Load dữ liệu chi tiết sản phẩm từ Firestore và thêm vào bảng OrderProduct
        await _loadOrderProductsFromFirestore(db, doc);
      }
    } catch (e) {
      print("Error loading orders from Firestore: $e");
    }
  }

  Future<void> _loadOrderProductsFromFirestore(Database db, QueryDocumentSnapshot<Map<String, dynamic>> orderDoc) async {
    try {
      // Lấy mảng products từ tài liệu "order"
      List<dynamic> products = orderDoc['products'];

      // Lặp qua từng sản phẩm và thêm vào bảng OrderProduct
      for (Map<String, dynamic> product in products) {
        await db.insert(
          'OrderProduct',
          {
            'id': product['id'],
            'orderId': orderDoc['orderId'],
            'description': product['description'],
            'image': product['image'],
            'isFavorite': product['isFavorite'],
            'name': product['name'],
            'price': product['price'],
            'qty': product['qty'],
            'type': product['type'],
            'status': product['status'] ?? 'default_status', // Provide a default value if status is null
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print("Error loading order products from Firestore: $e");
    }
  }
}
