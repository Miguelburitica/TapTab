import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/domain/products/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/domain/products/models/product_model.dart';

class ProductsController extends GetxController {
  final _products = <ProductModel>[];
  final _categories = <CategoryModel>[];

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;

  void addproduct(ProductModel product) {
    _products.add(product);
    update();
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    update();
  }
}