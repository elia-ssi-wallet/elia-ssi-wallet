import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:flutter_svg/svg.dart';

class TokenTextField extends StatelessWidget {
  TokenTextField({
    Key? key,
    required this.text,
    this.onTap,
    this.obscure = false,
    this.subtitle,
  }) : super(key: key);

  final String text;
  final Function()? onTap;
  final bool obscure;
  final String? subtitle;

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      width: 0,
      color: AppColors.dark.withOpacity(0.12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.dark.withOpacity(0.12),
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
                        minSize: 0.0,
                        onPressed: () {
                          onTap!();
                        },
                        child: Text(
                          obscure ? S.of(context).show : S.of(context).hide,
                          style: AppStyles.button.copyWith(color: AppColors.dark),
                        ))
                    : null),
            readOnly: true,
            obscureText: obscure,
            controller: TextEditingController(text: text),
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppAssets.infoIcon),
                const SizedBox(width: 9),
                Flexible(
                  child: Text(
                    subtitle!,
                    style: AppStyles.italicText,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
