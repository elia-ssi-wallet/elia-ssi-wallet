import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MyRouteInformationParser extends RouteInformationParser<AppRouter> {
  @override
  Future<AppRouter> parseRouteInformation(RouteInformation routeInformation) async {
    Logger().i(routeInformation.toString());
    AppRouter().pushNamed(routeInformation.location ?? "");
    return AppRouter();
  }
}
