import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'confirm_contract_screen_viewmodel.g.dart';

class ConfirmContractViewModel extends _ConfirmContractViewModel with _$ConfirmContractViewModel {}

abstract class _ConfirmContractViewModel with Store {
  _ConfirmContractViewModel();

  @observable
  PageController pageController = PageController();

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }
}
