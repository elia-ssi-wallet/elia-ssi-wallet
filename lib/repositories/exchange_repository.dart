// ignore_for_file: use_build_context_synchronously

import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/base/helpers/alert_dialog_helper.dart';
import 'package:elia_ssi_wallet/database/dao/all_daos.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ExchangeRepository {
  static VCsDao dao = VCsDao(database);
  static PendingRequestsDao pendingRequestDao = PendingRequestsDao(database);

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

  static Future<void> submitPresentation({
    required String serviceEndpoint,
    required dynamic vpRequest,
    required Function(dynamic object) onSuccess,
    required Function(dynamic object) onError,
    bool showDialogs = true,
  }) async {
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).submitProof(serviceEndpoint: serviceEndpoint, vpRequest: vpRequest),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: showDialogs,
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
      var body = {
        "did": didToken.id,
        "options": {
          "verificationMethod": didToken.verificationMethod.first.id,
          "proofPurpose": "authentication",
          "challenge": challenge,
        },
      };

      var didExists = await DIDRepository.initalCheckForDID();

      if (didExists) {
        await doCall<dynamic>(
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
        await onError("No did token");
      }
    } else {
      Logger().e("No did token");

      onError("No did token");
    }
  }

  static Future<void> createPresentation({
    required dynamic presentation,
    required Function(dynamic object) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    String baseUrl = 'https://vc-api-dev.energyweb.org';
    await doCall<dynamic>(
      ApiManagerService(UnProtectedRestClient().dio).createPresentation(baseUrl: baseUrl, presentation: presentation),
      succesFunction: (object) async {
        await onSuccess(object);
      },
      errorFunction: (error) async {
        await onError(error);
      },
      showDialogs: false,
    );
  }

  static String? verifyObject({required dynamic object}) {
    String? url;
    if (object['outOfBandInvitation']?['body']?['url'] != null) {
      url = object['outOfBandInvitation']['body']['url'];
    }
    return url;
  }

  static showConnectionDialog({required BuildContext context, required String name, required Function() onAccept, required Function() onReject}) async {
    var connection = await ConnectionsDao(database).getConnectionWithName(name: name);

    if (connection == null) {
      await showPlatformAlertDialog(
        context: context,
        title: S.of(context).new_connection,
        subtitle: S.of(context).new_connection_communication(name),
        isDismissable: true,
        actions: [
          MaterialButton(
            child: Text(
              S.of(context).always_accept,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              //* add to connection list
              await ConnectionsDao(database).insertConnection(connectionName: name);
              onAccept();
            },
          ),
          MaterialButton(
            child: Text(
              S.of(context).accept_once,
            ),
            onPressed: () {
              onAccept();
            },
          ),
          MaterialButton(
            child: Text(
              S.of(context).dont_accept,
            ),
            onPressed: () {
              onReject();
            },
          ),
        ],
      );
    } else {
      onAccept();
    }
  }
}
