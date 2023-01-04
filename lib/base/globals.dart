library globals;

import 'dart:ui' as ui;

import 'secure_storage.dart';

late dynamic database;
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//boolean for proxyman
bool enableProxyman = false; //kIsWeb || Platform.isAndroid ? false : true;

String? userId;

late ui.Image bookOverlay;

// String apiUrlGlobal = F.apiUrl;

logout() async {
  //delete all from database
  await database.deleteDatabase();

  //delete secureStorage
  await SecureStorage.deleteAll();
}
