import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/database/mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //on iOS after full screen splash notification bar is not automatically set again
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  String initialRoute = Routes.acceptTermsAndConditions;

  registerSingletons();

  database = constructDb();

  clearSecureStorageOnReinstall();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  bool? accepted = sharedPreferences.getBool("tos_accepted");

  if (accepted == true) {
    initialRoute = Routes.home;
  }

  runApp(App(initialRoute: initialRoute));

  FlutterNativeSplash.remove();
}
