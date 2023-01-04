import 'dart:convert';

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/pages/qr_code_scanner/qr_code_scanner_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({Key? key}) : super(key: key);

  final QrCodeScannerViewModel viewModel = QrCodeScannerViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan QrCode');
              } else {
                final String code = barcode.rawValue!;
                debugPrint('QrCode found! $code');
                dynamic jsonObject = jsonDecode(code);
                debugPrint('QR url ${jsonObject['outOfBandInvitation']['body']['url']}');
                Navigator.pushReplacementNamed(
                  context,
                  Routes.loading,
                  arguments: jsonObject['outOfBandInvitation']['body']['url'],
                );

                // ExchangeRepository.initiateIssuance(
                //   exchangeURL: jsonObject['outOfBandInvitation']['body']['url'],
                //   onSuccess: (vpRequest) {
                //     print('serviceEndpoint: ${vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint']}');
                //     ExchangeRepository.createDidAuthenticationProof(
                //       challenge: vpRequest['vpRequest']['challenge'],
                //       onSuccess: (vp) {
                //         viewModel.periodicCall(
                //           serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
                //           vp: vp,
                //         );
                //       },
                //       onError: (_) {},
                //     );
                //   },
                //   onError: (_) {},
                // );
                // Navigator.pop(context);
              }
            },
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
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(100),
                    // color: Colors.black,
                    child: SvgPicture.asset(AppAssets.closeIcon),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 80),
            child: Text(
              'Scan QR Code',
              style: TextStyle(
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
