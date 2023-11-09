import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/controllers/billing_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/table_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';
import 'package:uuid/v1.dart';

class CreateTablePage extends StatelessWidget {
  const CreateTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTables = Get.find<BillingController>().tables;
    
    final arguments = Get.arguments;
    final String? optionalMessage = arguments != null ? arguments['message'] : null;

    TextEditingController aliasController = TextEditingController();
    aliasController.value = TextEditingValue(text: 'Mesa ${currentTables.length + 1}');

    return Layout(
      title: 'Crear mesa',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crear mesa',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          if (optionalMessage != null) Text(optionalMessage, style: TextStyle(color: Theme.of(context).colorScheme.error),),
          if (optionalMessage != null) const SizedBox(height: 12),
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: aliasController,
                  decoration: const InputDecoration(
                    labelText: 'Alias',
                    hintText: 'Alias de la mesa',
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
                  Navigator.of(context).pop();
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
                  // create the new table
                  final newTable = TableModel(
                    id: const UuidV1().generate(),
                    name: 'Mesa ${currentTables.length + 1}',
                    alias: aliasController.text,
                    tabIds: [],
                  );
                  Get.find<BillingController>().addTable(newTable);
                  
                  if (optionalMessage != null) {
                    Get.back();
                    Get.toNamed('/tab-upsert');
                  } else {
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