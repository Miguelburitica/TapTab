import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/controller.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    
    return Layout(
      title: 'Configuraciones',
      body: ListView(
        children: [
          CustomListTile(
            icon: Icons.menu_book_rounded,
            title: 'Menú',
            callback: () {
              Get.toNamed('/menu');
            },
          ),
          CustomListTile(
            icon: Icons.person_rounded,
            title: 'Perfil',
            isEnable: false,
            callback: () {
              Get.toNamed('/');
            },
          ),
          CustomListTile(
            title: 'Consolidado',
            subtitle: 'Encontrarás un reporte general de ventas y también uno por cada sesión que hayas realizado hasta la fecha',
            icon: Icons.bar_chart_rounded,
            callback: () {
              Get.toNamed('/billing-report');
            },
          ),
          CustomListTile(
            title: 'Personal',
            subtitle: 'Aquí podrás agregar, editar y eliminar usuarios, además de ver sus ventas y sesiones',
            icon: Icons.people_rounded,
            isEnable: false,
            callback: () {},
          ),
          Obx(() {
            return CustomListTile(
              icon: themeController.isDarkMode.value
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
              title: 'Modo oscuro',
              callback: () {
                themeController.switchTheme();
              },
              trailing: Switch(
                value: themeController.isDarkMode.value,
                onChanged: (value) {
                  themeController.switchTheme();
                },
              ),
            );
          })
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final bool isEnable;
  final void Function() callback;
  final String? subtitle;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.callback,
    this.trailing,
    this.isEnable = true,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null
        ? Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 12
            ),
          )
        : null,
      iconColor: Theme.of(context).colorScheme.primary,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon),
        )
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      onTap: callback,
      enabled: isEnable,
    );
  }
}
