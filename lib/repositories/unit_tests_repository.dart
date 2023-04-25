import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';

class UnitTestsRepository {
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
