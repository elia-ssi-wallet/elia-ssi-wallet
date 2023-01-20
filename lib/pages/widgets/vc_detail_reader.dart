import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class VcDetailReader extends StatelessWidget {
  const VcDetailReader({required this.vc, super.key});

  final dynamic vc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.grey1,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10.0, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vc != null)
              ...(vc["credentialSubject"] as Map<String, dynamic>).entries.mapIndexed(
                (entry, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 48.0),
                            child: Text(entry.key, softWrap: false, style: AppStyles.smallText),
                          ),
                          Flexible(
                            child: entry.value is List<dynamic>
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ...(entry.value as List<dynamic>)
                                          .map(
                                            (e) => Text(e.toString(), softWrap: true, textAlign: TextAlign.right, style: AppStyles.mediumText),
                                          )
                                          .toList()
                                    ],
                                  )
                                : Text(
                                    entry.value.toString(),
                                    softWrap: true,
                                    textAlign: TextAlign.right,
                                    style: AppStyles.mediumText,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ).toList(),
          ],
        ),
      ),
    );
  }
}
