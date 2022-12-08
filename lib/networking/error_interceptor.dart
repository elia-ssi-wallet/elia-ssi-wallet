// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({this.fullError = false});

  final bool fullError;
  @override
  Future onError(DioError err, handler) async {
    Logger().e(err.toString());
    Logger().e(err.response.toString());

    late DioError dioError;

    //if there is no network available
    if (err.response == null) {
      dioError = DioError(requestOptions: err.requestOptions, error: S.current.network_error_no_internet_connection);
      return handler.reject(dioError);
    }

    switch (err.response?.statusCode) {
      case 400:
        {
          var validationError = err.response?.data["message"];

          dioError = DioError(requestOptions: err.requestOptions, error: validationError ?? S.current.login_error);

          break;
        }
      case 401:
        {
          dioError = DioError(requestOptions: err.requestOptions, error: S.current.login_error);
          break;
        }
      case 404:
        {
          dioError = DioError(requestOptions: err.requestOptions, error: S.current.network_error);
          break;
        }
      case 422:
        {
          if (fullError) {
            var validationError = err.response?.data["errors"];

            String msg = validationError == null ? S.current.error_default : jsonEncode(validationError);
            dioError = DioError(requestOptions: err.requestOptions, error: msg);
            break;
          } else {
            var validationError = err.response?.data["errors"];

            String msg = validationError == null ? S.current.error_default : "";
            validationError?.forEach((key, value) {
              for (var item in value) {
                msg += "$item\n";
              }
            });

            dioError = DioError(requestOptions: err.requestOptions, error: msg.trim());

            break;
          }
        }
      default:
        {
          var validationError = err.response?.data["message"];

          dioError = DioError(requestOptions: err.requestOptions, error: validationError ?? S.current.login_error);

          break;
        }
    }

    handler.reject(dioError);
  }
}
