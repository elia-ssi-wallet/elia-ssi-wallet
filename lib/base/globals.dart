library globals;

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:logger/logger.dart';

import 'secure_storage.dart';

late dynamic database;

Codec<String, String> stringToBase64 = utf8.fuse(base64);

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//boolean for proxyman
bool enableProxyman = false; //kIsWeb || Platform.isAndroid ? false : true;

String? userId;

late ui.Image bookOverlay;

// String apiUrlGlobal = F.apiUrl;

logout() async {
  //delete all from database
  await database.deleteDatabase();

  //delete secureStorage
  await SecureStorage.deleteAll();
}

Future<void> initSentry() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = "https://a81611a484ef411c8b16f4b4a0754371@sentry.appwi.se/309";
    },
  );
}
parseLink({required Uri? link}) {
  print("LINK => $link");
  if (link == null) {
    locator.get<NavigationService>().router.push(NotFoundScreenRoute(errorMessage: "Invalid url"));
  }
  var param = link?.queryParameters["exchangeObject"];
  if (param == null || param.isEmpty) {
    locator.get<NavigationService>().router.push(NotFoundScreenRoute(errorMessage: "Invalid url"));
  } else {
    var decodedParam = stringToBase64.decode(param);
    String? url = ExchangeRepository.verifyObject(object: jsonDecode(decodedParam));

    Logger().d("deep link param => $param");
    Logger().d("deep link param encoded => $decodedParam");

    if (url != null) {
      locator.get<NavigationService>().router.push(LoadingScreenRoute(url: url));
    } else {
      locator.get<NavigationService>().router.push(NotFoundScreenRoute(errorMessage: "Invalid url"));
    }
  }
}

String? parseInitalLink({required Uri? link}) {
  print("INITIAL LINK => $link");
  if (link == null) {
    // locator.get<NavigationService>().router.push(NotFoundScreenRoute(errorMessage: "error bij parsen van url"));
    return null;
  }
  var param = link.queryParameters["exchangeObject"];
  if (param == null || param.isEmpty) {
    // locator.get<NavigationService>().router.push(NotFoundScreenRoute(errorMessage: "Invalid url"));
    return "/error";
  } else {
    var decodedParam = stringToBase64.decode(param);
    String? url = ExchangeRepository.verifyObject(object: jsonDecode(decodedParam));

    Logger().d("deep link param => $param");
    Logger().d("deep link param encoded => $decodedParam");

    if (url != null) {
      // locator.get<NavigationService>().router.push(LoadingScreenRoute(url: url));
      return "/loading?url=$url";
    } else {
      // locator.get<NavigationService>().router.push(NotFoundScreenRoute(errorMessage: "error bij parsen van url"));
      return "/error";
    }
  }
  // return null;
}
