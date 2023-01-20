import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PendingRequestsNotification extends StatelessWidget {
  const PendingRequestsNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.pendingRequests);
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.notificationIcon),
              const SizedBox(width: 10),
              Text(
                "Pending requests",
                style: AppStyles.button.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
