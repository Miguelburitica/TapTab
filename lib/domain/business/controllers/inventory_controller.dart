import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:uuid/v1.dart';

class InventoryController extends GetxController {
  final _products = <ProductModel>[];
  final _categories = <CategoryModel>[];
  Box<ProductModel>? productsBox;
  Box<CategoryModel>? categoriesBox;

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;

 @override
 void onInit() async {
   super.onInit();
    productsBox = await Hive.openBox<ProductModel>('products');
    categoriesBox = await Hive.openBox<CategoryModel>('categories');

    // validate if the box is empty, if it is not, then load the data
    if (productsBox != null && productsBox!.isNotEmpty) {
      _products.addAll(productsBox!.values.toList());
    }
    if (categoriesBox != null && categoriesBox!.isNotEmpty) {
      _categories.addAll(categoriesBox!.values.toList());
      return;
    }
    // if the box is empty, then add some data
    final muckCategories = [
      CategoryModel(
        id: const UuidV1().generate(),
        name: 'Bebidas'
      ),
      CategoryModel(
        id: const UuidV1().generate(),
        name: 'Comidas'
      ),
    ];

    final muckProducts = [
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Agua',
        price: 3000,
        categoryId: muckCategories[0].id,
      ),
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Aguila',
        price: 2700,
        categoryId: muckCategories[0].id,
      ),
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Chorizo',
        price: 5000,
        categoryId: muckCategories[1].id,
      ),
    ];

    for (var category in muckCategories) {
      addCategory(category);
    }

    for (var product in muckProducts) {
      addProduct(product);
    }
  }

  void addProduct(ProductModel product) {
    _products.add(product);
    productsBox!.put(product.id, product);
    
    update();
  }

  void removeProduct(ProductModel product) {
    _products.remove(product);
    productsBox!.delete(product.id);

    update();
  }

  void updateProduct(ProductModel product) {
    final index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    productsBox!.put(product.id, product);

    update();
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    categoriesBox!.put(category.id, category);
    
    update();
  }

  void removeCategory(CategoryModel category) {
    // remove from the products box the products that belong to this category
    final productIdsToRemove = products.where((product) => product.categoryId == category.id).map((e) => e.id).toList();
    productsBox!.deleteAll(productIdsToRemove);

    _products.removeWhere((product) => product.categoryId == category.id);
    _categories.remove(category);

    categoriesBox!.delete(category.id);
    
    update();
  }

  void editCategory(CategoryModel category) {
    final index = _categories.indexWhere((element) => element.id == category.id);
    _categories[index] = category;
    categoriesBox!.put(category.id, category);
    update();
  }
}