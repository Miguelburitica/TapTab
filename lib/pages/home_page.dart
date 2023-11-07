import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orders_handler/domain/billing/controller.dart';
import 'package:orders_handler/domain/billing/models/tab_model.dart';
import 'package:orders_handler/domain/billing/models/table_model.dart';
import 'package:orders_handler/domain/billing/views/tab_view.dart';
import 'package:orders_handler/layout.dart';
import 'package:uuid/v1.dart';
import 'package:orders_handler/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BillingController billingController = Get.put(BillingController());

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.attach_money_rounded, // todo improve icons
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.table_bar_rounded, // todo improve icons
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GetBuilder<BillingController>(
                  builder: (controller) {
                    return TabGrid(tabs: controller.currentActiveTabs);
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  child: Column(
                    children: [
                      const Text('Aquí se mostrará el mapa de las mesas, por ahora colocaré la lista de mesas que hay creadas'),
                      GetBuilder<BillingController>(
                        builder: (controller) {
                          return Column(
                            children: controller.tables.map((table) {
                              return ListTile(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_tabController.indexIsChanging && _tabController.index == 0) {
            showDialog(context: context, builder: (context) {
              if (billingController.tables.isEmpty) {
                return createTableDialog(context, optionalMessage: 'No hay mesas creadas. Crea una mesa para poder crear una cuenta.');
              }
              
              return createTabDialog(context);
            });
          } else {
            showDialog(context: context, builder: createTableDialog);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

AlertDialog createTableDialog(BuildContext context, {String? optionalMessage}) {
  final currentTables = Get.find<BillingController>().tables;

  TextEditingController aliasController = TextEditingController();
  aliasController.value = TextEditingValue(text: 'Mesa ${currentTables.length + 1}');
  
  return AlertDialog(
    title: const Text('Crear mesa'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (optionalMessage != null) Text(optionalMessage, style: TextStyle(color: Theme.of(context).colorScheme.error),),
        if (optionalMessage != null) const SizedBox(height: 12),
        TextField(
          controller: aliasController,
          decoration: const InputDecoration(
            labelText: 'Alias',
            hintText: 'Alias de la mesa',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          ],
        ),
      ],
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
          // create the new table
          final newTable = TableModel(
            id: const UuidV1().generate(),
            name: 'Mesa ${currentTables.length + 1}',
            alias: aliasController.text,
            tabIds: [],
          );
          Get.find<BillingController>().addTable(newTable);
          
          Navigator.of(context).pop();
          showDialog(context: context, builder: createTabDialog);
        },
        child: const Text('Crear'),
      ),
    ],
  );
}

AlertDialog createTabDialog(BuildContext context) {
  final availableTables = Get.find<BillingController>().tables;
  TableModel currentTable = availableTables.first;
  TextEditingController aliasController = TextEditingController();
  
  return AlertDialog(
    title: const Text('Crear cuenta'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField(
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
          ),
          keyboardType: TextInputType.text,
        ),
      ],
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
          // create the new tab
          TabModel newTab = TabModel(
            id: const UuidV1().generate(),
            tableId: currentTable.id,
            alias: aliasController.text,
            subtotal: 0,
            items: [],
            status: TabStatus.active,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          if (currentTable.tabIds.isNotEmpty) {
            // warning the user that the table already has a bill
            Navigator.maybePop(context);
            showDialog(context: context, builder: (context) {
              return busyTable(context, currentTable, newTab);
            });
          } else {
            Get.find<BillingController>().addTab(newTab);
            Get.find<BillingController>().associateTabWithTable(newTab.id, currentTable.id);
            
            Navigator.of(context).pop();
          }
        },
        child: const Text('Crear'),
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
