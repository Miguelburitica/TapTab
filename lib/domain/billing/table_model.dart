import 'package:uuid/v1.dart';

class TableModel {
  final UuidV1 id;
  final String name;
  final String? alias;
  final UuidV1? billId;
  final double tableTotal = 0;

  TableModel({
    required this.id,
    required this.name,
    this.alias,
    this.billId,
  });

  factory TableModel.fromJson(Map<String,dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      alias: json['alias'] == '' ? null : json['alias'],
      billId: json['billId'] == '' ? null : json['billId'],
    );
  }
}