import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:elia_ssi_wallet/services/pending_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenViewModel extends _HomeScreenViewModel with _$HomeScreenViewModel {}

abstract class _HomeScreenViewModel with Store {
  @observable
  int index = 0;

  @observable
  VC? newlyAddedVC;

  @observable
  bool showNotification = false;

  @observable
  TextEditingController searchController = TextEditingController();

  @observable
  ObservableStream<List<VC>> vCsStream = ExchangeRepository.dao.vCsStream().asObservable();

  @observable
  ObservableStream<List<VC>> allVcs = ExchangeRepository.dao.vCsStream().asObservable();

  @observable
  ObservableStream<List<VC>> selfSignedVcStream = Stream<List<VC>>.value([]).asObservable();

  @observable
  ObservableStream<List<VC>> allSelfSignedVcs = Stream<List<VC>>.value([]).asObservable();

  @computed
  bool get noVcs => allVcs.value?.isEmpty == true;

  @computed
  bool get noSelfSignedVcs => allSelfSignedVcs.value?.isEmpty == true;

  @computed
  bool get showNotificationComputed => showNotification && newlyAddedVC != null;

  @observable
  ObservableStream<List<PendingRequest>> pendingRequests = ExchangeRepository.pendingRequestDao.requestsStream().asObservable();

  _HomeScreenViewModel() {
    DIDRepository.initalCheckForDID();

    searchController.addListener(() {
      search();
    });

    PendingService();
  }

  Future<dynamic> search() async {
    vCsStream = ExchangeRepository.dao.searchVcStream(searchController.text.isEmpty ? null : searchController.text).asObservable();
  }

  Future<void> updateNotification({required VC vc}) async {
    showNotification = true;
    newlyAddedVC = vc;
    await Future.delayed(const Duration(seconds: 5));
    Logger().d("remove notification");
    newlyAddedVC = null;
    showNotification = false;
  }

  Future testNotification() async {
    if (newlyAddedVC == null && !showNotification) {
      newlyAddedVC = const VC(
        id: 1,
        label: "test new vc",
        vc: "vc",
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
