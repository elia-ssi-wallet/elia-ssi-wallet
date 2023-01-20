import 'dart:convert';

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/base/helpers/alert_dialog_helper.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/qr_code_scanner/qr_code_scanner_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
                    String hostName = (jsonObject['outOfBandInvitation']['body']['url'] as String).prettifyDomain();
                    if (viewModel.connections.any((element) => element == hostName)) {
                      viewModel.mobileScannerController.dispose();
                      Navigator.pushNamed(
                        context,
                        Routes.loading,
                        arguments: jsonObject['outOfBandInvitation']['body']['url'],
                      ).then((value) => viewModel.mobileScannerController = MobileScannerController());
                    } else {
                      showPlatformAlertDialog(
                        title: S.of(context).new_connection,
                        subtitle: S.of(context).new_connection_communication('connection'),
                        isDismissable: true,
                        actions: [
                          MaterialButton(
                            child: Text(
                              S.of(context).always_accept,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              viewModel.dao.insertConnection(connectionName: hostName);
                              viewModel.mobileScannerController.dispose();
                              Navigator.pushNamed(
                                context,
                                Routes.loading,
                                arguments: jsonObject['outOfBandInvitation']['body']['url'],
                              ).then((value) => viewModel.mobileScannerController = MobileScannerController());
                            },
                          ),
                          MaterialButton(
                            child: Text(
                              S.of(context).accept_once,
                            ),
                            onPressed: () {
                              viewModel.mobileScannerController.dispose();
                              Navigator.pushNamed(
                                context,
                                Routes.loading,
                                arguments: jsonObject['outOfBandInvitation']['body']['url'],
                              ).then((value) => viewModel.mobileScannerController = MobileScannerController());
                            },
                          ),
                          MaterialButton(
                            child: Text(
                              S.of(context).dont_accept,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
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
                      Navigator.pop(context);
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
