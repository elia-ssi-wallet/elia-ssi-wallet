import 'package:elia_ssi_wallet/pages/home/widgets/vc_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';

class NewContractNotification extends StatelessWidget {
  const NewContractNotification({
    Key? key,
    required this.vc,
  }) : super(key: key);

  final VC vc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Logger().d("notification tapped");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            builder: (context) {
              return VCDetailScreen(
                vc: vc,
              );
            },
          );
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
                S.of(context).new_contract_was_added_to_your_wallet,
                style: AppStyles.button.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
