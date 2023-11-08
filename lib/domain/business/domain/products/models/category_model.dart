import 'package:tap_tab_pedidos_y_cuentas/domain/business/domain/products/models/product_model.dart';
import 'package:uuid/v1.dart';

class CategoryModel {
  final UuidV1 id;
  final String name;
  final List<ProductModel> products;
  // todo create a sorteable system

  CategoryModel({
    required this.id,
    required this.name,
    required this.products
  });

  factory CategoryModel.fromJson(Map<String,dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      products: json['products'].map((product) => ProductModel.fromJson(product)).toList(),
    );
  }
}