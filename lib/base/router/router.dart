import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_route.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_scaffold.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/pages/accept_terms_and_conditions/accept_terms_and_conditions_screen.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contracts_screen.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/confirm_contract_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen.dart';
import 'package:elia_ssi_wallet/pages/loading_screen/loading_screen.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/pending_screen.dart';
import 'package:elia_ssi_wallet/pages/qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class MyRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return PlatformRoute(
          route: HomeScreen(),
          // ignore: prefer_const_literals_to_create_immutables
          settings: RouteSettings(name: settings.name, arguments: {}),
        );
      case Routes.qr:
        return PlatformRoute(route: QrCodeScanner(), settings: settings);
      case Routes.loading:
        return PlatformRoute(route: LoadingScreen(url: settings.arguments as String), settings: settings);
      case Routes.dbViewer:
        return PlatformRoute(route: DriftDbViewer(database), settings: settings);
      case Routes.confirmContract:
        return PlatformRoute(route: ConfirmContract(vp: settings.arguments as dynamic), settings: settings);
      case Routes.acceptTermsAndConditions:
        return PlatformRoute(route: AcceptTermsAndConditions(), settings: settings);
      case Routes.pendingRequests:
        return PlatformRoute(route: PendingScreen(), settings: settings);
      case Routes.compatibleContractsScreen:
        return PlatformRoute(
            route: CompatibleContractsScreen(
              type: (settings.arguments as dynamic)['type'],
              exchangeId: (settings.arguments as dynamic)['exchangeId'],
            ),
            settings: settings);

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
