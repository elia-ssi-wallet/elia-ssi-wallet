import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformBottomBar extends PlatformWidget<CupertinoTabBar, Widget> {
  final List<BottomNavigationBarItem> items;
  final Function(int) onTap;
  final int currentIndex;
  final Color? activeColor;
  final Color? inActiveColor;

  PlatformBottomBar({
    required this.items,
    required this.onTap,
    required this.currentIndex,
    required this.inActiveColor,
    this.activeColor,
  });

  @override
  CupertinoTabBar createCupertinoWidget(BuildContext context) => CupertinoTabBar(
        currentIndex: currentIndex,
        items: items,
        onTap: onTap,
        activeColor: activeColor,
        inactiveColor: inActiveColor ?? CupertinoColors.inactiveGray,
        backgroundColor: Colors.white,
      );

  @override
  BottomNavigationBar createMaterialWidget(BuildContext context) => BottomNavigationBar(
        items: items,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: activeColor,
        unselectedItemColor: inActiveColor,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      );
}
