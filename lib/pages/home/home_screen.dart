import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/did/did_token_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/empty_state_contracts.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/new_contract_notification.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/pending_requests_notification.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_item.dart';
import 'package:elia_ssi_wallet/pages/widgets/background_circles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  final ScrollController scrollControllerExternalContracts = ScrollController();
  final ScrollController scrollControllerSelfSigned = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.dark,
                onPressed: () async {
                  Navigator.of(context).pushNamed(Routes.qr).then(
                    (_) async {
                      final arguments = ModalRoute.of(context)?.settings.arguments;

                      if ((arguments as Map).isNotEmpty) {
                        VC? newVc = (arguments)["vc"];
                        if (newVc != null) {
                          await viewModel.updateNotification(vc: newVc);
                        }
                      } else {
                        Logger().d("jan: map empty");
                      }
                    },
                  );
                },
                label: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.scanIcon),
                        const SizedBox(width: 10.0),
                        Text(
                          S.of(context).add_contract,
                          textAlign: TextAlign.center,
                          style: AppStyles.button.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            const BackGroundCircles(),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CupertinoButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return DidTokenScreen();
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                        child: Text(
                          S.of(context).my_did_date,
                          style: AppStyles.title,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        S.of(context).hello_name("ELIA"),
                        style: AppStyles.largeTitle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: CupertinoSearchTextField(
                        controller: viewModel.searchController,
                        placeholder: S.of(context).search_contracts,
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: viewModel.showNotificationComputed
                            ? Align(
                                alignment: Alignment.center,
                                child: NewContractNotification(
                                  vc: viewModel.newlyAddedVC!,
                                ),
                              )
                            : const SizedBox.shrink(),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              alignment: Alignment.topCenter,
                              child: SizeTransition(
                                sizeFactor: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Observer(
                    builder: (_) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: viewModel.pendingRequests.value?.isNotEmpty == true
                          ? const Align(
                              alignment: Alignment.center,
                              child: PendingRequestsNotification(),
                            )
                          : const SizedBox.shrink(),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            alignment: Alignment.topCenter,
                            child: SizeTransition(
                              sizeFactor: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 30,
                                child: TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  labelStyle: AppStyles.tabbarTextStyle.copyWith(fontWeight: FontWeight.w600),
                                  unselectedLabelStyle: AppStyles.tabbarTextStyle,
                                  indicatorColor: AppColors.green,
                                  indicatorWeight: 4.0,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: [
                                    Tab(
                                      text: S.of(context).external_contracts,
                                    ),
                                    Tab(
                                      text: S.of(context).self_signed,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Observer(
                                    builder: (_) => Visibility(
                                      visible: viewModel.vCsStream.value?.isNotEmpty == true,
                                      replacement: EmptyStateContracts(noVcs: viewModel.noVcs),
                                      child: Scrollbar(
                                        controller: scrollControllerExternalContracts,
                                        child: ListView.builder(
                                          controller: scrollControllerExternalContracts,
                                          itemCount: viewModel.vCsStream.value?.length ?? 0,
                                          padding: const EdgeInsets.only(bottom: 100),
                                          itemBuilder: (BuildContext context, int index) {
                                            if (viewModel.vCsStream.value?[index] != null) {
                                              return VcItem(vc: viewModel.vCsStream.value![index]);
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Observer(
                                    builder: (_) => Visibility(
                                      visible: viewModel.selfSignedVcStream.value?.isNotEmpty == true,
                                      replacement: EmptyStateContracts(noVcs: viewModel.noSelfSignedVcs),
                                      child: Scrollbar(
                                        controller: scrollControllerSelfSigned,
                                        child: ListView.builder(
                                          controller: scrollControllerSelfSigned,
                                          itemCount: viewModel.selfSignedVcStream.value?.length ?? 0,
                                          padding: const EdgeInsets.only(bottom: 100),
                                          itemBuilder: (BuildContext context, int index) {
                                            if (viewModel.selfSignedVcStream.value?[index] != null) {
                                              return VcItem(vc: viewModel.selfSignedVcStream.value![index]);
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
