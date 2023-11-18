import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/controllers/tab_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/utils.dart';

class TabCard extends StatelessWidget {
  final TabModel tab;
  
  const TabCard({
    required this.tab,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/tab-upsert', arguments: { 'tabId': tab.id });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                tab.alias ?? 'N/A',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              GetBuilder<TabSessionController>(
                builder: (controller) {
                  final currentTab = controller.currentActiveTabs.firstWhereOrNull((element) => element.id == tab.id) ?? tab;

                  return Expanded(
                    child: ListView(
                      children: [
                        for (final product in currentTab.productsResume)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${product.quantity} ${product.name}'),
                              Text(formatCurrency(product.subtotal)),
                            ],
                          ),
                      ],
                    ),
                  );
                }
              ),
              const Divider(),
              Text('Subtotal: ${formatCurrency(tab.subtotal)}'),
              // mostrar hace cuanto tiempo se hizo el último pedido
              Text(getLastTimeUpdated(tab.updatedAt ?? tab.createdAt!)),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  // Implement your payment logic here
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monetization_on_rounded,
                      size: 20,
                    ),
                    SizedBox.fromSize(size: const Size(10, 0)),
                    const Text(
                      'Paga',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabGrid extends StatelessWidget {
  final List<TabModel> tabs;

  const TabGrid({
    required this.tabs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) return const Center(child: Text('No hay cuentas activas'));
    return GridView.builder(
      itemCount: tabs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of products in a row
        crossAxisSpacing: 10, // spacing between products horizontally
        mainAxisSpacing: 10, // spacing between products vertically
        childAspectRatio: 0.6, // width / height
      ),
      itemBuilder: (context, index) {
        return TabCard(tab: tabs[index]);
      },
    );
  }
}
