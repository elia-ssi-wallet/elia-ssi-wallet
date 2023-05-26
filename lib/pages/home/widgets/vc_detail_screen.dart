import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/extensions/vc.dart';
import 'package:elia_ssi_wallet/base/helpers/alert_dialog_helper.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/activity_item.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_detail_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/vc_detail_reader.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class VCDetailScreen extends StatelessWidget {
  VCDetailScreen({required this.vc, Key? key}) : super(key: key);

  final VC vc;

  final VCDetailScreenViewmodel viewModel = VCDetailScreenViewmodel();

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
                  title: S.of(context).confirm_device_deletion,
                  subtitle: S.of(context).deleting_is_permanent,
                  isDismissable: true,
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        context.popRoute();
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    MaterialButton(
                      onPressed: () {
                        ExchangeRepository.dao.deleteVC(vcId: vc.id);
                        context.router.popUntilRouteWithName(HomeScreenRoute.name);
                      },
                      child: Text(
                        S.of(context).delete,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
              label: Center(
                child: Text(
                  S.of(context).delete,
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
                vc.title,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.5,
        ),
        body: Observer(
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: 140,
                        height: 76,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 76,
                                width: 76,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.dark,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppAssets.documentIcon,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 76,
                                width: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.dark,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppAssets.electricWalletIcon,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 27.3,
                                width: 27.63,
                                child: SvgPicture.asset(AppAssets.linkIcon),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    Text(
                      S.of(context).contract_info,
                      style: AppStyles.title,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    VcDetailReader(
                      vc: jsonDecode(vc.vc),
                      types: vc.vcTableType(),
                      issuerDid: vc.issuerDid,
                      issuerLabel: vc.issuerLabel != '' ? vc.issuerLabel : null,
                      issuanceDate: vc.issuanceDate,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            S.of(context).activity_log,
                            style: AppStyles.title,
                          ),
                        ),
                        if (vc.activity.length > 3)
                          TextButton(
                            onPressed: () {
                              viewModel.showAll = !viewModel.showAll;
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              viewModel.showAll ? S.of(context).show_less : S.of(context).show_all,
                              style: AppStyles.subtitle,
                            ),
                          ),
                      ],
                    ),
                    Observer(
                      builder: (_) => viewModel.showAll || vc.activity.length < 3
                          ? vc.activity.isNotEmpty
                              ? Column(
                                  children: [
                                    ...vc.activity.reversed.map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: ActivityItem(
                                          activity: e,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : const Center(
                                  child: Text(
                                    'No activity yet',
                                    style: AppStyles.subtitle,
                                  ),
                                )
                          : Column(
                              children: [
                                ...vc.activity.reversed.toList().sublist(0, 3).map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: ActivityItem(
                                          activity: e,
                                        ),
                                      ),
                                    ),
                                if (vc.activity.length > 3)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (var i = 0; i < 3; i++) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          child: Container(
                                            height: 5,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: 80 + MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
