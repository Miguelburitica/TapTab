import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/table_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/inventory_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/controllers/session_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/controllers/tab_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/views/tab_view.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TableController tableController = Get.put(TableController());
  final TabSessionController billingController = Get.put(TabSessionController());
  final InventoryController inventoryController = Get.put(InventoryController());

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    
    return Layout(
      appBar: AppBar(
        title: const Text('Pedidos y Cuentas'),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed('/config');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<SessionController>(
        builder: (controller) {
          Widget body = Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money_rounded, // todo improve icons
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text('Cuentas')
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_bar_rounded, // todo improve icons
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text('Mesas')
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GetBuilder<TabSessionController>(
                      builder: (controller) {
                        return TabGrid(tabs: controller.currentActiveTabs);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                      child: Column(
                        children: [
                          const Text('Aquí se mostrará el mapa de las mesas, por ahora colocaré la lista de mesas que hay creadas'),
                          GetBuilder<TableController>(
                            builder: (controller) {
                              return Column(
                                children: controller.tables.map((table) {
                                  return ListTile(
                                    onLongPress: () {
                                      Get.defaultDialog(
                                        title: 'Eliminar mesa',
                                        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 14),
                                        content: Text('¿Estás seguro de que quieres eliminar ${table.alias ?? table.name}?'),
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
                                            controller.removeTable(table.id);
                                            Get.back();
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context).colorScheme.error,
                                            backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                                          ),
                                          child: const Text('Eliminar'),
                                        ),
                                      );
                                    },
                                    title: Text(table.alias ?? table.name),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 14,
                                    ),
                                    onTap: () {
                                      Get.toNamed('/table', arguments: table);
                                    },
                                  );
                                }).toList(),
                              );
                            }
                          )
                        ],
                      ),
                    )
                  ]
                ),
              )
            ],
          );

          if (sessionController.currentSession == null) {
            body = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No hay sesión activa'),
                  const SizedBox(height: 24),
                  // a red rounded button to create a new session
                  ElevatedButton(
                    onPressed: () {
                      sessionController.createSession();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide.none,
                      ),
                      padding: const EdgeInsets.all(94),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Crear sesión'),
                  )
                ],
              ),
            );
          }

          return body;
        },
      ),
      floatingActionButton: sessionController.currentSession != null
        ? FloatingActionButton(
          onPressed: () {
            if (!_tabController.indexIsChanging && _tabController.index == 0) {
              if (tableController.tables.isEmpty) {
                Get.toNamed('/table-create', arguments: {'message': 'No hay mesas creadas. Crea una mesa para poder crear una cuenta.'});
              } else {
                Get.toNamed('/tab-upsert');
              }
            } else {
              Get.toNamed('/table-create');
            }
          },
          child: const Icon(Icons.add),
        )
        : null,
    );
  }
}
