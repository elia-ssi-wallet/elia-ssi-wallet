import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    debugPrint(router.currentUrl);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool? accepted = sharedPreferences.getBool("tos_accepted");

    if (accepted == true) {
      resolver.next();
    } else {
      router.pushAndPopUntil(
        AcceptTermsAndConditionsRoute(onSuccess: (success) {
          resolver.next();
        }),
        predicate: (route) => false,
      );
    }
  }
}
