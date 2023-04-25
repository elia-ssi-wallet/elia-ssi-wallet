import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

Future<T?> showPlatformPicker<T>({required List<T?> items, int? index}) async {
  T? newValue;

  if (Platform.isIOS || Platform.isMacOS) {
    return await showCupertinoModalPopup<T?>(
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
                            context.popRoute(newValue);
                          }),
                    ],
                  ),
                  Flexible(
                      child: SizedBox(
                          height: 200.0,
                          child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(initialItem: index ?? 0),
                              itemExtent: 50.0,
                              onSelectedItemChanged: (int value) {
                                newValue = items[value];
                              },
                              backgroundColor: Colors.white,
                              children: items.map((e) => Center(child: Text(e.toString()))).toList()))),
                ],
              ),
            ));
  } else {
    // return await showDatePicker(
    //   context: getIt.get<NavigationService>().navigatorKey.currentContext!,
    //   firstDate: DateTime(1900, 1, 1, 00, 00),
    //   lastDate: DateTime.now().add(
    //     Duration(seconds: 1),
    //   ),
    // );
  }
  return null;
}
