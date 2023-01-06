import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:mobx/mobx.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenViewModel extends _HomeScreenViewModel with _$HomeScreenViewModel {}

abstract class _HomeScreenViewModel with Store {
  @observable
  int index = 0;

  @observable
  ObservableStream<List<VC>> vCsStream = ExchangeRepository.dao.vCsStream().asObservable();

  _HomeScreenViewModel() {
    DIDRepository.initalCheckForDID();
  }
}
