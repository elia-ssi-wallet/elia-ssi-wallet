import 'package:mobx/mobx.dart';

part 'qr_code_scanner_viewmodel.g.dart';

class QrCodeScannerViewModel extends _QrCodeScannerViewModel with _$QrCodeScannerViewModel {}

abstract class _QrCodeScannerViewModel with Store {
  // @observable
  // int attempts = 0;

  // @observable
  // bool exchangeCompleted = false;

  // Future<void> periodicCall({required String serviceEndpoint, required dynamic vp}) async {
  //   while (!exchangeCompleted) {
  //     await Future.delayed(
  //       Duration(seconds: attempts),
  //       () async {
  //         attempts++;
  //         await ExchangeRepository.continueExchangeBySubmittingDIDProof(
  //           serviceEndpoint: serviceEndpoint,
  //           vpRequest: vp,
  //           onSuccess: (response) async {
  //             if (response['processingInProgress'] == true) {
  //               print('Attempts: $attempts');
  //               print('Continuing exchange');
  //               exchangeCompleted = false;
  //             } else {
  //               print('Exchange completed');
  //               exchangeCompleted = true;
  //             }
  //           },
  //           onError: (_) {
  //             // exchangeCompleted = false;
  //           },
  //         );
  //       },
  //     );
  //   }
  // }
}
