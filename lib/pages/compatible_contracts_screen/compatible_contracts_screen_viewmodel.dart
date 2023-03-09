import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:mobx/mobx.dart';

part 'compatible_contracts_screen_viewmodel.g.dart';

class CompatibleContractsScreenViewModel extends _CompatibleContractsScreenViewModel with _$CompatibleContractsScreenViewModel {
  CompatibleContractsScreenViewModel({
    required String type,
  }) : super(type);
}

abstract class _CompatibleContractsScreenViewModel with Store {
  _CompatibleContractsScreenViewModel(type) {
    getVCs(type);
  }

  @observable
  ObservableList<VC> vCs = ObservableList();

  @observable
  ObservableList boolList = ObservableList();

  getVCs(String type) async {
    vCs = (await ExchangeRepository.dao.searchVcFuture(type)).asObservable();
    boolList = List.generate(vCs.length, (index) => false).asObservable();
  }
}
