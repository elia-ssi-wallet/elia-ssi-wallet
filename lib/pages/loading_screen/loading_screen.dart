import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/loading_screen/loading_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final LoadingScreenViewModel viewModel = LoadingScreenViewModel();

  @override
  void initState() {
    viewModel.initiateIssuance(exchangeUrl: widget.url, context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Observer(
        builder: (_) => Visibility(
          visible: viewModel.error,
          replacement: viewModel.showPending
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FloatingActionButton.extended(
                      heroTag: 'go_to_pending',
                      backgroundColor: AppColors.dark,
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.settings.name == Routes.home);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton.extended(
                heroTag: 'try_again',
                backgroundColor: AppColors.dark,
                onPressed: () {
                  Navigator.pop(context);
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
    );
  }
}
