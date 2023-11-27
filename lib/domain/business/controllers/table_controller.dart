import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';

class TableController extends GetxController {
  final _tables = <TableModel>[];
  Box<TableModel>? tablesBox;

  List<TableModel> get tables => _tables;

  @override
  void onInit() async {
    tablesBox = await Hive.openBox<TableModel>('tables');
    
    // validate if the box is empty, if it is not, then load the data
    if (tablesBox!.isNotEmpty) {
      _tables.addAll(tablesBox!.values.toList());
      return;
    }
    super.onInit();
  }

  // method to add a new table to the list
  void addTable(TableModel table) {
    _tables.add(table);
    // save the data to the box
    tablesBox!.put(table.id, table);
    update();
  }

  void removeTable (String tableId) {
    _tables.removeWhere((table) => table.id == tableId);
    tablesBox!.delete(tableId);
    update();
  }
  
  void updateTable (TableModel table) {
    tablesBox!.put(table.id, table);
    update();
  }
}
