import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:orders_handler/layout.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Configuraciones',
      body: ListView(
        children: [
          _CustomListTile(
            icon: Icons.menu_book_rounded,
            title: 'Menú',
            callback: () {
              Get.toNamed('/');
            },
          ),
          _CustomListTile(
            icon: Icons.person_rounded,
            title: 'Perfil',
            callback: () {
              Get.toNamed('/');
            },
          )
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final void Function() callback;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.callback,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
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
    );
  }
}
