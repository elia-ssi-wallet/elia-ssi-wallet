import 'package:mobx/mobx.dart';

part 'consent_screen_viewmodel.g.dart';

class ConsentScreenViewModel extends _ConsentScreenViewModel with _$ConsentScreenViewModel {}

abstract class _ConsentScreenViewModel with Store {
  @observable
  bool accepted = false;
}
