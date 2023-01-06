import 'dart:convert';

import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/helpers/alert_dialog_helper.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class VCDetailScreen extends StatelessWidget {
  const VCDetailScreen({required this.vc, super.key});

  final VC vc;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              heroTag: 'delete1',
              backgroundColor: AppColors.dark,
              onPressed: () {
                showPlatformAlertDialog(
                  title: 'Are you sure you want to delete this device?',
                  subtitle: 'Deleting this device will also delete all provided data and is irreversible',
                  isDismissable: true,
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    MaterialButton(
                      onPressed: () {
                        ExchangeRepository.dao.deleteVC(vcId: vc.id);
                        Navigator.of(context).popUntil((route) => route.settings.name == Routes.home);
                      },
                      child: const Text(
                        'delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
              label: Center(
                child: Text(
                  'Delete device',
                  textAlign: TextAlign.center,
                  style: AppStyles.button.copyWith(color: AppColors.red),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 60.0),
              child: Text(
                vc.label,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.5,
        ),
        body: Observer(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contract info',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.grey1,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10.0, bottom: 5),
                      // child: Text(vc.vc['verifiableCredential'].toString()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (jsonDecode(vc.vc)[0] != null)
                            ...(jsonDecode(vc.vc)[0]["credentialSubject"] as Map<String, dynamic>).entries.mapIndexed(
                              (entry, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 48.0),
                                          child: Text(
                                            entry.key,
                                            softWrap: false,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.grey2,
                                            ),
                                          ),
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
                                                            style: const TextStyle(
                                                              color: AppColors.dark,
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        )
                                                        .toList()
                                                  ],
                                                )
                                              : Text(
                                                  entry.value.toString(),
                                                  softWrap: true,
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                    color: AppColors.dark,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
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
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
