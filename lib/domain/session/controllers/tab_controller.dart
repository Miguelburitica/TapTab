import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/table_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';

class TabSessionController extends GetxController {
  final _sessionTabs = <TabModel>[];

  List<TabModel> get currentActiveTabs => _sessionTabs.where((tab) => tab.status == TabStatus.active).toList();

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

    // compute the productsResume subtotals on the tab subtotal
    double value = 0;
    for (var productResume in productsResume) {
      value = value + productResume.subtotal;
    }
    tab.subtotal = value;
    
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

    // compute the productsResume subtotals on the tab subtotal
    double value = 0;
    for (var productResume in productsResume) {
      value = value + productResume.subtotal;
    }
    tab.subtotal = value;
    
    tab.updateTab();
    
    update();
  }

  void finishTab(String tabId) {
    final tables = Get.find<TableController>().tables;
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);
    tab.status = TabStatus.closed;
    // todo: add a method to calculate the total of the tab and add it to the table

    TableModel table = tables.firstWhere((table) => table.id == tab.tableId);
    table.tableTotal += tab.subtotal;
    
    update();
  }

  void removeTab(String tabId) {
    _sessionTabs.removeWhere((tab) => tab.id == tabId);
    update();
  }

  void associateTabWithTable(String tabId, String tableId) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);

    tab.tableId = tableId;
    update();
  }
}
