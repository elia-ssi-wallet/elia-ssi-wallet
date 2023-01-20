import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';

class ConsentRepository {
  Future<void> initiateIssuance({
    required String endpoint,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).initiateConsentIssuance(endpoint: endpoint),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }

  Future<void> convertInputToCredential({
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
    );
  }

  Future<void> issueSelfSignedCredential({
    required String baseUrl,
    required dynamic credential,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).issueSelfSignedContract(baseUrl: baseUrl, credential: credential),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }

  Future<void> createPresentation({
    required String baseUrl,
    required dynamic presentation,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).createPresentationWithSelfSignedCredential(baseUrl: baseUrl, presentation: presentation),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }

  Future<void> submitExchange({
    required String endpoint,
    required dynamic presentationWithCredential,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).continueExchangeBySubmitting(endpoint: endpoint, presentationWithCredential: presentationWithCredential),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }
}
