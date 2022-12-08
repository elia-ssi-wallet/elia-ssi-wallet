import 'package:elia_ssi_wallet/flavors.dart';

import '../networking/base_rest_client.dart';

class UnProtectedRestClient extends BaseRestClient {
  UnProtectedRestClient({this.showFullError = false});

  final bool showFullError;
  @override
  String apiUrl() {
    return F.apiUrl;
  }

  @override
  bool isProtected() {
    return false;
  }

  @override
  bool fullError() {
    return showFullError;
  }
}
