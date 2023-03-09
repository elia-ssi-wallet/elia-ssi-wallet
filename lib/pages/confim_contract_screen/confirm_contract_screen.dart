// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/confirm_contract_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/custom_text_form_field.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:elia_ssi_wallet/pages/widgets/vc_detail_reader.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmContract extends StatelessWidget {
  ConfirmContract({Key? key, required this.vp}) : super(key: key);

  final dynamic vp;

  final ConfirmContractViewModel viewModel = ConfirmContractViewModel();

  final SliverOverlapAbsorberHandle sliverOverlapAbsorberHandle = SliverOverlapAbsorberHandle();

  @override
  Widget build(BuildContext context) {
    inspect(vp);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'confirmScreen1',
                  backgroundColor: AppColors.dark,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.settings.name == Routes.home);
                    ExchangeRepository.pendingRequestDao.deletePendingRequest(vp: vp);
                  },
                  label: Center(
                    child: Text(
                      S.of(context).reject,
                      textAlign: TextAlign.center,
                      style: AppStyles.button.copyWith(color: AppColors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'confirmScreen2',
                  backgroundColor: AppColors.dark,
                  onPressed: () async {
                    ExchangeRepository.pendingRequestDao.deletePendingRequest(vp: vp);
                    VC newVC = await ExchangeRepository.dao.insertVCs(
                      vc: vp['verifiableCredential'][0],
                      label: viewModel.issuerNameController.text,
                    );
                    Navigator.popUntil(
                      context,
                      (route) {
                        if (route.settings.name == Routes.home) {
                          (route.settings.arguments as Map)["vc"] = newVC;
                          return true;
                        } else {
                          return false;
                        }
                      },
                    );
                  },
                  label: Center(
                    child: Text(
                      S.of(context).accept,
                      textAlign: TextAlign.center,
                      style: AppStyles.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            CustomPaint(
              painter: CirclePainter(left: false),
              size: const Size(double.infinity, double.infinity),
            ),
            CustomScrollView(
              slivers: [
                SliverOverlapAbsorber(
                  handle: sliverOverlapAbsorberHandle,
                  sliver: CupertinoSliverNavigationBar(
                    automaticallyImplyLeading: false,
                    largeTitle: Text(
                      S.of(context).add_contract,
                    ),
                    backgroundColor: Colors.white,
                    border: null,
                    trailing: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: SvgPicture.asset(
                          AppAssets.closeIcon,
                          color: AppColors.grey2,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverOverlapInjector(
                  handle: sliverOverlapAbsorberHandle,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).a_new_contract_is_ready,
                            style: AppStyles.subtitle,
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          CustomTextFormField(
                            controller: viewModel.issuerNameController,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.dark,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(AppAssets.infoIcon),
                                  ),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Flexible(
                                  child: Text(
                                    'Issuer DID =  ${vp['verifiableCredential'][0]['issuer']}',
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.grey2,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            S.of(context).contract_info,
                            style: AppStyles.title,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ...vp['verifiableCredential'].map((e) {
                            return VcDetailReader(
                              vc: e,
                            );
                          }),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
