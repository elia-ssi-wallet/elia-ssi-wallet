import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends PlatformWidget<CupertinoSwitch, Switch> {
  final bool value;
  final Function(bool) onChanged;
  final Color? activeColor;

  PlatformSwitch({required this.value, required this.onChanged, this.activeColor});

  @override
  CupertinoSwitch createCupertinoWidget(BuildContext context) => CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );

  @override
  Switch createMaterialWidget(BuildContext context) => Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );
}
