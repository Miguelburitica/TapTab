import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 3)
class TableModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  String? alias;
  @HiveField(3)
  double tableTotal = 0;
  
  // todo table shape and position properties

  TableModel({
    required this.id,
    required this.name,
    this.alias,
  });

  factory TableModel.fromJson(Map<String,dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      alias: json['alias'] == '' ? null : json['alias'],
    );
  }
}