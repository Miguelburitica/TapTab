import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';

class BillingController extends GetxController {
  final _tables = <TableModel>[];
  final _sessionTabs = <TabModel>[];

  List<TableModel> get tables => _tables;
  List<TabModel> get currentActiveTabs => _sessionTabs.where((tab) => tab.status == TabStatus.active).toList();

  // method to add a new table to the list
  void addTable(TableModel table) {
    _tables.add(table);
    update();
  }

  void addTab(TabModel tab) {
    _sessionTabs.add(tab);
    update();
  }

  void addProductsToTab(String tabId, List<ProductModel> products) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);

    tab.products.addAll(products);

    List<ProductsResume> productsResume = tab.productsResume;
    for (var element in products) {
      if (productsResume.any((product) => product.productId == element.id)) {
        ProductsResume currentproductResume = productsResume.firstWhere((product) => product.productId == element.id);
        currentproductResume.quantity++;
        currentproductResume.subtotal += element.price;
      } else {
        productsResume.add(ProductsResume(
          productId: element.id,
          name: element.name,
          quantity: 1,
          subtotal: element.price,
        ));
      }
    }
    
    update();
  }

  void removeProductsFromTab(String tabId, List<ProductModel> products) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);

    tab.products.removeWhere((product) => products.any((element) => element.id == product.id));

    List<ProductsResume> productsResume = tab.productsResume;
    for (var element in products) {
      if (productsResume.any((product) => product.productId == element.id)) {
        ProductsResume currentproductResume = productsResume.firstWhere((product) => product.productId == element.id);
        currentproductResume.quantity--;
        currentproductResume.subtotal -= element.price;
      }
    }
    
    update();
  }

  void finishTab(String tabId) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);
    tab.status = TabStatus.closed;
    // todo: add a method to calculate the total of the tab and add it to the table

    TableModel table = _tables.firstWhere((table) => table.id == tab.tableId);
    table.tableTotal += tab.subtotal;
    
    update();
  }

  void removeTab(String tabId) {
    _sessionTabs.removeWhere((tab) => tab.id == tabId);
    update();
  }

  void associateTabWithTable(String tabId, String tableId) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);
    TableModel table = _tables.firstWhere((table) => table.id == tableId);

    tab.tableId = tableId;
    table.tabIds.add(tabId);
    update();
  }
}
