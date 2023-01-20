import 'package:elia_ssi_wallet/database/database.dart';

extension Extension on VC {
  String type() {
    List<String> types = this.types;

    if (types.length > 1) {
      types.removeWhere((element) => element == "VerifiableCredential");
      return types.first;
    } else {
      return types.first;
    }
  }
}
