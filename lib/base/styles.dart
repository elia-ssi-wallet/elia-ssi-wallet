import 'package:flutter/material.dart';

//intro
InputDecoration textFieldDecoration({String? hint}) {
  final border = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10.0),
  );

  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    // labelStyle: AppStyles.label,
    border: border,
    focusedBorder: border,
    enabledBorder: border,
    disabledBorder: border,
    errorBorder: border.copyWith(borderSide: const BorderSide(color: Colors.red)),
    focusedErrorBorder: border,
    focusColor: Colors.black,
    isDense: true,
    contentPadding: const EdgeInsets.all(16.0),
    errorMaxLines: 5,
    // errorStyle: AppStyles.normal.copyWith(color: Colors.white),
  );
}
