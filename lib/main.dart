import 'package:elia_ssi_wallet/database/mobile.dart';
import 'package:flutter/material.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
// import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/globals.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  registerSingletons();

  database = constructDb();

  await clearSecureStorageOnReinstall();

  runApp(App());
}
