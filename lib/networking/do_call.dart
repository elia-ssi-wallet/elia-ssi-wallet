// ignore_for_file: depend_on_referenced_packages, unused_catch_stack

import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> doCall<T>(
  Future<dynamic> networkCall, {
  Function(T _)? succesFunction,
  Function(dynamic error)? errorFunction,
  bool showDialogs = true,
  bool fullError = false,
}) async {
  T response;

  try {
    response = await networkCall;

    if (succesFunction != null) {
      await succesFunction(response);
    }

    return response;
  } catch (e, stackTrace) {
    // print("Error => $e | $stackTrace");

    if (showDialogs) {
      if (e is DioError) {
        if (isIos) {
          showAlertDialog(title: S.current.app_name, message: e.message);
        } else {
          showSnackBar(message: e.message);
        }
      } else {
        if (isIos) {
          showAlertDialog(title: S.current.app_name, message: e.toString());
        } else {
          showSnackBar(message: e.toString());
        }
      }
    }

    if (errorFunction != null) {
      await errorFunction(e);
    }
  }
  return null;
}

void showSnackBar({required String? message}) {
  ScaffoldMessenger.of(locator.get<NavigationService>().navigatorKey.currentContext!).clearSnackBars();
  ScaffoldMessenger.of(locator.get<NavigationService>().navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(message ?? "")));
}

Future<dynamic> showAlertDialog({required String? title, required String? message, Function()? onPressed}) {
  bool isVisible = false;
  if (!isVisible) {
    isVisible = true;
    return showDialog(
      context: locator.get<NavigationService>().navigatorKey.currentContext!,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(message ?? ""),
        actions: [
          CupertinoButton(
              onPressed: onPressed ??
                  () {
                    isVisible = false;
                    locator.get<NavigationService>().navigatorKey.currentState?.pop();
                  },
              child: const Text("OK"))
        ],
      ),
    );
  }
}
