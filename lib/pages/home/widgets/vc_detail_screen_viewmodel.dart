import 'package:mobx/mobx.dart';

part 'vc_detail_screen_viewmodel.g.dart';

class VCDetailScreenViewmodel extends _VCDetailScreenViewmodel with _$VCDetailScreenViewmodel {}

abstract class _VCDetailScreenViewmodel with Store {
  @observable
  bool showAll = false;
}
