import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:elia_ssi_wallet/base/colors/colors.dart';

class TokenTextField extends StatelessWidget {
  TokenTextField({
    Key? key,
    required this.text,
    this.onTap,
    this.obscure = false,
  }) : super(key: key);

  final String text;
  final Function()? onTap;
  final bool obscure;

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      width: 0,
      color: AppColors.blue.withOpacity(0.12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.blue.withOpacity(0.12),
            border: border,
            focusedBorder: border,
            enabledBorder: border,
            disabledBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            isDense: true,
            contentPadding: const EdgeInsets.all(10.0),
            suffix: onTap != null
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onTap!();
                    },
                    child: Text(obscure ? S.of(context).show : S.of(context).hide))
                : null),
        readOnly: true,
        obscureText: obscure,
        controller: TextEditingController(text: text),
      ),
    );
  }
}
