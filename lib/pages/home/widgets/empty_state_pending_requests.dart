import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStatePendingRequests extends StatelessWidget {
  const EmptyStatePendingRequests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 94,
            width: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.dark,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(Color.getAlphaFromOpacity(0.15), 33, 37, 42),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.pendingIcon,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          S.of(context).no_pending_requests,
          style: AppStyles.title,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
