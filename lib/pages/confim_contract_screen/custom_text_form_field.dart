import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  final border = OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xFFE3E8F0)),
    borderRadius: BorderRadius.circular(8.0),
  );

  final selectedBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.grey3),
    borderRadius: BorderRadius.circular(8.0),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.dark,
      decoration: InputDecoration(
        filled: false,
        fillColor: Colors.transparent,
        label: const Text('Name this issuer'),
        labelStyle: AppStyles.normal,
        border: border,
        focusedBorder: selectedBorder,
        enabledBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
        focusColor: Colors.black,
        isDense: true,
        contentPadding: const EdgeInsets.all(16.0),
        errorMaxLines: 5,
      ),
      controller: controller,
    );
  }
}
