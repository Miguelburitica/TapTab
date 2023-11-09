import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/inventory_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:uuid/v1.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();
    final List<ProductModel> currentProducts = inventoryController.products;
    final List<CategoryModel> currentCategories = inventoryController.categories;

    // controller for the inputs
    final TextEditingController categoryNameController = TextEditingController();
    return Layout(
      title: 'Menu',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear categoria',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (categoryNameController.text.isEmpty) {
                        return;
                      }

                      inventoryController.addCategory(CategoryModel(
                        id: const UuidV1().generate(),
                        name: categoryNameController.text,
                      ));
                    },
                    controller: categoryNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          if (categoryNameController.text.isEmpty) {
                            return;
                          }
                          
                          inventoryController.addCategory(CategoryModel(
                            id: const UuidV1().generate(),
                            name: categoryNameController.text,
                          ));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GetBuilder<InventoryController>(
              builder: (context) {
                return Expanded(
                  child: GridView.builder(
                    itemCount: currentCategories.length,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final category = currentCategories[index];
                      final products = currentProducts.where((product) => product.categoryId == category.id).toList();
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.redAccent,
                                    ),
                                    onTap: () {
                                      if (currentProducts.any((product) => product.categoryId == category.id)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text('Vas a eliminar una categoría que tiene productos asociados, estás seguro?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    inventoryController.removeCategory(category);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Theme.of(context).colorScheme.error,
                                                    foregroundColor: Theme.of(context).colorScheme.onError,
                                                  ),
                                                  child: const Text('Eliminar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        return;
                                      }
                                      inventoryController.removeCategory(category);
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ...products.map((product) => Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(product.price.floor().toString()),
                                      ],
                                    )).toList(),
                                  ]
                                ),
                              ),
                              // total and button to add products
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: ${products.length.toString()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.add_circle_rounded,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () {
                                      Get.toNamed('/product-upsert', arguments: {'categoryId': category.id});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
      )
    );
  }
}
