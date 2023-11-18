import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';

class ProductAdapter extends TypeAdapter<ProductModel> {
  @override
  final typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel(
      id: reader.readString(),
      name: reader.readString(),
      price: reader.readDouble(),
      categoryId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeDouble(obj.price)
      ..writeString(obj.categoryId);
  }
}

class CategoryAdapter extends TypeAdapter<CategoryModel> {
  @override
  final typeId = 1;

  @override
  CategoryModel read(BinaryReader reader) {
    return CategoryModel(
      id: reader.readString(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name);
  }
}

class TableAdapter extends TypeAdapter<TableModel> {
  @override
  final typeId = 2;

  @override
  TableModel read(BinaryReader reader) {
    return TableModel(
      id: reader.readString(),
      name: reader.readString(),
      alias: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, TableModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.alias ?? '');
  }
}
