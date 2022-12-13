import 'dart:convert';

import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:mobx/mobx.dart';

part 'did_token_viewmodel.g.dart';

class DidTokenViewModel extends _DidTokenViewModel with _$DidTokenViewModel {}

abstract class _DidTokenViewModel with Store {
  @observable
  bool obscure = true;

  @observable
  DIDToken? didToken;

  _DidTokenViewModel() {
    getTokenFromSecureStorage();
  }

  Future<void> getTokenFromSecureStorage() async {
    String? didTokenFromStorage = await DIDRepository.getDidTokenFromSecureStorage();

    if (didTokenFromStorage != null) {
      DIDToken obj = DIDToken.fromJson(jsonDecode(didTokenFromStorage));
      didToken = obj;
    }
  }
}
