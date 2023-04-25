import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showPlatformDatePicker(DateTime? selectedDate) async {
  DateTime? newDate;

  if (Platform.isIOS || Platform.isMacOS) {
    return await showCupertinoModalPopup<DateTime?>(
        context: locator.get<NavigationService>().router.navigatorKey.currentContext!,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                          child: Text(S.of(context).cancel),
                          onPressed: () {
                            context.popRoute();
                          }),
                      CupertinoButton(
                          child: Text(S.of(context).save),
                          onPressed: () {
                            context.popRoute(newDate);
                          }),
                    ],
                  ),
                  Flexible(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (selectedDate) => newDate = selectedDate,
                      initialDateTime: selectedDate,
                    ),
                  ),
                ],
              ),
            ));
  } else {
    return await showDatePicker(
      context: locator.get<NavigationService>().router.navigatorKey.currentContext!,
      firstDate: DateTime(1900, 1, 1, 00, 00),
      initialDate: selectedDate ?? DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(seconds: 1),
      ),
    );
  }
}
