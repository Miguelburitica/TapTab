import 'package:tap_tab_pedidos_y_cuentas/domain/business/domain/products/models/product_model.dart';

enum TabStatus {
  active,
  closed,
}

class TabModel {
  final String id;
  String tableId;
  String? alias;
  int subtotal;
  final List<ProductModel> products;
  List<ProductsResume> productsResume;
  TabStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TabModel({
    required this.id,
    required this.tableId,
    required this.subtotal,
    required this.products,
    required this.status,
    this.productsResume = const [],
    this.alias,
    this.createdAt,
    this.updatedAt,
  });

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