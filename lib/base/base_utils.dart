// ignore_for_file: library_prefixes

import 'dart:core';
import 'dart:io';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart';
import '../../generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'secure_storage.dart';

launchUrl({required String url}) async {
  Uri? uri = Uri.tryParse(url);
  if (uri != null) {
    if (await urlLauncher.canLaunchUrl(uri)) {
      urlLauncher.launchUrl(uri);
    } else {
      if (kDebugMode) {
        print("could not launch: ${url.toString()}");
      }

      if (Platform.isIOS) {
        showAlertDialog(title: S.current.app_name, message: S.current.network_error_something_went_wrong);
      } else {
        showSnackBar(message: S.current.network_error_something_went_wrong);
      }
    }
  } else {
    if (Platform.isIOS) {
      showAlertDialog(title: S.current.app_name, message: S.current.network_error_something_went_wrong);
    } else {
      showSnackBar(message: S.current.network_error_something_went_wrong);
    }
  }
}

clearSecureStorageOnReinstall() async {
  String key = 'firstRun';
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool(key) ?? true) {
    await SecureStorage.deleteAll();
    prefs.setBool(key, false);
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    for (var element in this) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) result.add(element);
    }

    return result;
  }
}

extension ListExtensions<T> on List<T> {
  bool containsAt(T value, int index) {
    return index >= 0 && length > index && this[index] == value;
  }
}

extension StringListToCsvStyle on List<String> {
  String stringListToCsvStyle() {
    String newString = '';
    for (var i = 0; i < length; i++) {
      i != length - 1 ? newString += '${this[i]}, ' : newString += this[i];
    }
    return newString;
  }
}

/// Dutch messages
class DutchMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'over';
  @override
  String suffixAgo() => 'geleden';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'een moment';
  @override
  String aboutAMinute(int minutes) => 'één minuut';
  @override
  String minutes(int minutes) => '$minutes minuten';
  @override
  String aboutAnHour(int minutes) => 'ongeveer één uur';
  @override
  String hours(int hours) => '$hours uur';
  @override
  String aDay(int hours) => 'één dag';
  @override
  String days(int days) => '$days dagen';
  @override
  String aboutAMonth(int days) => 'ongeveer één maand';
  @override
  String months(int months) => '$months maanden';
  @override
  String aboutAYear(int year) => 'ongeveer één jaar';
  @override
  String years(int years) => '$years jaren';
  @override
  String wordSeparator() => ' ';
}

/// Dutch short messages
class DutchShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'nu';
  @override
  String aboutAMinute(int minutes) => '1 min';
  @override
  String minutes(int minutes) => '$minutes min';
  @override
  String aboutAnHour(int minutes) => '~1 u';
  @override
  String hours(int hours) => '$hours u';
  @override
  String aDay(int hours) => '~1 d';
  @override
  String days(int days) => '$days d';
  @override
  String aboutAMonth(int days) => '~1 ma';
  @override
  String months(int months) => '$months ma';
  @override
  String aboutAYear(int year) => '~1 jr';
  @override
  String years(int years) => '$years jr';
  @override
  String wordSeparator() => ' ';
}

bool get isWeb => kIsWeb;

bool get isIos => !kIsWeb && Platform.isIOS;

bool get isAndroid => !kIsWeb && Platform.isAndroid;
