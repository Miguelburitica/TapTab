import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/billing_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/inventory_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/create_table.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/menu_page.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/product_page.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/tab_upsert.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/config_page.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/home_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/config',
      page: () => const ConfigPage(),
    ),
    GetPage(
      name: '/profile',
      page: () => const ConfigPage(),
    ),
    GetPage(
      name: '/menu',
      page: () => const MenuPage(),
      binding: BindingsBuilder(() {
        Get.put(InventoryController());
      }),
    ),
    GetPage(
      name: '/product-upsert',
      page: () => const ProductPage(),
      binding: BindingsBuilder(() {
        Get.put(InventoryController());
      }),
    ),
    GetPage(
      name: '/table-create',
      page: () => const CreateTablePage(),
      binding: BindingsBuilder(() {
        Get.put(BillingController());
      }),
    ),
    GetPage(
      name: '/table-update',
      page: () => const ConfigPage(),
      binding: BindingsBuilder(() {
        Get.put(BillingController());
      }),
    ),
    GetPage(
      name: '/tab-upsert',
      page: () => const TabUpsertPage(),
      binding: BindingsBuilder(() {
        Get.put(BillingController());
        Get.put(InventoryController());
      }),
    ),
  ];
}
