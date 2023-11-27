import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/inventory_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:uuid/v1.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryController = Get.find<InventoryController>();
    final List<CategoryModel> currentCategories = inventoryController.categories;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final arguments = Get.arguments;
    CategoryModel currentCategory = currentCategories.firstWhereOrNull((category) => category.id == arguments['categoryId']) ?? currentCategories.first;
    ProductModel? currentProduct = inventoryController.products.firstWhereOrNull((product) => product.id == arguments['id']);

    if (currentProduct != null) {
      nameController.text = currentProduct.name;
      priceController.text = currentProduct.price.toString();
      descriptionController.text = currentProduct.description ?? '';
    }
    
    return Layout(
      title: currentProduct != null ? 'Editar producto' : 'Nuevo producto',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentProduct != null ? 'Editar ${currentProduct.name}' : 'Nuevo producto',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                DropdownButtonFormField(
                  value: arguments['categoryId'],
                  onChanged: (value) {
                    // todo change table
                    currentCategory = currentCategories.firstWhere((table) => table.id == value);
                  },
                  items: currentCategories.map((CategoryModel table) {
                    return DropdownMenuItem(value: table.id, child: Text(table.name));
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    hintText: 'Selecciona categoría',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una categoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre del producto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  // start with mayus
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    hintText: 'Precio del producto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Descripción del producto',
                    helperText: 'Opcional',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  // indicate that its optional
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    )
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'El nombre no puede estar vacío',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                      colorText: Theme.of(context).colorScheme.error,
                    );
                    return;
                  }

                  if (currentProduct != null) {
                    currentProduct.name = nameController.text;
                    currentProduct.price = double.parse(priceController.text);
                    currentProduct.description = descriptionController.text;
                    inventoryController.updateProduct(currentProduct);
                    Get.back();
                    return;
                  }
                  // create the new tab
                  ProductModel newProduct = ProductModel(
                    id: const UuidV1().generate(),
                    categoryId: currentCategory.id,
                    name: nameController.text,
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                  );

                  inventoryController.addProduct(newProduct);
                  Get.back();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        currentProduct != null ? 'Editar' : 'Crear',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        )
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.add_task_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}