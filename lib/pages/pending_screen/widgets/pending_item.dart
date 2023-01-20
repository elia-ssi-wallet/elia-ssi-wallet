import 'dart:convert';

import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_indicator.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:flutter/material.dart';

class PendingItem extends StatelessWidget {
  const PendingItem({
    Key? key,
    required this.pendingRequest,
  }) : super(key: key);

  final PendingRequest pendingRequest;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: pendingRequest.vpVc != null
              ? () {
                  Navigator.of(context).pushNamed(Routes.confirmContract, arguments: jsonDecode(pendingRequest.vpVc!));
                }
              : null,
          child: Ink(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.grey1,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(pendingRequest.serviceEndpoint.prettifyDomain(), style: AppStyles.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Visibility(
                    visible: pendingRequest.vpVc == null,
                    replacement: const Center(
                      child: Icon(
                        Icons.done_rounded,
                        color: AppColors.green,
                      ),
                    ),
                    child: Center(
                      child: PlatformLoadingIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
