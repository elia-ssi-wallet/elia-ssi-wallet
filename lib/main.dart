import 'package:flutter/material.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
// import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  registerSingletons();

  await clearSecureStorageOnReinstall();

  runApp(App());
}
