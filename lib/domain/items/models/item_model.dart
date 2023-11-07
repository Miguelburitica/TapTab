import 'package:uuid/v1.dart';

class ItemsResume {
  final UuidV1 itemId;
  final String name;
  int quantity;
  double subtotal;

  ItemsResume({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.subtotal,
  });

  factory ItemsResume.fromJson(Map<String, dynamic> json) {
    return ItemsResume(
      itemId: json['itemId'],
      name: json['name'],
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
}

class ItemModel {
  final UuidV1 id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final UuidV1 categoryId;

  ItemModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    required this.categoryId
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] == '' ? null : json['description'],
      image: json['image'] == '' ? null : json['image'],
      price: json['price'],
      categoryId: json['categoryId']
    );
  }
}