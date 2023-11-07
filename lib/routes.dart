import 'package:get/get.dart';
import 'package:orders_handler/pages/config_page.dart';
import 'package:orders_handler/pages/home_page.dart';

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
      page: () => const ConfigPage(),
    ),
  ];
}
