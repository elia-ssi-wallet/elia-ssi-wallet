import 'package:mobx/mobx.dart';

part 'accept_terms_and_conditions_viewmodel.g.dart';

class AcceptTermsAndConditionsViewModel extends _AcceptTermsAndConditionsViewModel with _$AcceptTermsAndConditionsViewModel {}

abstract class _AcceptTermsAndConditionsViewModel with Store {
  @observable
  bool tos = false;
}
