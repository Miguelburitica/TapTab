import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/business/models/product_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/session_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/tab_model.dart';

class TabAdapter extends TypeAdapter<TabModel> {
  @override
  final typeId = 4;

  @override
  TabModel read(BinaryReader reader) {
    return TabModel(
      id: reader.readString(),
      tableId: reader.readString(),
      sessionId: reader.readString(),
      subtotal: reader.readDouble(),
      status: reader.read() == 1 ? TabStatus.active : TabStatus.closed,
      productsResume: reader.readList().map((product) => ProductsResume.fromJson(product)).toList(),
      alias: reader.readString(),
      createdAt: reader.read(),
      updatedAt: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, TabModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.tableId)
      ..writeString(obj.sessionId)
      ..writeDouble(obj.subtotal)
      ..write(obj.status == TabStatus.active ? 1 : 0)
      ..writeList(obj.productsResume)
      ..writeString(obj.alias ?? '')
      ..write(obj.createdAt)
      ..write(obj.updatedAt);
  }
}

class SessionAdapter extends TypeAdapter<SessionModel> {
  @override
  final typeId = 5;

  @override
  SessionModel read(BinaryReader reader) {
    return SessionModel(
      id: reader.readString(),
      createdAt: reader.read(),
      finishedAt: reader.read(),
      status: reader.read() == 1 ? CustomTabStatus.active : CustomTabStatus.closed,
      productsResume: reader.readList().map((product) => ProductsResume.fromJson(product)).toList(),
    );
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeString(obj.id)
      ..write(obj.createdAt)
      ..write(obj.finishedAt)
      ..write(obj.status == CustomTabStatus.active ? 1 : 0)
      ..writeList(obj.productsResume ?? []);
  }
}
