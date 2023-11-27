import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';

enum TabStatus {
  active,
  closed,
}

@HiveType(typeId: 4)
class TabModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String tableId;
  @HiveField(2)
  String sessionId;
  @HiveField(3)
  double subtotal;
  @HiveField(4)
  TabStatus status;
  @HiveField(5)
  List<ProductsResume> productsResume;
  @HiveField(6)
  String? alias;
  @HiveField(7)
  final DateTime? createdAt;
  @HiveField(8)
  DateTime? updatedAt;

  TabModel({
    required this.id,
    required this.tableId,
    required this.sessionId,
    required this.subtotal,
    required this.status,
    required this.productsResume,
    this.alias,
    this.createdAt,
    this.updatedAt,
  });

  void updateTab() {
    updatedAt = DateTime.now();
  }

  factory TabModel.fromJson(Map<String, dynamic> json) {
    return TabModel(
      id: json['id'],
      tableId: json['tableId'],
      sessionId: json['sessionId'],
      subtotal: json['subtotal'],
      status: json['status'] == 'active' ? TabStatus.active : TabStatus.closed,
      productsResume: json['productsResume'].map((product) => ProductsResume.fromJson(product)).toList(),
      alias: json['alias'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}