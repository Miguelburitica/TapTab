import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/table_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/controllers/session_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';

class TabSessionController extends GetxController {
  final _sessionTabs = <TabModel>[];
  Box<TabModel>? tabsBox;

  List<TabModel> get currentActiveTabs => _sessionTabs.where((tab) => tab.status == TabStatus.active).toList();

  @override
  void onInit() async {
    tabsBox = await Hive.openBox<TabModel>('tabs');
    
    // validate if the box is empty, if it is not, then load the data
    if (tabsBox!.isNotEmpty) {
      _sessionTabs.addAll(tabsBox!.values.where((tab) => tab.status == TabStatus.active).toList());
    }
    super.onInit();
  }

  void addTab(TabModel tab) {
    _sessionTabs.add(tab);
    tabsBox!.put(tab.id, tab);
    
    update();
  }

  void updateTab(TabModel tab) {
    _sessionTabs.removeWhere((tab) => tab.id == tab.id);
    _sessionTabs.add(tab);
    tabsBox!.put(tab.id, tab);
    
    update();
  }

  void addProductsToTab(String tabId, List<ProductModel> products) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);

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

    tab.updateTab();
    tabsBox!.put(tab.id, tab);
    
    update();
  }

  void removeProductsFromTab(String tabId, List<ProductModel> products) {
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);

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
    tabsBox!.put(tab.id, tab);
    
    update();
  }

  void finishTab(String tabId) {
    final tableController = Get.put(TableController());
    final sessionController = Get.put(SessionController());
    final tables = tableController.tables;
    TabModel tab = _sessionTabs.firstWhere((tab) => tab.id == tabId);
    tab.status = TabStatus.closed;

    TableModel? table = tables.firstWhereOrNull((table) => table.id == tab.tableId);
    if (table == null) {
      sessionController.tabPayed(tab);
      update();
      return;
    }
    
    table.tableTotal += tab.subtotal;
    tableController.updateTable(table);
    sessionController.tabPayed(tab);
    
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
