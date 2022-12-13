import 'package:elia_ssi_wallet/base/platform_widgets/platform_route.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_scaffold.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen.dart';
import 'package:elia_ssi_wallet/pages/qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class MyRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return PlatformRoute(route: HomeScreen(), settings: settings);
      case Routes.qr:
        return PlatformRoute(route: QRCodeScanner(), settings: settings);

      default:
        return PlatformRoute(
            route: PlatformScaffold(
          child: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ));
    }
  }
}
