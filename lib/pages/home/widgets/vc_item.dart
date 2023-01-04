import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_detail_screen.dart';
import 'package:flutter/material.dart';

class VcItem extends StatelessWidget {
  const VcItem({
    Key? key,
    required this.vc,
  }) : super(key: key);

  final VC vc;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
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
          child: Ink(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.grey1,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //icon
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlutterLogo(
                    size: 20,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(child: Text("Type", style: AppStyles.subtitle)),
                    Flexible(child: Text(vc.label, style: AppStyles.title)),
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.dark,
                    size: 15,
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
