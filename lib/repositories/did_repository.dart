import 'dart:convert';

import 'package:elia_ssi_wallet/base/secure_storage.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';
import 'package:logger/logger.dart';

class DIDRepository {
  // ignore: constant_identifier_names
  static const DID_TOKEN = "did_token";
  static final client = ApiManagerService(UnProtectedRestClient().dio);

  static Future<dynamic> createDID({required Function(dynamic object) onSuccess}) async {
    var body = {"method": "key"};

    return await doCall<dynamic>(
      client.createDID(body: body),
      succesFunction: (object) async {
        Logger().d("createDID: $object");

        await onSuccess(object);
      },
      errorFunction: (error) {
        Logger().d("createDID: $error");
      },
      showDialogs: false,
    );
  }

  static Future exportKey(
      {required dynamic didToken,
      required Function(
        dynamic publicKey,
        dynamic privateKey,
      )
          onSuccess}) async {
    await doCall<dynamic>(
      client.exportKey(keyId: didToken["verificationMethod"][0]["publicKeyJwk"]["kid"]),
      succesFunction: (object) async {
        Logger().d("exportKey: $object");
        await SecureStorage.writeSecureData(DID_TOKEN, jsonEncode(didToken));
        await SecureStorage.writeSecureData(SecureStorage.PUBLIC_KEY, jsonEncode(object["publicKey"]));
        await SecureStorage.writeSecureData(SecureStorage.PRIVATE_KEY, jsonEncode(object["privateKey"]));
        await onSuccess(object["publicKey"], object["privateKey"]);
      },
      errorFunction: (error) {
        Logger().d("exportKey: $error");
      },
    );
  }

  static Future importKey({required Function(String keyId) onSuccess}) async {
    String? publicKey = await SecureStorage.readSecureData(SecureStorage.PUBLIC_KEY);
    String? privateKey = await SecureStorage.readSecureData(SecureStorage.PRIVATE_KEY);

    if (publicKey != null && privateKey != null) {
      var body = {
        "publicKey": jsonDecode(publicKey),
        "privateKey": jsonDecode(privateKey),
      };

      await doCall<dynamic>(
        client.importKey(body: body),
        succesFunction: (object) async {
          Logger().d("importKey: $object");
          await onSuccess(object["keyId"]);
        },
        errorFunction: (error) {
          Logger().d("importKey: $error");
        },
      );
    }
  }

  static Future registerDID({required String keyId, required Function(dynamic key) onSuccess}) async {
    var body = {
      "method": "key",
      "keyId": keyId,
    };

    await doCall<dynamic>(
      client.registerDID(body: body),
      succesFunction: (object) async {
        Logger().d("registerDID: $object");
        await SecureStorage.writeSecureData(DID_TOKEN, jsonEncode(object));
        await onSuccess(object);
      },
      errorFunction: (error) {
        Logger().d("registerDID: $error");
      },
    );
  }

  static Future<DIDToken?> getDidTokenFromSecureStorage() async {
    String? token = await SecureStorage.readSecureData(DID_TOKEN);
    if (token != null) {
      return DIDToken.fromJson(jsonDecode(token));
    } else {
      return null;
    }
  }

  static Future<bool> checkIfDIDExists({required String did}) async {
    bool exists = false;

    await doCall<dynamic>(
      client.checkIfDIDExists(did: did),
      succesFunction: (object) async {
        Logger().d("checkIfDIDExists: $object");
        exists = true;
      },
      errorFunction: (error) {
        Logger().d("checkIfDIDExists: $error");
      },
    );
    return exists;
  }

  static Future<bool> createAndExportDID() async {
    var success = false;
    await createDID(onSuccess: (didToken) async {
      await exportKey(
          didToken: didToken,
          onSuccess: (_, __) {
            Logger().i("KEY EXPORTED");
            success = true;
          });
    });

    return success;
  }

  static Future<bool> importAndRegisterDIDToken() async {
    var success = false;
    await importKey(
      onSuccess: (keyId) async {
        await registerDID(
          keyId: keyId,
          onSuccess: (val) {
            Logger().i("KEY REGISTERED");
            success = true;
          },
        );
      },
    );

    return success;
  }

  static Future<bool> initalCheckForDID() async {
    var success = false;

    DIDToken? token = await DIDRepository.getDidTokenFromSecureStorage();
    String? publicKey = await SecureStorage.readSecureData(SecureStorage.PUBLIC_KEY);
    String? privateKey = await SecureStorage.readSecureData(SecureStorage.PRIVATE_KEY);
    if (token != null && publicKey != null && privateKey != null) {
      bool onServer = await DIDRepository.checkIfDIDExists(did: token.id);
      Logger().d(onServer);
      if (!onServer) {
        success = await DIDRepository.importAndRegisterDIDToken();
      } else {
        success = onServer;
      }
    } else {
      success = await DIDRepository.createAndExportDID();
    }

    return success;
  }
}
