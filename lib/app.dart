import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/flavors.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'base/platform_widgets/platform_widgets.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final int index = 0;

  final materialTheme = ThemeData(
    fontFamily: "Sf Pro Display",
    visualDensity: VisualDensity.adaptivePlatformDensity,
    backgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        // backgroundColor: AppColors.blue,
        ),
  );

  final cupertinoTheme = const CupertinoThemeData(
    scaffoldBackgroundColor: Colors.white,
    // barBackgroundColor: AppColors.blue,
    brightness: Brightness.light,
    textTheme: CupertinoTextThemeData(
        // navActionTextStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        // actionTextStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        // navTitleTextStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
  );

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('nl', DutchMessages());

    return Observer(builder: (context) {
      return _flavorBanner(
        show: false, // F.appFlavor != Flavor.PROD,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          child: PlatformApp(
            title: 'Elia SSI Wallet',
            materialTheme: materialTheme,
            cupertinoTheme: cupertinoTheme,
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: Routes.acceptTermsAndConditions,
            globalNavKey: locator.get<NavigationService>().navigatorKey,
          ),
        ),
      );
    });
  }
}

Widget _flavorBanner({
  required Widget child,
  bool show = true,
}) =>
    show
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: Banner(
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.red.withOpacity(0.8),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0, color: Colors.white),
              textDirection: TextDirection.ltr,
              child: child,
            ),
          )
        : child;
