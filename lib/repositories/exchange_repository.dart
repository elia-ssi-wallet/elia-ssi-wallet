import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/database/dao/pending_requests_dao.dart';
import 'package:elia_ssi_wallet/database/dao/vcs_dao.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:logger/logger.dart';

class ExchangeRepository {
  static VCsDao dao = VCsDao(database);
  static PendingRequestsDao pendingRequestDao = PendingRequestsDao(database);

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
      showDialogs: false,
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
    bool showDialogs = true,
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
      showDialogs: showDialogs,
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
      showDialogs: false,
    );
  }

  static Future createDidAuthenticationProof({
    required String challenge,
    required String baseUrl,
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
        // https://vc-api-dev.energyweb.org/v1/vc-api/presentations/prove/authentication
        ApiManagerService(UnProtectedRestClient().dio).createDidAuthenticationProof(baseUrl: baseUrl, body: body),
        succesFunction: (object) async {
          Logger().d("createDidAuthenticationProof: $object");
          await onSuccess(object);
        },
        errorFunction: (error) async {
          Logger().e("createDidAuthenticationProof: $error");
          await onError(error);
        },
        showDialogs: false,
      );
    } else {
      Logger().e("No did token");

      onError("No did token");
    }
  }

  //* Authority Part

  static Future<void> configureExchange({
    required String baseUrl,
    required dynamic exchangeDefinitions,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).configureExchange(baseUrl: baseUrl, exchangeDefinitions: exchangeDefinitions),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: false,
    );
  }

  static Future<void> issueVC({
    required String baseUrl,
    required dynamic vc,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).issueVC(baseUrl: baseUrl, vc: vc),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: false,
    );
  }

  static Future<void> wrapVcInVp({
    required String baseUrl,
    required dynamic vp,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).wrapVcInVp(baseUrl: baseUrl, vp: vp),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: false,
    );
  }

  static Future<void> reviewExchange({
    required String baseUrl,
    required String exchangeId,
    required String transactionId,
    required dynamic vp,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).reviewExchange(baseUrl: baseUrl, exchangeId: exchangeId, transactionId: transactionId, vp: vp),
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
