// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/models/did/private_key.dart';
import 'package:elia_ssi_wallet/models/did/public_key.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/test_rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('All DID steps', () {
    dynamic body = {"method": "key"};

    String keyId = 'WcgEixSN6gSKN8UkWNbVpDqivaobWRUS-ucojIsHYw4';

    dynamic privKeyPubKey = {
      "privateKey": {
        "crv": "Ed25519",
        "d": "fgsyP56n2nTIPTVCmB4cobQ4_FFqH1Ojtww11EN0HJI",
        "x": "MQtprezR-qMgbgqyXZW9RSaoThRbXxXHKc4alfmeGZM",
        "kty": "OKP",
      },
      "publicKey": {
        "crv": "Ed25519",
        "x": "MQtprezR-qMgbgqyXZW9RSaoThRbXxXHKc4alfmeGZM",
        "kty": "OKP",
        "kid": "WcgEixSN6gSKN8UkWNbVpDqivaobWRUS-ucojIsHYw4",
      },
    };

    String did = 'did:key:z6Mkhki7hCyQkLufYA6X1gvhn4Kx21eRraVG9NggipDNmMfx';

    test(
      'Create DID',
      () async {
        final client = ApiManagerService(TestRestClient().dio);

        dynamic result = await client.createDID(body: body);

        DIDToken token = DIDToken.fromJson(result);

        expect(token.id.substring(0, 7), 'did:key');
        for (var verificationMethod in token.verificationMethod) {
          expect(verificationMethod.id.substring(0, 7), 'did:key');
          expect(verificationMethod.controller.substring(0, 7), 'did:key');
        }

        keyId = token.verificationMethod.first.publicKeyJwk.kid;
      },
    );

    test(
      'Export DID',
      () async {
        final client = ApiManagerService(TestRestClient().dio);

        dynamic result = await client.exportKey(keyId: keyId);

        expect(result['publicKeyThumbprint'], keyId);

        PrivateKey.fromJson(result['privateKey']);
        PublicKey.fromJson(result['publicKey']);

        privKeyPubKey = {
          "privateKey": result['privateKey'],
          "publicKey": result['publicKey'],
        };
      },
    );

    test(
      'Import DID',
      () async {
        final client = ApiManagerService(TestRestClient().dio);

        dynamic result = await client.importKey(body: privKeyPubKey);

        expect(result['keyId'], keyId);
      },
    );

    test(
      'Register DID',
      () async {
        final client = ApiManagerService(TestRestClient().dio);

        dynamic registerBody = {
          "method": "key",
          "keyId": keyId,
        };

        dynamic result = await client.registerDID(body: registerBody);

        DIDToken token = DIDToken.fromJson(result);

        expect(token.id.substring(0, 7), 'did:key');
        for (var verificationMethod in token.verificationMethod) {
          expect(verificationMethod.id.substring(0, 7), 'did:key');
          expect(verificationMethod.controller.substring(0, 7), 'did:key');
          expect(verificationMethod.publicKeyJwk.kid, keyId);
        }

        did = token.id;
      },
    );

    test(
      'Check if DID exists',
      () async {
        final client = ApiManagerService(TestRestClient().dio);

        dynamic result = await client.checkIfDIDExists(did: did);

        DIDToken token = DIDToken.fromJson(result);

        expect(token.id.substring(0, 7), 'did:key');
        expect(token.id, did);
        for (var verificationMethod in token.verificationMethod) {
          expect(verificationMethod.id.substring(0, 7), 'did:key');
          expect(verificationMethod.controller.substring(0, 7), 'did:key');
          expect(verificationMethod.publicKeyJwk.kid, keyId);
        }
      },
    );
  });
}
