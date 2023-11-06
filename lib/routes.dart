import 'package:get/get.dart';
import 'package:orders_handler/views/config_page.dart';
import 'package:orders_handler/views/home_page.dart';
import 'package:orders_handler/views/tab_creator_page.dart';

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
      name: '/create-tab',
      page: () => const TabCreatorPage(),
    ),
    GetPage(
      name: '/menu',
      page: () => const ConfigPage(),
    ),
  ];
}
