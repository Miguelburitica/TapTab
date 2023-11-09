import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';

class InventoryController extends GetxController {
  final _products = <ProductModel>[];
  final _categories = <CategoryModel>[];

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;

  void addProduct(ProductModel product) {
    _products.add(product);
    update();
  }

  void removeProduct(ProductModel product) {
    _products.remove(product);
    update();
  }

  void updateProduct(ProductModel product) {
    final index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    update();
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    update();
  }

  void removeCategory(CategoryModel category) {
    _products.removeWhere((product) => product.categoryId == category.id);
    
    _categories.remove(category);
    update();
  }

  void editCategory(CategoryModel category) {
    final index = _categories.indexWhere((element) => element.id == category.id);
    _categories[index] = category;
    update();
  }
}