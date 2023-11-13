import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';

enum TabStatus {
  active,
  closed,
}

class TabModel {
  final String id;
  String tableId;
  String? alias;
  double subtotal;
  final List<ProductModel> products;
  final List<ProductsResume> productsResume;
  TabStatus status;
  final DateTime? createdAt;
  DateTime? updatedAt;

  TabModel({
    required this.id,
    required this.tableId,
    required this.subtotal,
    required this.products,
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
      subtotal: json['subtotal'],
      products: json['products'].map((product) => ProductModel.fromJson(product)).toList(),
      status: json['status'] == 'active' ? TabStatus.active : TabStatus.closed,
      productsResume: json['productsResume'].map((product) => ProductsResume.fromJson(product)).toList(),
      alias: json['alias'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}