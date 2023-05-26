import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VcDetailReader extends StatelessWidget {
  const VcDetailReader({
    Key? key,
    required this.vc,
    this.issuerLabel,
    required this.issuerDid,
    required this.issuanceDate,
    required this.types,
  }) : super(key: key);

  final dynamic vc;
  final String? issuerLabel;
  final String issuerDid;
  final String types;
  final DateTime issuanceDate;

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
            if (issuerLabel != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 48.0),
                    child: Text(
                      'Issuer',
                      softWrap: false,
                      style: AppStyles.smallText,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      issuerLabel!,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      style: AppStyles.mediumText,
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: Text(
                    'Issuer DID',
                    softWrap: false,
                    style: AppStyles.smallText,
                  ),
                ),
                Flexible(
                  child: Text(
                    issuerDid,
                    softWrap: true,
                    textAlign: TextAlign.right,
                    style: AppStyles.mediumText,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: Text(
                    'Card types',
                    softWrap: false,
                    style: AppStyles.smallText,
                  ),
                ),
                Flexible(
                  child: Text(
                    types,
                    softWrap: true,
                    textAlign: TextAlign.right,
                    style: AppStyles.mediumText,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: Text(
                    'Issuance Date',
                    softWrap: false,
                    style: AppStyles.smallText,
                  ),
                ),
                Flexible(
                  child: Text(
                    DateFormat('EEE d/M/y - HH:mm').format(issuanceDate),
                    softWrap: true,
                    textAlign: TextAlign.right,
                    style: AppStyles.mediumText,
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: AppColors.grey2,
              margin: const EdgeInsets.only(top: 16, bottom: 16),
            ),
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
                                            (e) => Text(
                                              e.toString(),
                                              softWrap: true,
                                              textAlign: TextAlign.right,
                                              style: AppStyles.mediumText,
                                            ),
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
