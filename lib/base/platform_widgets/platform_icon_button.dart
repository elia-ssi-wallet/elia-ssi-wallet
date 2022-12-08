import 'package:flutter/cupertino.dart';

import 'platform_widget.dart';
import 'package:flutter/material.dart';

class PlatformIconButton extends PlatformWidget<CupertinoButton, Material> {
  final Widget icon;
  final Color backgroundColor;
  final Function() onPressed;
  final Color? splashColor;
  final double? splashRadius;

  PlatformIconButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    this.splashColor,
    this.splashRadius,
  });

  @override
  CupertinoButton createCupertinoWidget(BuildContext context) => CupertinoButton(
        onPressed: onPressed,
        color: backgroundColor,
        padding: EdgeInsets.zero,
        child: icon,
      );

  @override
  Material createMaterialWidget(BuildContext context) => Material(
      color: backgroundColor,
      child: IconButton(
        icon: icon,
        splashColor: splashColor,
        splashRadius: splashRadius,
        onPressed: onPressed,
      ));
}
