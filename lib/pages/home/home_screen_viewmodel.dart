import 'package:mobx/mobx.dart';

part 'home_screen_viewmodel.g.dart';

class HomeScreenViewModel extends _HomeScreenViewModel with _$HomeScreenViewModel {}

abstract class _HomeScreenViewModel with Store {
  @observable
  int index = 0;

  @observable
  String? didToken = '';

  @observable
  ObservableList linkedContracts = [
    {
      'type': 'electric car',
      'name': 'Nissan Leaf',
    },
    {
      'type': 'dishwasher',
      'name': 'Whirlpool XB12',
    },
    {
      'type': 'battery',
      'name': 'BigBattery',
    },
    {
      'type': 'gov identity',
      'name': 'Identity',
    },
  ].asObservable();
}
