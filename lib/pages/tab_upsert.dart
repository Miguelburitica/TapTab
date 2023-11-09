import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/billing_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:tap_tab_pedidos_y_cuentas/utils.dart';
import 'package:uuid/v1.dart';


class TabUpsertPage extends StatelessWidget {
  const TabUpsertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableTables = Get.find<BillingController>().tables;
    
    TableModel currentTable = availableTables.first;
    TextEditingController aliasController = TextEditingController();

    return Layout(
      title: 'Nueva cuenta',
      body: Column(
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
                    alias: aliasController.text,
                    subtotal: 0,
                    products: [],
                    status: TabStatus.active,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
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
      ),
    );
  }
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
