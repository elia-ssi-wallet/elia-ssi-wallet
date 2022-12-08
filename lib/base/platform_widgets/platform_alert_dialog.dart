import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends PlatformWidget<CupertinoAlertDialog, AlertDialog> {
  final String? title;
  final String? message;
  final List<MaterialButton> actions;

  PlatformAlertDialog({
    required this.title,
    this.message,
    required this.actions,
  });

  @override
  CupertinoAlertDialog createCupertinoWidget(BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title!) : null,
        content: message != null ? Text(message!) : null,
        actions: [
          ...actions.map((action) => CupertinoButton(
              child: action.child!,
              onPressed: () {
                action.onPressed!();
                // Navigator.of(context).pop();
              })),
        ],
      );

  @override
  AlertDialog createMaterialWidget(BuildContext context) => AlertDialog(
        title: title != null ? Text(title!) : null,
        content: message != null ? Text(message!) : null,
        actions: [
          ...actions.map((action) => action),
        ],
      );
}
