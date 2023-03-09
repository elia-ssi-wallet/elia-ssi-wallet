import 'package:expandable/expandable.dart';
import 'package:mobx/mobx.dart';

part 'compatible_contract_item_viewmodel.g.dart';

class CompatibleContractsItemViewModel extends _CompatibleContractsItemViewModel with _$CompatibleContractsItemViewModel {}

abstract class _CompatibleContractsItemViewModel with Store {
  _CompatibleContractsItemViewModel();

  @observable
  ExpandableController expandableController = ExpandableController();

  @observable
  bool expandedBool = false;
}
