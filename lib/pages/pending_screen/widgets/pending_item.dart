import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/widgets/delete_pending_dialog.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/widgets/pending_badge.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
          onTap: pendingRequest.vp != null && pendingRequest.vp != "error:declined"
              ? () {
                  Logger().d(pendingRequest.vp);
                  context.router.push(ConfirmContractRoute(
                    pendingRequestId: pendingRequest.id,
                    vp: jsonDecode(pendingRequest.vp!),
                  ));
                }
              : () async {
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return DeletePendingDialog(pendingRequest: pendingRequest);
                    },
                  );
                },
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
                    visible: pendingRequest.vp == null && pendingRequest.error == null,
                    replacement: Visibility(
                      visible: pendingRequest.error == null,
                      replacement: const PendingBadge(state: PendingState.declined),
                      child: const PendingBadge(state: PendingState.approved),
                    ),
                    child: const PendingBadge(state: PendingState.pending),
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
