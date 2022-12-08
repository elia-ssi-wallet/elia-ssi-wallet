import 'dart:io';

import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_action_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showPlatformActionDialog({required String title, required List<Widget> actions, required List<Function()> functions}) async {
  if (Platform.isIOS || Platform.isMacOS) {
    await showCupertinoModalPopup(
        context: locator.get<NavigationService>().navigatorKey.currentContext!,
        builder: (context) => PlatformActionDialog(
              title: title,
              actions: actions,
              functions: functions,
            ));
  } else {
    await showModalBottomSheet(
        context: locator.get<NavigationService>().navigatorKey.currentContext!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) => PlatformActionDialog(
              title: title,
              actions: actions,
              functions: functions,
            ));
  }
}
