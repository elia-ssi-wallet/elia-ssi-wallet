import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

import 'platform_widget.dart';

// ignore: must_be_immutable
class PlatformDatePicker extends PlatformWidget<Widget, Widget> {
  DateTime? newDate;

  PlatformDatePicker({Key? key, required this.newDate}) : super();

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
                      context.popRoute(newDate);
                    }),
              ],
            ),
            Flexible(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (selectedDate) => newDate = selectedDate,
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
