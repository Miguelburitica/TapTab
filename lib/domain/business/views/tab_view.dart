import 'package:flutter/material.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/tab_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/utils.dart';

class TabCard extends StatelessWidget {
  final TabModel tab;
  
  const TabCard({
    required this.tab,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              tab.alias ?? 'N/A',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Cantidad',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Producto',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: tab.productsResume.map((product) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(product.quantity.toString())),
                        DataCell(Text(product.name.toString())),
                      ],
                    )).toList(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Text('Subtotal: ${tab.subtotal}'),
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
    return GridView.builder(
      itemCount: tabs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of products in a row
        crossAxisSpacing: 10, // spacing between products horizontally
        mainAxisSpacing: 10, // spacing between products vertically
      ),
      itemBuilder: (context, index) {
        return TabCard(tab: tabs[index]);
      },
    );
  }
}
