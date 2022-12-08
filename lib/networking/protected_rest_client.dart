import 'package:elia_ssi_wallet/flavors.dart';

import '../networking/base_rest_client.dart';

class ProtectedRestClient extends BaseRestClient {
  ProtectedRestClient({this.showFullError = false});

  final bool showFullError;
  @override
  String apiUrl() {
    return F.apiUrl;
  }

  @override
  bool isProtected() {
    return true;
  }

  @override
  bool fullError() {
    return showFullError;
  }
}
