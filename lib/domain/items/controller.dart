import 'package:get/get.dart';
import 'package:orders_handler/domain/items/models/category_model.dart';
import 'package:orders_handler/domain/items/models/item_model.dart';

class ItemsController extends GetxController {
  final _items = <ItemModel>[];
  final _categories = <CategoryModel>[];

  List<ItemModel> get items => _items;
  List<CategoryModel> get categories => _categories;

  void addItem(ItemModel item) {
    _items.add(item);
    update();
  }

  void addCategory(CategoryModel category) {
    _categories.add(category);
    update();
  }
}