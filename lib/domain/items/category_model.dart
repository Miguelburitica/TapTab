import 'package:orders_handler/domain/items/model.dart';
import 'package:uuid/v1.dart';

class CategoryModel {
  final UuidV1 id;
  final String name;
  final List<ItemModel> items;
  // todo create a sorteable system

  CategoryModel({
    required this.id,
    required this.name,
    required this.items
  });

  factory CategoryModel.fromJson(Map<String,dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      items: json['items'].map((item) => ItemModel.fromJson(item)).toList(),
    );
  }
}