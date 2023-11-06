import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:orders_handler/layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
              children: const [
                Center(child: Text('Pedidos')),
                Center(child: Text('Mesas'))
              ]
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_tabController.indexIsChanging && _tabController.index == 0) {
            Get.toNamed('/create-tab');
          } else {
            
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
