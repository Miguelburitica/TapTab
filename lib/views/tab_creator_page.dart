import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orders_handler/domain/billing/table_model.dart';
import 'package:orders_handler/layout.dart';
import 'package:uuid/v1.dart';

class TabCreatorPage extends StatefulWidget {
  const TabCreatorPage({super.key});

  @override
  State<TabCreatorPage> createState() => _TabCreatorPageState();
}

class _TabCreatorPageState extends State<TabCreatorPage> with SingleTickerProviderStateMixin {
  final List<TableModel> currentTables = []; // Get the tables from the current state

  @override
  void initState() {
    currentTables.addAll([
      TableModel(id: UuidV1(), name: '1'),
      TableModel(id: UuidV1(), name: '2'),
      TableModel(id: UuidV1(), name: '3'),
    ]);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Crear nueva cuenta',
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField(
                  onChanged: (value) {
                    
                  },
                  items: currentTables.map((TableModel table) {
                    return DropdownMenuItem(value: table.id, child: Text(table.name));
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Mesa',
                    hintText: 'Selecciona mesa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // input for the table alias
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Alias',
                    hintText: 'Alias de la cuenta',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }  
}
