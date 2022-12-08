import 'platform_bottom_bar.dart';
import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTabScaffold extends PlatformWidget<CupertinoTabScaffold, Scaffold> {
  final PlatformBottomBar bottomBar;
  final Widget Function(BuildContext, int) tabBuilder;
  final Widget body;
  final int index;

  PlatformTabScaffold({required this.index, required this.body, required this.bottomBar, required this.tabBuilder});

  @override
  CupertinoTabScaffold createCupertinoWidget(BuildContext context) => CupertinoTabScaffold(
        tabBar: bottomBar.createCupertinoWidget(context),
        tabBuilder: tabBuilder,
      );

  @override
  Scaffold createMaterialWidget(BuildContext context) => Scaffold(
        body: body,
        bottomNavigationBar: bottomBar,
      );
}
