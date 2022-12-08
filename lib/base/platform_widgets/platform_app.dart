import 'package:elia_ssi_wallet/base/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../generated/l10n.dart';

import 'platform_widget.dart';

class PlatformApp extends PlatformWidget<CupertinoApp, MaterialApp> {
  final ThemeData materialTheme;
  final CupertinoThemeData cupertinoTheme;
  final Widget? home;
  final String title;
  final Iterable<Locale> supportedLocales;
  final GlobalKey<NavigatorState>? globalNavKey;
  final Locale? locale;
  final dynamic builder;
  final String initialRoute;
  final bool showDebugBanner;

  PlatformApp({
    this.globalNavKey,
    required this.materialTheme,
    required this.cupertinoTheme,
    this.home,
    required this.title,
    required this.supportedLocales,
    this.locale,
    this.builder,
    this.initialRoute = '/',
    this.showDebugBanner = true,
  });

  @override
  CupertinoApp createCupertinoWidget(BuildContext context) => CupertinoApp(
        title: title,
        theme: cupertinoTheme,
        navigatorKey: globalNavKey,
        debugShowCheckedModeBanner: showDebugBanner,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        initialRoute: initialRoute,
        onGenerateRoute: MyRouter.onGenerateRoute,
      );

  @override
  MaterialApp createMaterialWidget(BuildContext context) => MaterialApp(
        title: title,
        theme: materialTheme,
        navigatorKey: globalNavKey,
        debugShowCheckedModeBanner: showDebugBanner,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        locale: locale,
        builder: builder,
        supportedLocales: supportedLocales,
        initialRoute: initialRoute,
        onGenerateRoute: MyRouter.onGenerateRoute,
      );
}
