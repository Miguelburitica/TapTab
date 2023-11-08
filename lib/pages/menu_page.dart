import 'package:flutter/material.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/domain/products/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/products/models/category_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:tap_tab_pedidos_y_cuentas/pages/config_page.dart';
import 'package:uuid/v1.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> currentCategories = [
      CategoryModel(
        id: const UuidV1().generate(),
        name: 'Bebidas',
      ),
      CategoryModel(
        id: const UuidV1().generate(),
        name: 'Comidas',
      ),
    ];
    final List<ProductModel> currentProducts = [
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Coca Cola',
        price: 2000,
        categoryId: currentCategories.first.id,
      ),
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Pepsi',
        price: 2000,
        categoryId: currentCategories.first.id,
      ),
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Hamburguesa',
        price: 2000,
        categoryId: currentCategories.last.id,
      ),
      ProductModel(
        id: const UuidV1().generate(),
        name: 'Perro caliente',
        price: 2000,
        categoryId: currentCategories.last.id,
      ),
    ];
    
    return Layout(
      title: 'Menu',
      body: Column(
        children: [
          const Text(
            'Menu actual',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          // Resume from current categories and products by category
          GridView.builder(
            itemCount: currentCategories.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final category = currentCategories[index];
              final products = currentProducts.where((product) => product.categoryId == category.id).toList();
              return Card(
                child: Column(
                  children: [
                    Text(category.name),
                    GridView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: Column(
                            children: [
                              Text(product.name),
                              Text(product.price.toString()),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              children: [
                CustomListTile(
                  title: 'Crear categoría',
                  icon: Icons.add_box_rounded,
                  callback: () {
                  }
                ),
                CustomListTile(
                  title: 'Crear articulo',
                  icon: Icons.add_circle_rounded,
                  callback: () {
                  },
                ),
                CustomListTile(
                  title: 'Consolidado',
                  subtitle: 'Encontrarás un reporte por cada sesión que hayas realizado hasta la fecha',
                  icon: Icons.bar_chart_rounded,
                  isEnable: false,
                  callback: () {
                  }
                ),
                CustomListTile(
                  title: 'Personal',
                  icon: Icons.person_rounded,
                  isEnable: false,
                  callback: () {},
                )
              ],
            )
          ),
        ],
      )
    );
  }
}
