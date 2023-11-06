import 'package:orders_handler/domain/items/model.dart';
import 'package:uuid/v1.dart';

class BillingModel {
  final UuidV1 id;
  final String tableId;
  final String? alias;
  final int subtotal;
  final List<ItemModel> items;
  final String status;
  final String createdAt;
  final String updatedAt;

  BillingModel({
    required this.id,
    required this.tableId,
    this.alias,
    required this.subtotal,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      id: json['id'],
      tableId: json['tableId'],
      alias: json['alias'],
      subtotal: json['subtotal'],
      items: json['items'].map((item) => ItemModel.fromJson(item)).toList(),
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}