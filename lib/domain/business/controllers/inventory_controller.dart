import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/adapters.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:uuid/v1.dart';

class InventoryController extends GetxController {
  final _products = <ProductModel>[];
  final _categories = <CategoryModel>[];

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;

 @override
 void onInit() async {
   super.onInit();
    var box = await Hive.openBox('inventory');
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CategoryAdapter());
    // validate if the box is empty, if it is not, then load the data
    if (box.isNotEmpty) {
      _products.addAll(box.get('products'));
      _categories.addAll(box.get('categories'));
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

  void updateInventoryStorage() {
    var box = Hive.box('inventory');
    box.put('products', _products);
    box.put('categories', _categories);
  }

  void addProduct(ProductModel product) {
    _products.add(product);
    updateInventoryStorage();
    
    update();
  }

  void removeProduct(ProductModel product) {
    _products.remove(product);
    updateInventoryStorage();

    update();
  }

  void updateProduct(ProductModel product) {
    final index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    updateInventoryStorage();

    update();
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    updateInventoryStorage();
    
    update();
  }

  void removeCategory(CategoryModel category) {
    _products.removeWhere((product) => product.categoryId == category.id);
    _categories.remove(category);
    updateInventoryStorage();
    
    update();
  }

  void editCategory(CategoryModel category) {
    final index = _categories.indexWhere((element) => element.id == category.id);
    _categories[index] = category;
    updateInventoryStorage();
    update();
  }
}