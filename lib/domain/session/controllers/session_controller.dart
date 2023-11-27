import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/session_model.dart';
import 'package:tap_tab_pedidos_y_cuentas/domain/session/models/tab_model.dart';
import 'package:uuid/v1.dart';

class SessionController extends GetxController {
  SessionModel? currentSession;
  List<SessionModel> historySessions = [];
  Box<SessionModel>? sessionBox;

  @override
  void onInit() async {
    sessionBox = await Hive.openBox<SessionModel>('session');
    
    // validate if the box is empty, if it is not, then load the data
    if (sessionBox!.isNotEmpty) {
      historySessions = sessionBox!.values.toList();
      currentSession = sessionBox!.values.firstWhere((session) => session.status == CustomTabStatus.active);
    }
    super.onInit();
  }

  void createSession() {
    SessionModel newSession = SessionModel(
      id: const UuidV1().generate(),
      createdAt: DateTime.now(),
      productsResume: [],
      status: CustomTabStatus.active,
      finishedAt: DateTime.now(),
    );

    sessionBox!.put(newSession.id, newSession);
    currentSession = newSession;
    update();
  }

  void tabPayed(TabModel tab) {
    currentSession!.productsResume!.addAll(tab.productsResume);
    sessionBox!.put(currentSession!.id, currentSession!);
    update();
  }

  void closeSession() {
    currentSession!.closeSession();
    sessionBox!.put(currentSession!.id, currentSession!);
    update();
  }
}