import 'package:orders_handler/domain/items/models/item_model.dart';

enum TabStatus {
  active,
  closed,
}

class TabModel {
  final String id;
  String tableId;
  String? alias;
  int subtotal;
  final List<ItemModel> items;
  List<ItemsResume> itemsResume;
  TabStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TabModel({
    required this.id,
    required this.tableId,
    required this.subtotal,
    required this.items,
    required this.status,
    this.itemsResume = const [],
    this.alias,
    this.createdAt,
    this.updatedAt,
  });

  factory TabModel.fromJson(Map<String, dynamic> json) {
    return TabModel(
      id: json['id'],
      tableId: json['tableId'],
      subtotal: json['subtotal'],
      items: json['items'].map((item) => ItemModel.fromJson(item)).toList(),
      status: json['status'] == 'active' ? TabStatus.active : TabStatus.closed,
      itemsResume: json['itemsResume'].map((item) => ItemsResume.fromJson(item)).toList(),
      alias: json['alias'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}