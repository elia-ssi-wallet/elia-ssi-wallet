import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/pages/qr_code_scanner/qr_code_scanner_viewmodel.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    Key? key,
  }) : super(key: key);

  final QrCodeScannerViewModel viewModel = QrCodeScannerViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Observer(
            builder: (_) => MobileScanner(
              key: UniqueKey(),
              controller: viewModel.mobileScannerController,
              onDetect: (barcode, args) {
                if (barcode.rawValue == null) {
                  debugPrint('Failed to scan QrCode');
                } else {
                  final String code = barcode.rawValue!;
                  debugPrint('QrCode found! $code');
                  dynamic jsonObject = jsonDecode(code);
                  if (jsonObject['outOfBandInvitation']['body']['url'] != null) {
                    locator.get<NavigationService>().router.push(
                          LoadingScreenRoute(
                            url: jsonObject['outOfBandInvitation']['body']['url'],
                          ),
                        );
                  }
                }
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      context.popRoute();
                      viewModel.mobileScannerController.dispose();
                    },
                    borderRadius: BorderRadius.circular(100),
                    // color: Colors.black,
                    child: SvgPicture.asset(AppAssets.closeIcon),
                  ),
                ),
              ),
            ),
          ),
          //debug
          // if (kDebugMode)
          //   Center(
          //     child: CupertinoButton.filled(
          //       child: const Text("do test call"),
          //       onPressed: () {
          //         String url = "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test_P_1";
          //         // Navigator.pushNamed(
          //         //   context,
          //         //   Routes.loading,
          //         //   arguments: url, //jsonObject['outOfBandInvitation']['body']['url'],
          //         // );
          //         // context.pushRoute(LoadingRoute(url: url));
          //         context.router.push(LoadingScreenRoute(url: url)).then((value) => viewModel.mobileScannerController = MobileScannerController());
          //       },
          //     ),
          //   ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 80),
            child: Text(
              S.of(context).scan_qr_code,
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
