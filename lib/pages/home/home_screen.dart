import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/did/did_token_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/empty_state_pending_requests.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/new_contract_notification.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_item.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/widgets/pending_item.dart';
import 'package:elia_ssi_wallet/pages/widgets/background_circles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/empty_state_contracts.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  final ScrollController scrollControllerExternalContracts = ScrollController();
  final ScrollController scrollControllerSelfSigned = ScrollController();
  final ScrollController scrollControllerPending = ScrollController();

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
                  // String url = "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test_P_1";
                  // context.router.push(LoadingScreenRoute(url: url));
                  locator<NavigationService>().router.push(QrCodeScannerRoute()).then((value) {
                    viewModel.initStreams();
                  });
                },
                label: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.scanIcon,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
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
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
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
                                    ),
                                    Tab(
                                      text: S.of(context).pending,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  StreamBuilder<List<VC>>(
                                    stream: viewModel.externalVCsStream,
                                    builder: (BuildContext context, AsyncSnapshot<List<VC>> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: SizedBox(
                                            height: 118,
                                            width: 118,
                                            child: CircularProgressIndicator(
                                              color: AppColors.green,
                                            ),
                                          ),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        Sentry.captureException(snapshot.error);
                                        return const SizedBox.shrink();
                                      }
                                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                                        return Observer(
                                          builder: (_) => EmptyStateContracts(noSearch: viewModel.noSearch),
                                        );
                                      }

                                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                        return Scrollbar(
                                          controller: scrollControllerExternalContracts,
                                          child: ListView.builder(
                                            controller: scrollControllerExternalContracts,
                                            itemCount: snapshot.data!.length,
                                            padding: const EdgeInsets.only(bottom: 100),
                                            itemBuilder: (BuildContext context, int index) {
                                              return VcItem(
                                                vc: snapshot.data![index],
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  StreamBuilder<List<VC>>(
                                    stream: viewModel.selfSignedVcStream,
                                    builder: (BuildContext context, AsyncSnapshot<List<VC>> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: SizedBox(
                                            height: 118,
                                            width: 118,
                                            child: CircularProgressIndicator(
                                              color: AppColors.green,
                                            ),
                                          ),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        Sentry.captureException(snapshot.error);
                                        return const SizedBox.shrink();
                                      }

                                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                                        return Observer(
                                          builder: (_) => EmptyStateContracts(noSearch: viewModel.noSearch),
                                        );
                                      }

                                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                        return Scrollbar(
                                          controller: scrollControllerSelfSigned,
                                          child: ListView.builder(
                                            controller: scrollControllerSelfSigned,
                                            itemCount: snapshot.data!.length,
                                            padding: const EdgeInsets.only(bottom: 100),
                                            itemBuilder: (BuildContext context, int index) {
                                              return VcItem(
                                                vc: snapshot.data![index],
                                                selfSigned: true,
                                              );
                                            },
                                          ),
                                        );
                                      }

                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  StreamBuilder<List<PendingRequest>>(
                                    stream: viewModel.pendingRequests,
                                    builder: (BuildContext context, AsyncSnapshot<List<PendingRequest>> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: SizedBox(
                                            height: 118,
                                            width: 118,
                                            child: CircularProgressIndicator(
                                              color: AppColors.green,
                                            ),
                                          ),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        Sentry.captureException(snapshot.error);
                                        return const SizedBox.shrink();
                                      }

                                      if (snapshot.hasData && snapshot.data!.isEmpty) {
                                        return const EmptyStatePendingRequests();
                                      }

                                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                        return Scrollbar(
                                          controller: scrollControllerPending,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                child: Text(
                                                  S.of(context).pending_info,
                                                  style: AppStyles.infoTextStyle,
                                                ),
                                              ),
                                              Flexible(
                                                child: ListView.builder(
                                                  controller: scrollControllerPending,
                                                  itemCount: snapshot.data!.length,
                                                  padding: const EdgeInsets.only(bottom: 100),
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return PendingItem(pendingRequest: snapshot.data![index]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return const SizedBox.shrink();
                                    },
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
