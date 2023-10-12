import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/router/terms_auth_guard.dart';
import 'package:elia_ssi_wallet/pages/accept_terms_and_conditions/accept_terms_and_conditions_screen.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contracts_screen.dart';
import 'package:elia_ssi_wallet/pages/confim_contract_screen/confirm_contract_screen.dart';
import 'package:elia_ssi_wallet/pages/consent_screen/consent_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_detail_screen.dart';
import 'package:elia_ssi_wallet/pages/loading_screen/loading_screen.dart';
import 'package:elia_ssi_wallet/pages/qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';

part 'app_router.gr.dart';

//! test deeplinks -> xcrun simctl openurl booted elia-wallet://exchange/loading/testing1234

@AutoRouterConfig(replaceInRouteName: "")
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    /// routes go here
    AutoRoute(
      path: "/",
      page: HomeScreenRoute.page,
      guards: [
        TermsAuthGuard(),
      ],
    ),
    AutoRoute(
      path: "/qr/:id",
      page: QrCodeScannerRoute.page,
    ),
    AutoRoute(path: "/loading", page: LoadingScreenRoute.page, guards: [
      TermsAuthGuard(),
    ]),
    AutoRoute(page: AcceptTermsAndConditionsRoute.page),
    AutoRoute(page: CompatibleContractsScreenRoute.page),
    AutoRoute(page: ConfirmContractRoute.page),
    AutoRoute(page: VCDetailScreenRoute.page),
    AutoRoute(page: NotFoundScreenRoute.page),
    AutoRoute(page: ConsentScreenRoute.page),
    AutoRoute(path: "/error", page: NotFoundScreenRoute.page),
    AutoRoute(path: "*", page: NotFoundScreenRoute.page),
  ];
}

@RoutePage()
class NotFoundScreen extends StatelessWidget {
  final bool error;
  final String? errorMessage;
  const NotFoundScreen({
    Key? key,
    this.error = true,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              heroTag: 'try_again',
              backgroundColor: AppColors.dark,
              onPressed: () {
                var canPop = context.router.canPop();
                if (canPop) {
                  context.router.popUntilRouteWithName(HomeScreenRoute.name);
                } else {
                  // context.router.popAndPushN(HomeScreenRoute());
                  context.router.pop();
                  context.router.pushAndPopUntil(HomeScreenRoute(), predicate: (_) => false);
                }
              },
              label: Center(
                child: Text(
                  S.of(context).try_again,
                  textAlign: TextAlign.center,
                  style: AppStyles.button,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ClipRect(
          child: Stack(
            children: [
              CustomPaint(
                painter: CirclePainter(),
                size: const Size(double.infinity, double.infinity),
              ),
              CustomPaint(
                painter: CirclePainter(left: false),
                size: const Size(double.infinity, double.infinity),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: SizedBox(
                          height: 122,
                          width: 122,
                          child: Stack(
                            children: [
                              Center(
                                  child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.grey1,
                                    width: 4,
                                  ),
                                ),
                              )),
                              Center(
                                child: Container(
                                    height: 94,
                                    width: 94,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.dark,
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.red,
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppAssets.exclamationMark,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        errorMessage ?? S.of(context).something_went_wrong,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
