import 'dart:convert';

import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'pending_service.g.dart';

class PendingService extends _PendingService with _$PendingService {}

abstract class _PendingService with Store {
  @observable
  ObservableStream<List<PendingRequest>> pendingRequests = ExchangeRepository.pendingRequestDao.pendingRequestsStream().asObservable();

  _PendingService() {
    pendingRequests.listen((value) async {
      for (var request in value) {
        Logger().d("${DateTime.now()} -> $value");
        bool exchangeCompleted = false;
        while (!exchangeCompleted) {
          await Future.delayed(const Duration(seconds: 10));

          await ExchangeRepository.continueExchangeBySubmittingDIDProof(
            serviceEndpoint: request.serviceEndpoint,
            vpRequest: jsonDecode(request.vp),
            onSuccess: (response) {
              if (response['processingInProgress'] == false) {
                ExchangeRepository.pendingRequestDao.updatePendingRequest(id: request.id, vc: response['vp']);
                exchangeCompleted = true;
              }
            },
            onError: (e) {
              return false;
            },
            showDialogs: false,
          );
        }
      }
    });
  }
}
