import 'dart:async';

import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:elia_ssi_wallet/services/pending_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenViewModel extends _HomeScreenViewModel with _$HomeScreenViewModel {}

abstract class _HomeScreenViewModel with Store {
  @observable
  VC? newlyAddedVC;

  @observable
  String? didTokenId;

  @observable
  bool showNotification = false;

  @observable
  TextEditingController searchController = TextEditingController();

  @computed
  bool get showNotificationComputed => showNotification && newlyAddedVC != null;

  final _externalVCsController = BehaviorSubject<List<VC>>.seeded([]);
  final _selfSignedVcController = BehaviorSubject<List<VC>>.seeded([]);
  final _pendingRequestsController = BehaviorSubject<List<PendingRequest>>.seeded([]);

  Stream<List<VC>> get externalVCsStream => _externalVCsController.stream;
  Stream<List<VC>> get selfSignedVcStream => _selfSignedVcController.stream;
  Stream<List<PendingRequest>> get pendingRequests => _pendingRequestsController.stream;

  @observable
  bool noSearch = true;

  _HomeScreenViewModel() {
    initStreams();

    searchController.addListener(() {
      noSearch = searchController.text.isEmpty;
      search();
    });

    PendingService();
  }

  initStreams() async {
    DIDToken? token = await DIDRepository.getDidTokenFromSecureStorage();
    didTokenId = token?.id;
    if (token != null) {
      ExchangeRepository.dao.externalVCsStream(id: token.id).listen((data) {
        _externalVCsController.add(data);
      });

      ExchangeRepository.dao.selfSignedVCsStream(id: token.id).listen((data) {
        _selfSignedVcController.add(data);
      });
      ExchangeRepository.pendingRequestDao.requestsStream().listen((data) {
        _pendingRequestsController.add(data);
      });
    } else {
      Logger().e('No DID token found');
    }
  }

  Future<dynamic> search() async {
    if (didTokenId != null) {
      ExchangeRepository.dao
          .searchExternalVcsStream(
        query: searchController.text.isEmpty ? null : searchController.text,
        id: didTokenId!,
      )
          .listen((data) {
        _externalVCsController.add(data);
      });

      ExchangeRepository.dao
          .searchSelfSignedVcsStream(
        query: searchController.text.isEmpty ? null : searchController.text,
        id: didTokenId!,
      )
          .listen((data) {
        _selfSignedVcController.add(data);
      });
    }
  }

  Future testNotification() async {
    if (newlyAddedVC == null && !showNotification) {
      newlyAddedVC = VC(
        id: 1,
        issuerLabel: "test new vc",
        title: 'test new vc',
        vc: "vc",
        issuerDid: "issuerDid",
        issuanceDate: DateTime.now(),
        types: [],
        activity: [],
      );
      showNotification = true;
    } else {
      newlyAddedVC = null;
      showNotification = false;
    }
  }
}
