import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/database/dao/vcs_dao.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:logger/logger.dart';

class ExchangeRepository {
  static VCsDao dao = VCsDao(database);

  //* 1.3 [Resident] Initiate issuance exchange using the request URL
  static Future initiateIssuance({
    required String exchangeURL,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).initiateIssuance(exchangeURL: exchangeURL),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }

  //* 1.6 [Resident] Continue exchange by submitting the DID Auth proof
  static Future<void> continueExchangeBySubmittingDIDProof({
    required String serviceEndpoint,
    // required String exchangeId,
    // required String transactionId,
    required dynamic vpRequest,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      // ApiManagerService(UnProtectedRestClient().dio).continueExchangeWithDIDAuthProof(exchangeId: exchangeId, transactionId: transactionId, vpRequest: vpRequest),
      ApiManagerService(UnProtectedRestClient().dio).continueExchangeWithDIDAuthProof(serviceEndpoint: serviceEndpoint, vpRequest: vpRequest),
      succesFunction: (object) async {
        Logger().d("continueExchangeWithDIDAuthProof: $object");
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }

  //* 1.12 [Resident] Continue the exchange and obtain the credentials
  static Future<void> continueTheExchangeAndObtainTheCredentials({
    required String serviceEndpoint,
    required dynamic vpRequest,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).continueExchangeWithDIDAuthProof(serviceEndpoint: serviceEndpoint, vpRequest: vpRequest),
      succesFunction: (obj) async {
        await onSuccess(obj);
      },
      errorFunction: (error) async {
        await onError(error);
      },
    );
  }

  static Future createDidAuthenticationProof({
    required String challenge,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    DIDToken? didToken = await DIDRepository.getDidTokenFromSecureStorage();

    if (didToken != null) {
      // dynamic jsonDidToken = jsonDecode(didToken);
      // jsonDidToken["id"];
      // jsonDidToken["verificationMethod"][0]["id"];

      var body = {
        "did": didToken.id,
        "options": {
          "verificationMethod": didToken.verificationMethod.first.id,
          "proofPurpose": "authentication",
          "challenge": challenge,
        },
      };

      await doCall<dynamic>(
        ApiManagerService(UnProtectedRestClient().dio).createDidAuthenticationProof(body: body),
        succesFunction: (object) async {
          Logger().d("createDidAuthenticationProof: $object");
          await onSuccess(object);
        },
        errorFunction: (error) async {
          Logger().e("createDidAuthenticationProof: $error");
          await onError(error);
        },
      );
    } else {
      Logger().e("No did token");

      onError("No did token");
    }
  }
}
