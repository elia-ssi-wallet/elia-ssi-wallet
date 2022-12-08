import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformLoadingIndicator extends PlatformWidget<CupertinoActivityIndicator, CircularProgressIndicator> {
  final double radius;
  final Color? color;

  PlatformLoadingIndicator({
    this.radius = 10.0,
    this.color,
  });

  @override
  CupertinoActivityIndicator createCupertinoWidget(BuildContext context) => CupertinoActivityIndicator(
        radius: radius,
        color: color,
      );

  @override
  CircularProgressIndicator createMaterialWidget(BuildContext context) => CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
      );
}
