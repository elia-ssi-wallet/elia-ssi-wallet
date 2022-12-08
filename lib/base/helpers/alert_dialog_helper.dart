import 'dart:io';

import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showPlatformAlertDialog({required String title, String? subtitle, required List<MaterialButton> actions, bool isDismissable = false}) async {
  if (Platform.isIOS || Platform.isMacOS) {
    await showCupertinoDialog(
        context: locator.get<NavigationService>().navigatorKey.currentContext!,
        builder: (context) => PlatformAlertDialog(
              title: title,
              message: subtitle,
              actions: actions,
            ),
        barrierDismissible: isDismissable);
  } else {
    await showDialog(
        context: locator.get<NavigationService>().navigatorKey.currentContext!,
        builder: (context) => PlatformAlertDialog(
              title: title,
              message: subtitle,
              actions: actions,
            ),
        barrierDismissible: isDismissable);
  }
}
