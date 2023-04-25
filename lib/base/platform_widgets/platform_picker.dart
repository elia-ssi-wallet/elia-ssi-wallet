import 'package:auto_route/auto_route.dart';

import '../../generated/l10n.dart';

import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlatformPicker<T> extends PlatformWidget<Widget, Widget> {
  T? newValue;

  PlatformPicker({required this.newValue});

  @override
  Widget createCupertinoWidget(BuildContext context) => Container(
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
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (selectedDate) => newValue = selectedDate as T?,
              ),
            ),
          ],
        ),
      );

  @override
  Widget createMaterialWidget(BuildContext context) => Material(
        color: Colors.transparent,
        child: DatePickerDialog(
          firstDate: DateTime.now()..add(const Duration(days: 10)),
          initialDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(milliseconds: 1)),
        ),
      );
}
