import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/confirm_contract_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/custom_text_form_field.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
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
                  },
                  label: Center(
                    child: Text(
                      'Reject',
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
                  onPressed: () {
                    ExchangeRepository.dao.insertVCs(
                      vc: vp['verifiableCredential'],
                      label: viewModel.issuerNameController.text,
                    );
                    Navigator.popUntil(context, (route) => route.settings.name == Routes.home);
                  },
                  label: const Center(
                    child: Text(
                      'Accept',
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
                    largeTitle: const Text('Add Contract'),
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
                          const Text('A new contract is ready. Accept the contract to add it to your wallet'),
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
                              child: Text(vp['verifiableCredential'].toString()),
                              // Column(
                              //   children: [
                              //     ...viewModel.vCs.map(
                              //       (e) => Padding(
                              //         padding: const EdgeInsets.only(bottom: 5.0),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(e.label),
                              //             Text(
                              //               e.id.toString(),
                              //               style: const TextStyle(
                              //                 color: AppColors.dark,
                              //                 fontSize: 15,
                              //                 fontWeight: FontWeight.w500,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
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
