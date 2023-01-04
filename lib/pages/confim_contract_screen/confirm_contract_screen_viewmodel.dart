import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'confirm_contract_screen_viewmodel.g.dart';

class ConfirmContractViewModel extends _ConfirmContractViewModel with _$ConfirmContractViewModel {}

abstract class _ConfirmContractViewModel with Store {
  _ConfirmContractViewModel();

  @observable
  TextEditingController issuerNameController = TextEditingController();
}
