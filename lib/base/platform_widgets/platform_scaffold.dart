import 'platform_app_bar.dart';
import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformScaffold extends PlatformWidget<CupertinoPageScaffold, Scaffold> {
  final Widget child;
  final Color? backgroundColor;
  final PlatformAppBar? navigationBar;
  final FloatingActionButton? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  PlatformScaffold({
    required this.child,
    this.navigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  CupertinoPageScaffold createCupertinoWidget(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        navigationBar: navigationBar,
        // CupertinoNavigationBar(
        //   // border: showBorder ? const Border(bottom: BorderSide(width: 1, color: Colors.grey)) : null,
        //   backgroundColor: navigationBar?.backgroundColor,
        //   previousPageTitle: S.of(context).back,
        //   leading: navigationBar?.leading,
        //   automaticallyImplyLeading: navigationBar?.canGoBack ?? false,
        //   middle: navigationBar?.title,

        //   padding: const EdgeInsetsDirectional.only(start: 0),
        //   brightness: navigationBar?.brightness,
        // ),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        child: SafeArea(
          top: !extendBodyBehindAppBar,
          left: false,
          right: false,
          bottom: false,
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      );

  @override
  Scaffold createMaterialWidget(BuildContext context) => Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: navigationBar,
        body: child,
        floatingActionButton: floatingActionButton,
      );
}
