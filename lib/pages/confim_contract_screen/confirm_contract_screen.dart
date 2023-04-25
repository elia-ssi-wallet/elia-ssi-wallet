// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/confirm_contract_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/custom_text_form_field.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:elia_ssi_wallet/pages/widgets/vc_detail_reader.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class ConfirmContract extends StatefulWidget {
  const ConfirmContract({Key? key, required this.vp, required this.pendingRequestId}) : super(key: key);

  final dynamic vp;
  final int pendingRequestId;

  @override
  State<ConfirmContract> createState() => _ConfirmContractState();
}

class _ConfirmContractState extends State<ConfirmContract> {
  final ConfirmContractViewModel viewModel = ConfirmContractViewModel();

  List<SliverOverlapAbsorberHandle> sliverOverlapAbsorberHandleList = [];
  List<TextEditingController> textEditingControllerList = [];

  @override
  void initState() {
    sliverOverlapAbsorberHandleList = List.generate(widget.vp['verifiableCredential'].length, (index) => SliverOverlapAbsorberHandle());
    textEditingControllerList = List.generate(widget.vp['verifiableCredential'].length, (index) => TextEditingController());
    super.initState();
  }

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
                    // context.router.popUntilRouteWithName(HomeScreenRoute.name);
                    if (widget.vp['verifiableCredential'].isEmpty || widget.vp['verifiableCredential'].length == 1) {
                      ExchangeRepository.pendingRequestDao.deletePendingRequestWithId(id: widget.pendingRequestId);
                      context.router.popUntilRouteWithName(HomeScreenRoute.name);
                    } else {
                      widget.vp['verifiableCredential'].removeAt(0);
                      ExchangeRepository.pendingRequestDao.updatePendingRequest(id: widget.pendingRequestId, vp: widget.vp);
                      viewModel.nextPage();
                    }
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
                    await ExchangeRepository.dao.insertVC(
                      vc: widget.vp['verifiableCredential'][0],
                      label: textEditingControllerList[viewModel.pageController.page!.toInt()].text,
                    );
                    if (widget.vp['verifiableCredential'].isEmpty || widget.vp['verifiableCredential'].length == 1) {
                      ExchangeRepository.pendingRequestDao.deletePendingRequestWithId(id: widget.pendingRequestId);
                      context.router.popUntilRouteWithName(HomeScreenRoute.name);
                    } else {
                      widget.vp['verifiableCredential'].removeAt(0);
                      ExchangeRepository.pendingRequestDao.updatePendingRequest(id: widget.pendingRequestId, vp: widget.vp);
                      viewModel.nextPage();
                    }
                    // context.router.popUntilRouteWithName(HomeScreenRoute.name);
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
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: viewModel.pageController,
              children: [
                for (var i = 0; i < widget.vp['verifiableCredential'].length; i++)
                  CustomScrollView(
                    slivers: [
                      SliverOverlapAbsorber(
                        handle: sliverOverlapAbsorberHandleList[i],
                        sliver: CupertinoSliverNavigationBar(
                          automaticallyImplyLeading: false,
                          largeTitle: widget.vp['verifiableCredential'].length == 1
                              ? Text(
                                  S.of(context).add_contract,
                                )
                              : Text(
                                  '${S.of(context).add_contract} (${i + 1}/${widget.vp['verifiableCredential'].length})',
                                ),
                          backgroundColor: Colors.white,
                          border: null,
                          trailing: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () {
                                context.router.popUntilRouteWithName(HomeScreenRoute.name);
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
                        handle: sliverOverlapAbsorberHandleList[i],
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
                                  controller: textEditingControllerList[i],
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
                                          'Issuer DID =  ${widget.vp['verifiableCredential'][i]['issuer']}',
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
                                VcDetailReader(
                                  vc: widget.vp['verifiableCredential'][i],
                                  issuer: widget.vp['verifiableCredential'][i]['issuer'],
                                  issuanceDate: DateTime.parse(widget.vp['verifiableCredential'][i]['issuanceDate']),
                                ),
                                // ...vp['verifiableCredential'].map((e) {
                                //   return VcDetailReader(
                                //     vc: e,
                                //   );
                                // }),
                                // Text(vp.toString()),
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
          ],
        ),
      ),
    );
  }
}
