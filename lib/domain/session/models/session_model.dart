import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';

enum CustomTabStatus {
  active,
  closed,
}

@HiveType(typeId: 5)
class SessionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  DateTime createdAt;
  @HiveField(2)
  DateTime? finishedAt;
  @HiveField(3)
  List<ProductsResume>? productsResume = [];
  @HiveField(4)
  CustomTabStatus? status = CustomTabStatus.active;

  SessionModel({
    required this.id,
    required this.createdAt,
    this.finishedAt,
    this.status,
    this.productsResume,
  });

  void closeSession() {
    finishedAt = DateTime.now();
  }
}