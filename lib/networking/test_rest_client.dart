// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:dio/dio.dart';

class TestRestClient {
  Dio get dio {
    BaseOptions options = BaseOptions(
      connectTimeout: 20000,
      receiveTimeout: 20000,
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.acceptLanguageHeader: "en",
      },
    );

    var dio = Dio(options);

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
}
