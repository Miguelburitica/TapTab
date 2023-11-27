import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/inventory_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:tap_tab_pedidos_y_cuentas/utils.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final category = Get.find<InventoryController>().categories.firstWhereOrNull((category) => category.id == arguments['categoryId']) ?? Get.find<InventoryController>().categories.first;

    return Layout(
      title: 'Editar productos en ${category.name}',
      body: Column(
        children: [
          GetBuilder<InventoryController>(
            builder: (controller) {
              final categoryProducts = controller.products.where((product) => product.categoryId == arguments['categoryId']);
              
              return Column(
                children: categoryProducts.map((product) {
                  return ListTile(
                    title: Text(product.name),
                    subtitle: product.description != null ? Text(product.description!) : null,
                    trailing: Text(formatCurrency(product.price)),
                    onTap: () {
                      Get.toNamed('/product-upsert', arguments: { "id": product.id, "categoryId": product.categoryId });
                    },
                    onLongPress: () {
                      Get.defaultDialog(
                        title: 'Eliminar producto',
                        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 14),
                        content: Text('¿Estás seguro de que quieres eliminar ${product.name}?'),
                        cancel: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancelar',
                          ),
                        ),
                        confirm: ElevatedButton(
                          onPressed: () {
                            controller.removeProduct(product);
                            Get.back();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error,
                            backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                          ),
                          child: const Text('Eliminar'),
                        ),
                        onConfirm: () {
                          controller.removeProduct(product);
                          Get.back();
                        },
                      );
                    },
                  );
                }).toList(),
              );
            }
          )
        ],
      )
    );
  }
}