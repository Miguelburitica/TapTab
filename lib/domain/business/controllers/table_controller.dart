import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/adapters.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';

class TableController extends GetxController {
  final _tables = <TableModel>[];

  List<TableModel> get tables => _tables;

  @override
  void onInit() async {
    super.onInit();

    var box = await Hive.openBox('tables');
    Hive.registerAdapter(TableAdapter());
    // validate if the box is empty, if it is not, then load the data
    if (box.isNotEmpty) {
      _tables.addAll(box.get('tables'));
      return;
    }
  }

  // method to add a new table to the list
  void addTable(TableModel table) {
    _tables.add(table);
    // save the data to the box
    var box = Hive.box('tables');
    box.put('tables', _tables);
    update();
  }

  // TODO remove table
}
