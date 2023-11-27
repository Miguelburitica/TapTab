import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class ProductsResume {
  @HiveField(0)
  final String productId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int quantity;
  @HiveField(3)
  double subtotal;

  ProductsResume({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.subtotal,
  });

  factory ProductsResume.fromJson(Map<String, dynamic> json) {
    return ProductsResume(
      productId: json['productId'],
      name: json['name'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
}

@HiveType(typeId: 2)
class ProductModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? image;
  @HiveField(4)
  double price;
  @HiveField(5)
  final String categoryId;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    required this.categoryId
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] == '' ? null : json['description'],
      image: json['image'] == '' ? null : json['image'],
      price: json['price'],
      categoryId: json['categoryId']
    );
  }
}