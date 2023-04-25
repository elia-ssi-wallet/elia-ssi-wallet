import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:mobx/mobx.dart';

part 'compatible_contracts_screen_viewmodel.g.dart';

class CompatibleContractsScreenViewModel extends _CompatibleContractsScreenViewModel with _$CompatibleContractsScreenViewModel {
  CompatibleContractsScreenViewModel({
    required List<String> types,
  }) : super(types);
}

abstract class _CompatibleContractsScreenViewModel with Store {
  _CompatibleContractsScreenViewModel(types) {
    getVCs(types);
  }

  @observable
  ObservableList<VC> vCs = ObservableList();

  @observable
  ObservableList selectedBoolList = ObservableList();

  @observable
  ObservableList expanedBoolList = ObservableList();

  getVCs(List<String> types) async {
    vCs = (await ExchangeRepository.dao.searchVcFuture(types)).asObservable();
    selectedBoolList = List.generate(vCs.length, (index) => false).asObservable();
    expanedBoolList = List.generate(vCs.length, (index) => false).asObservable();
  }
}
