import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';

class ConsentRepository {
  static Future<void> convertInputToCredential({
    required dynamic inputDescriptor,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    String idcUrl = "https://inpdesc-to-cred-dev.energyweb.org";

    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).convertInputDescriptorToCredential(idcUrl: idcUrl, inputDescriptor: inputDescriptor),
      succesFunction: (object) async {
        //todo: save object to database as self-signed
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: false,
    );
  }

  static Future<void> issueSelfSignedCredential({
    // required String baseUrl,
    required dynamic credential,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    String baseUrl = 'https://vc-api-dev.energyweb.org';
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).issueSelfSignedContract(baseUrl: baseUrl, credential: credential),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: false,
    );
  }
}
