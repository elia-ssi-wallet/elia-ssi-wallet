import 'package:animated_check/animated_check.dart';
import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/loading_screen/loading_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({
    Key? key,
    @QueryParam("url") this.url = "",
  }) : super(key: key);

  final String url;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  final LoadingScreenViewModel viewModel = LoadingScreenViewModel();

  late Animation<double> _animation;

  @override
  void initState() {
    viewModel.animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: viewModel.animationController, curve: Curves.easeInOutCirc));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ExchangeRepository.showConnectionDialog(
          context: context,
          onAccept: () async {
            context.router.pop();

            await viewModel.initiateIssuance(exchangeUrl: widget.url);
          },
          name: widget.url.getBaseUrlfromExchangeUrl(),
          onReject: () {
            context.router.pop();
            viewModel.error = true;
            viewModel.status = "Connection rejected";
          });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Observer(
          builder: (_) => viewModel.error
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FloatingActionButton.extended(
                      heroTag: 'try_again',
                      backgroundColor: AppColors.dark,
                      onPressed: () {
                        context.router.popUntilRouteWithName(HomeScreenRoute.name);
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
                )
              : viewModel.transactionSuccesful
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FloatingActionButton.extended(
                          heroTag: 'return_to_home',
                          backgroundColor: AppColors.dark,
                          onPressed: () {
                            context.router.popUntilRouteWithName(HomeScreenRoute.name);
                          },
                          label: const Center(
                            child: Text(
                              'Return',
                              textAlign: TextAlign.center,
                              style: AppStyles.button,
                            ),
                          ),
                        ),
                      ),
                    )
                  : viewModel.showPending
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: FloatingActionButton.extended(
                              heroTag: 'go_to_pending',
                              backgroundColor: AppColors.dark,
                              onPressed: () {
                                viewModel.goToPending = true;
                                context.router.popUntilRouteWithName(HomeScreenRoute.name);
                              },
                              label: Center(
                                child: Text(
                                  S.of(context).view_pending_requests,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.button,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
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
                                child: Observer(
                                  builder: (_) => viewModel.error
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.grey1,
                                              width: 4,
                                            ),
                                          ),
                                        )
                                      : viewModel.transactionSuccesful
                                          ? const SizedBox(
                                              height: 118,
                                              width: 118,
                                              child: CircularProgressIndicator(
                                                color: AppColors.green,
                                                backgroundColor: AppColors.grey1,
                                                value: 1,
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 118,
                                              width: 118,
                                              child: CircularProgressIndicator(
                                                color: AppColors.green,
                                                backgroundColor: AppColors.grey1,
                                              ),
                                            ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 94,
                                  width: 94,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.dark,
                                  ),
                                  child: Observer(
                                    builder: (_) => viewModel.error
                                        ? Center(
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
                                          )
                                        : viewModel.transactionSuccesful
                                            ? AnimatedCheck(
                                                size: 80,
                                                color: AppColors.green,
                                                strokeWidth: 4,
                                                progress: _animation,
                                              )
                                            : Center(
                                                child: SvgPicture.asset(
                                                  viewModel.showPending ? AppAssets.pendingIcon : AppAssets.linkIcon,
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      viewModel.error
                          ? Text(
                              S.of(context).something_went_wrong,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            )
                          : viewModel.showPending
                              ? Text(
                                  S.of(context).we_are_processing_your_request,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                )
                              : Text(
                                  S.of(context).adding_contract,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                      const SizedBox(
                        height: 10,
                      ),
                      Observer(
                        builder: (_) => Text(
                          viewModel.showPending ? S.of(context).we_are_processing_your_request_extra : viewModel.status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.grey2,
                          ),
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
