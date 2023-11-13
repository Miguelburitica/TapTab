import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/billing_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/inventory_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:tap_tab_pedidos_y_cuentas/utils.dart';
import 'package:uuid/v1.dart';


class TabUpsertPage extends StatefulWidget {
  const TabUpsertPage({Key? key}) : super(key: key);

  @override
  TabUpsertPageState createState() => TabUpsertPageState();
}

class TabUpsertPageState extends State<TabUpsertPage> with SingleTickerProviderStateMixin {
  final availableTables = Get.find<BillingController>().tables;
  final arguments = Get.arguments ?? {};
  final currentCategories = Get.find<InventoryController>().categories;
  final currentProducts = Get.find<InventoryController>().products;
  final Map<String,int> currentOrder = {};

  late TabController _tabController;
  
  @override
  void initState() {
    final navigationTabsLength = currentCategories.length + 1;
    _tabController = TabController(length: navigationTabsLength, vsync: this);
    for (var element in currentProducts) {
      currentOrder[element.id] = 0;
    }

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final tabId = arguments['tabId'] as String?;
    
    TableModel currentTable = availableTables.firstWhereOrNull((table) => table.tabIds.isEmpty) ?? availableTables.first;
    TextEditingController aliasController = TextEditingController();

    return Layout(
      title: tabId == null ? 'Nueva cuenta' : 'Editar cuenta',
      body: tabId == null
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nueva cuenta',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    value: currentTable.id,
                    onChanged: (value) {
                      // todo change table
                      currentTable = availableTables.firstWhere((table) => table.id == value);
                    },
                    items: availableTables.map((TableModel table) {
                      return DropdownMenuItem(value: table.id, child: Text(table.alias ?? table.name));
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Mesa',
                      hintText: 'Selecciona mesa',
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return 'Selecciona una mesa';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: aliasController,
                    decoration: const InputDecoration(
                      labelText: 'Alias',
                      hintText: 'Alias de la cuenta',
                      border: OutlineInputBorder(),
                      helperText: 'Opcional'
                    ),
                    keyboardType: TextInputType.text,
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
                    // create the new tab
                    TabModel newTab = TabModel(
                      id: const UuidV1().generate(),
                      tableId: currentTable.id,
                      alias: aliasController.text.isEmpty ? (currentTable.name) : aliasController.text,
                      subtotal: 0,
                      products: [],
                      status: TabStatus.active,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      productsResume: []
                    );

                    if (currentTable.tabIds.isNotEmpty) {
                      // warning the user that the table already has a bill
                      showDialog(context: context, builder: (context) {
                        return busyTable(context, currentTable, newTab);
                      });
                    } else {
                      Get.find<BillingController>().addTab(newTab);
                      Get.find<BillingController>().associateTabWithTable(newTab.id, currentTable.id);
                      
                      Get.back();
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Crear',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                          )
                        ),
                        SizedBox(width: 16),
                        Icon(
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
        )
        : Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                const Tab(
                  text: 'Resumen',
                ),
                ...currentCategories.map((category) {
                  return Tab(
                    text: category.name,
                  );
                }).toList(),
              ]
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  tabResumeInfo(context, tabId),
                  ...currentCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      child: Column(
                        children: [
                          Text(
                            'Agregar productos',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: GetBuilder<InventoryController>(
                              builder: (controller) {
                                return ListView(
                                  children: [
                                    ...currentProducts.where((product) => product.categoryId == category.id).toList().map((product) {
                                      // return a product tile or row, where the name is the first, then a remove button, then an add button and then a counter about the quantity added or removed
                                      return ListTile(
                                        title: Text(product.name),
                                        subtitle: product.description != null ? Text(product.description!) : null,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                // remove one product from the tab
                                                final currentTab = Get.find<BillingController>().currentActiveTabs.firstWhere((tab) => tab.id == tabId);
                                                final currentProductQuantity = currentTab.productsResume.firstWhere((productResume) => productResume.productId == product.id).quantity;
                                                if (currentProductQuantity <= currentOrder[product.id]! * -1) return;

                                                setState(() {
                                                  currentOrder[product.id] = currentOrder[product.id]! - 1;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.remove_circle_outline_rounded,
                                                color: Theme.of(context).colorScheme.error,
                                              ),
                                            ),
                                            Text(
                                              currentOrder[product.id].toString(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                // add one product to the tab
                                                setState(() {
                                                  currentOrder[product.id] = currentOrder[product.id]! + 1;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline_rounded,
                                                color: Colors.greenAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              }
                            ),
                          ),
                          const SizedBox(height: 16,),
                          ElevatedButton(
                            onPressed: () {
                              // todo confirm the order
                              confirmOrder(tabId ,currentOrder);
                              Get.back();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )
                              ),
                            ),
                            // the button must contain the products added and the total price
                            // child: const Text('Confirmar pedido'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                    child: ListView(
                                      children: [
                                        ...currentOrder.entries.map((order) {
                                          if (order.value == 0) return const SizedBox.shrink();
                                          final product = Get.find<InventoryController>().products.firstWhere((product) => product.id == order.key);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${order.value} ${product.name}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context).colorScheme.onBackground
                                                  ),
                                                ),
                                                Text(
                                                  formatCurrency(product.price * order.value),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context).colorScheme.onBackground
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.monetization_on_rounded,
                                        size: 20,
                                      ),
                                      SizedBox.fromSize(size: const Size(10, 0)),
                                      const Text(
                                        'Confirmar pedido',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ],
              )
            )
          ],
        )
    );
  }
}

void confirmOrder(String tabId, Map<String,int> order) {
  BillingController billingController = Get.find<BillingController>();
  TabModel currentTab = billingController.currentActiveTabs.firstWhere((tab) => tab.id == tabId);

  for (var currentQuantityOrder in order.entries) {
    final productResume = currentTab.productsResume.firstWhereOrNull((productResume) => productResume.productId == currentQuantityOrder.key) ?? ProductsResume(
      productId: currentQuantityOrder.key,
      name: Get.find<InventoryController>().products.firstWhere((product) => product.id == currentQuantityOrder.key).name,
      quantity: 0,
      subtotal: 0,
    );

    if (currentQuantityOrder.value > 0) {
      // add the difference to the tab
      final product = Get.find<InventoryController>().products.firstWhere((product) => product.id == productResume.productId);
      final products = List.generate(currentQuantityOrder.value, (index) => product);
      billingController.addProductsToTab(tabId, products);
    } else if (currentQuantityOrder.value < 0) {
      // remove the difference from the tab
      final product = Get.find<InventoryController>().products.firstWhere((product) => product.id == productResume.productId);
      final products = List.generate(currentQuantityOrder.value * -1, (index) => product);
      billingController.removeProductsFromTab(tabId, products);
    }
  }
}

Widget tabResumeInfo(BuildContext context, String tabId) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 26),
    child: Column(
      children: [
        // create a option to change the table, change the alias, delete the tab and a resume of the tab
        TextButton(
          onPressed: () {
            
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cambiar mesa',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                )
              ),
              Icon(
                Icons.change_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 14,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GetBuilder<BillingController>(
            builder: (controller) {
              TabModel currentTab = controller.currentActiveTabs.firstWhere((tab) => tab.id == tabId);
              return ListView(
                children: [
                  ...currentTab.productsResume.map((product) {
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Cantidad: ${product.quantity}'),
                      trailing: Text(formatCurrency(product.subtotal)),
                    );
                  }).toList(),
                ],
              );
            }
          ),
        ),
        TextButton(
          onPressed: () {
            // show a dialog to confirm the deletion of the tab
            showDialog(context: context, builder: (context) {
              return deleteTabWarning(context, tabId);
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Eliminar',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

AlertDialog deleteTabWarning(BuildContext context, String tabId) {
  BillingController billingController = Get.find<BillingController>();
  TabModel currentTab = billingController.currentActiveTabs.firstWhere((tab) => tab.id == tabId);

  return AlertDialog(
    title: const Text(
      'Eliminar cuenta',
    ),
    surfaceTintColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
    content: SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          Text('Estás seguro de eliminar la cuenta ${currentTab.alias} con una cuenta de ${formatCurrency(currentTab.subtotal)}'),
        ],
      ),
    ),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancelar',
        ),
      ),
      TextButton(
        onPressed: () {
          Get.find<BillingController>().removeTab(tabId);
          Get.back();
        },
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
        ),
        child: const Text('Eliminar'),
      ),
    ],
  );
}

AlertDialog busyTable(BuildContext context, TableModel table, TabModel newTab) {
  return AlertDialog(
    title: const Text(
      'Mesa ocupada',
    ),
    surfaceTintColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
    content: SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            child: ListView(
              children: table.tabIds.map((tab) {
                TabModel currentTab = Get.find<BillingController>().currentActiveTabs.firstWhere((currentTab) => currentTab.id == tab);
                
                return ListTile(
                  title: Text(currentTab.alias ?? currentTab.id),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 14,
                  ),
                  // todo parse the subtotal to a currency format
                  subtitle: Text('Creada ${getLastTimeUpdated(currentTab.createdAt!)} de \$${currentTab.subtotal}'),
                );
              }).toList()
              ,
            ),
          ),
          const SizedBox(height: 12),
          const Text('La mesa seleccionada ya tiene una cuenta asociada. ¿Deseas asociar esta cuenta a la mesa?'),
        ],
      ),
    ),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
        ),
        child: const Text(
          'Cancelar',
        ),
      ),
      TextButton(
        onPressed: () {
          // associate the tab with the table
          Get.find<BillingController>().addTab(newTab);
          Get.find<BillingController>().associateTabWithTable(newTab.id, table.id);
          // close the dialog and the previous dialog
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: const Text('Asociar'),
      ),
    ],
  );
}
