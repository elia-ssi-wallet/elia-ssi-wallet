import 'dart:async';
import 'dart:convert';

import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'pending_service.g.dart';

class PendingService extends _PendingService with _$PendingService {}

abstract class _PendingService with Store {
  @observable
  ObservableStream<List<PendingRequest>> pendingRequests = ExchangeRepository.pendingRequestDao.pendingRequestsStream().asObservable();

  Timer? timer;
  _PendingService() {
    pendingRequests.listen((value) {
      if (value.isEmpty) {
        debugPrint("cancel timer ${DateTime.now()}");
        timer?.cancel();
        timer = null;
      } else {
        debugPrint("start timer ${DateTime.now()}");
        timer?.cancel();
        timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
          debugPrint("pending requests -> refresh ${DateTime.now()}");

          await refreshPendingRequests();
        });
      }
    });
  }

  refreshPendingRequests() async {
    List<PendingRequest> requests = await ExchangeRepository.pendingRequestDao.getPendingRequestsNotCompleted();

    for (var request in requests) {
      await ExchangeRepository.submitPresentation(
        serviceEndpoint: request.serviceEndpoint,
        vpRequest: jsonDecode(request.requestVp),
        onSuccess: (response) {
          if (response['processingInProgress'] == false) {
            ExchangeRepository.pendingRequestDao.updatePendingRequest(id: request.id, vp: response['vp']);
          }
        },
        onError: (e) async {
          await ExchangeRepository.pendingRequestDao.updatePendingRequestWithError(id: request.id);
        },
        showDialogs: false,
      );
    }
  }
}
