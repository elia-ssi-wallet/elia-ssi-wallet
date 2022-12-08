import 'dart:convert';

import 'package:elia_ssi_wallet/pages/home/home_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatelessWidget {
  QRCodeScanner({Key? key}) : super(key: key);

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

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
                ExchangeRepository.initiateIssuance(
                  exchangeURL: jsonObject['outOfBandInvitation']['body']['url'],
                  onSuccess: (vpRequest) {
                    ExchangeRepository.createDidAuthenticationProof(
                      challenge: vpRequest['vpRequest']['challenge'],
                      onSuccess: (vp) {
                        ExchangeRepository.continueExchangeBySubmittingDIDProof(
                          serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
                          vpRequest: vp,
                          onSuccess: (_) {},
                          onError: (_) {},
                        );
                      },
                      onError: (_) {},
                    );
                  },
                  onError: (_) {},
                );
                Navigator.pop(context);
              }
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(100),
                  // color: Colors.black,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: 16,
                        // color: Colors.transparent,
                      ),
                    ),
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
                color: Colors.white,
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
