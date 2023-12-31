import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/adapters.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/adapters.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/controllers/session_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/routes.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TableAdapter());
  Hive.registerAdapter(TabAdapter());
  Hive.registerAdapter(SessionAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pedidos y Cuentas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xff009999),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xff009999),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: '/',
      initialBinding: BindingsBuilder(() {
        Get.put(SessionController());
      }),
      getPages: AppPages.routes,
    );
  }
}
