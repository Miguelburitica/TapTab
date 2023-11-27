import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/controllers/session_controller.dart';
import 'package:tap_tab_pedidos_y_cuentas/layout.dart';

class BillingReportPage extends StatelessWidget {
  const BillingReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.put(SessionController());
    
    return Layout(
      title: 'Reporte de ventas',
      body: Column(
        children: [
          // per day show a list of sessions with the total amount computed by the session.productsResume
          ...sessionController.historySessions.map((session) {
            return Row(
              children: [
                Text(session.createdAt.toString()),
                Text(session.productsResume.toString()),
              ],
            );
          })
        ],
      ),
    );
  }
}