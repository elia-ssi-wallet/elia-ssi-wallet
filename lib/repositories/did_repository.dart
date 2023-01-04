import 'dart:convert';

import 'package:elia_ssi_wallet/base/secure_storage.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/networking/unprotected_rest_client.dart';
import 'package:logger/logger.dart';

class DIDRepository {
  // ignore: constant_identifier_names
  static const DID_TOKEN = "did_token";
  static final client = ApiManagerService(UnProtectedRestClient().dio);

  static Future<void> createAndRegisterNewDID() async {
    await createDID(
      onSuccess: (keyId) async {
        await exportKey(
          keyId: keyId,
          onSuccess: (publicKey, privateKey) async {
            await importKey(
              publicKey: publicKey,
              privateKey: privateKey,
              onSuccess: (keyId) async {
                await registerDID(
                  keyId: keyId,
                  onSuccess: (key) async {
                    bool exists = await checkIfDIDExists(did: key["id"]);
                    Logger().i("did exists => $exists");
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  static Future<dynamic> createDID({required Function(String keyId) onSuccess}) async {
    var body = {"method": "key"};

    // var didToken;

    return await doCall<dynamic>(
      client.createDID(body: body),
      succesFunction: (object) async {
        Logger().d("createDID: $object");
        // didToken = object;
        await onSuccess(object["verificationMethod"][0]["publicKeyJwk"]["kid"]);
      },
      errorFunction: (error) {
        Logger().d("createDID: $error");
      },
      showDialogs: false,
    );

    // return didToken;
  }

  static Future exportKey(
      {required String keyId,
      required Function(
        dynamic publicKey,
        dynamic privateKey,
      )
          onSuccess}) async {
    await doCall<dynamic>(
      client.exportKey(keyId: keyId),
      succesFunction: (object) async {
        Logger().d("exportKey: $object");
        await onSuccess(object["publicKey"], object["privateKey"]);
      },
      errorFunction: (error) {
        Logger().d("exportKey: $error");
      },
    );
  }

  static Future importKey({required dynamic publicKey, required dynamic privateKey, required Function(String keyId) onSuccess}) async {
    var body = {
      "publicKey": publicKey,
      "privateKey": privateKey,
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

  static Future<String?> getDidTokenFromSecureStorage() async {
    return await SecureStorage.readSecureData(DID_TOKEN);
  }

  // static Future<DidToken?> getDidTokenFromSecureStorageCorrectModel() async {
  //   String? didToken = await SecureStorage.readSecureData(DID_TOKEN);
  //   if (didToken != null) {
  //     DidToken token = DidToken.fromJson(didToken);
  //     print("token -> ${token.id}");
  //   }
  //   return null;
  // }

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
}
