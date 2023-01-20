import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle title = TextStyle(
    color: AppColors.dark,
    fontSize: 17,
    letterSpacing: -0.08,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subtitle = TextStyle(
    color: AppColors.grey2,
    fontSize: 15,
    letterSpacing: -0.08,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle normal = TextStyle(
    color: Colors.black,
    fontSize: 14,
    letterSpacing: 0.37,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.dark,
    fontSize: 15,
    letterSpacing: -0.08,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle button = TextStyle(
    color: AppColors.green,
    fontSize: 15,
    letterSpacing: -0.08,
    fontWeight: FontWeight.w600,
  );

  static TextStyle largeTitle = const TextStyle(
    fontSize: 34,
    letterSpacing: 0.37,
    fontWeight: FontWeight.bold,
  );

  static TextStyle italicText = const TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    color: AppColors.grey2,
    fontSize: 13,
    letterSpacing: -0.08,
  );

  static TextStyle smallText = const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.grey2,
    fontSize: 12,
    letterSpacing: -0.08,
  );

  static TextStyle mediumText = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.dark,
    fontSize: 15,
    letterSpacing: -0.08,
  );

  static TextStyle boldText = const TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
    fontSize: 15,
    letterSpacing: -0.08,
  );

  static TextStyle tabbarTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
    fontSize: 15,
  );
}
