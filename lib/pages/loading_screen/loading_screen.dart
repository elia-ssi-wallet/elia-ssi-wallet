import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/pages/loading_screen/loading_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  final LoadingScreenViewModel viewModel = LoadingScreenViewModel();

  @override
  Widget build(BuildContext context) {
    viewModel.initiateIssuance(serviceEndpoint: url, context: context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.grey1,
                                width: 4,
                              ),
                            ),
                          ),
                          const Center(
                            child: SizedBox(
                              height: 118,
                              width: 118,
                              child: CircularProgressIndicator(
                                color: AppColors.green,
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
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.linkIcon,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'We’re adding your contract',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Observer(
                    builder: (_) => Text(
                      viewModel.status,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.grey2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
