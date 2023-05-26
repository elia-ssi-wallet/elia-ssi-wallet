// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// import 'package:elia_ssi_wallet/flavors.dart';

import '../base/globals.dart';
import 'error_interceptor.dart';

abstract class BaseRestClient {
  String apiUrl();
  bool isProtected();
  bool fullError();

  Dio normalDio = Dio(
    BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 60000,
      sendTimeout: 120000,
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.acceptLanguageHeader: "en",
      },
    ), // Localizations.localeOf(navigatorKey.currentContext!).languageCode}),
  )..interceptors.addAll(
      [
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
        ErrorInterceptor(),
      ],
    );

  Dio get dio {
    BaseOptions options = BaseOptions(
      // baseUrl: apiUrl(),
      // baseUrl: apiUrlGlobal,
      // baseUrl: F.apiUrl,
      // connectTimeout: 10000,
      // receiveTimeout: 6000,
      connectTimeout: 20000,
      receiveTimeout: 20000,
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.acceptLanguageHeader: "en",
      },
    ); // Localizations.localeOf(navigatorKey.currentContext!).languageCode}),

    var dio = Dio(options);

    dio
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
        if (isProtected()) {}

        handler.next(options);
      }, onError: (error, handler) async {
        return handler.next(error);
      }))
      ..interceptors.add(ErrorInterceptor(fullError: fullError()));

    //!PROXYMAN (do not forget to import 'package:dio/adapter.dart')
    if (kDebugMode && enableProxyman && !kIsWeb) {
      print("do proxyman");
      //                                  <computer_ip_address:9090>
      String proxy = Platform.isAndroid ? '192.168.2.187:9090' : 'localhost:9090';

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        // Hook into the findProxy callback to set the client's proxy.
        client.findProxy = (url) {
          return "PROXY $proxy";
        };

        // This is a workaround to allow Proxyman to receive
        // SSL payloads when your app is running on Android.
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => Platform.isAndroid;
        return client;
      };
    }

    return dio;
  }
}
