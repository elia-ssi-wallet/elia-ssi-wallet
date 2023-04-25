import 'package:flutter/material.dart';

class MyAppRouteInformationParser extends RouteInformationParser {
  @override
  Future<void> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    print("uri -> $uri");
  }
}
