import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  // todo create a sorteable system

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String,dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
}