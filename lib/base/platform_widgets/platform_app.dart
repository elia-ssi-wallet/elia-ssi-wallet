import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/route_observer.dart';
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
  CupertinoApp createCupertinoWidget(BuildContext context) => CupertinoApp.router(
        title: title,
        theme: cupertinoTheme,
        debugShowCheckedModeBanner: showDebugBanner,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        routerConfig: locator.get<NavigationService>().router.config(
              initialDeepLink: initialRoute,
              navigatorObservers: () => [
                MyObserver(),
              ],
            ),
        // routeInformationParser: AutoRouteInformation(location: location),
        // routerDelegate: locator.get<NavigationService>().router.delegate(),
        // routeInformationParser: MyRouteInformationParser(),
        // routeInformationParser: MyRouteInformationParser(),
        // routeInformationProvider: AutoRouteInformationProvider(),
        // routerDelegate: locator.get<NavigationService>().router.delegate(),
        // routeInformationParser: MyAppRouteInformationParser(),
        // routeInformationParser: MyAppRouteInformationParser(),
        // routerDelegate: AutoRouterDelegate(
        //   _appRouter,
        //   initialRoutes: [
        //     QrCodeScannerRoute(text: 'testing'),
        //   ],
        //   navigatorObservers: () => [
        //     AutoRouteObserver(),
        //   ],
        // ),
        // routeInformationParser: MyAppRouteInformationParser(),
      );

  @override
  MaterialApp createMaterialWidget(BuildContext context) => MaterialApp.router(
        title: title,
        theme: materialTheme,
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
        routerConfig: locator.get<NavigationService>().router.config(
              initialDeepLink: initialRoute,
              navigatorObservers: () => [
                MyObserver(),
              ],
            ),
      );
}
