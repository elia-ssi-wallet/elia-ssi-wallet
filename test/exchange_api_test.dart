import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/test_rest_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

void main() {
  handleError(DioError e) {
    final res = e.response;
    throw Exception(res?.data);
  }

  group('Presentation sequence', () {
    final client = ApiManagerService(TestRestClient().dio);

    String exchangeId = 'exchanges/test';

    String baseUrl = 'https://vc-api-dev.energyweb.org/v1/vc-api';

    String exchangeUrl = '$baseUrl/$exchangeId';

    dynamic exchangeDefinitions = {
      "exchangeId": exchangeId,
      "query": [
        {
          "type": "DIDAuth",
          "credentialQuery": [],
        }
      ],
      "interactServices": [
        {"type": "MediatedHttpPresentationService2021"}
      ],
      "callback": [
        {"url": "https://webhook.site/83213d5a-e1ab-46ad-b284-372dcae1e6a9"}
      ],
      "isOneTime": true
    };

    String challenge = const Uuid().v4();

    dynamic presentationWithCredential = {
      "@context": ["https://www.w3.org/2018/credentials/v1"],
      "type": "VerifiablePresentation",
      "proof": {
        "type": "Ed25519Signature2018",
        "proofPurpose": "authentication",
        "challenge": "d98b491b-6791-478d-9c46-85baec76d2dd",
        "verificationMethod": "did:key:z6MkgP6wSUAiiDHGVgaJYptPgcAtSfy6Azp9SxVSy9B611ew#z6MkgP6wSUAiiDHGVgaJYptPgcAtSfy6Azp9SxVSy9B611ew",
        "created": "2023-03-08T07:42:04.043Z",
        "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..EfmkojTqPtg6-el1JbXZGG1RFuVq2jQlVoviIJfm8Ev09AlFN2JdEd9bA9nBG-7Ok8KGdeIv0P-c2zMXhr1qDQ"
      },
      "holder": "did:key:z6MkgP6wSUAiiDHGVgaJYptPgcAtSfy6Azp9SxVSy9B611ew"
    };

    String serviceEndpoint = 'https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test/9a2399d1-67ea-401b-bc77-088953f69e01';

    test(
      'Configure Exchange',
      () async {
        // exchangeId = '/exchanges/${const Uuid().v4()}';
        try {
          exchangeDefinitions['exchangeId'] = const Uuid().v4();
          dynamic result = await client.configureExchange(
            baseUrl: baseUrl,
            exchangeDefinitions: exchangeDefinitions,
          );
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );

    test(
      'Initiate Issuance',
      () async {
        try {
          dynamic result = await client.initiateIssuance(exchangeURL: exchangeUrl);

          expect(result['vpRequest']['challenge'].runtimeType, String);

          expect(result['vpRequest']['interact']['service'][0]['serviceEndpoint'].runtimeType, String);

          expect(result['processingInProgress'].runtimeType, bool);
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );

    test(
      'Create Did Authentication Proof',
      () async {
        try {
          dynamic body = {"method": "key"};

          dynamic result = await client.createDID(body: body);

          DIDToken token = DIDToken.fromJson(result);

          expect(token.id.substring(0, 7), 'did:key');
          for (var verificationMethod in token.verificationMethod) {
            expect(verificationMethod.id.substring(0, 7), 'did:key');
            expect(verificationMethod.controller.substring(0, 7), 'did:key');
          }

          var didAuthProofBody = {
            "did": token.id,
            "options": {
              "verificationMethod": token.verificationMethod.first.id,
              "proofPurpose": "authentication",
              "challenge": challenge,
            },
          };
          try {
            client.createDidAuthenticationProof(
              baseUrl: exchangeUrl.getBaseUrlfromExchangeUrl(),
              body: didAuthProofBody,
            );
          } on DioError catch (e) {
            handleError(e);
          }
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );

    test(
      'Submit Did Authentication Proof',
      () async {
        try {
          dynamic result = await client.submitProof(
            serviceEndpoint: serviceEndpoint,
            vpRequest: presentationWithCredential,
          );

          expect(result['errors'].runtimeType, List);
          expect(result['errors'].length, 0);
          expect(result['vpRequest']['challenge'].runtimeType, String);
          expect(result['vpRequest']['query'].runtimeType, List);
          expect(result['vpRequest']['query'][0]['type'].runtimeType, String);
          expect(result['vpRequest']['query'][0]['type'], 'DIDAuth');
          expect(result['vpRequest']['interact']['service'].runtimeType, List);
          expect(result['vpRequest']['interact']['service'][0]['type'].runtimeType, String);
          expect(result['vpRequest']['interact']['service'][0]['type'], 'MediatedHttpPresentationService2021');
          expect(result['processingInProgress'].runtimeType, bool);
          expect(result['processingInProgress'], true);
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );

    test(
      'Finish exchange',
      () async {
        try {
          dynamic result = await client.submitProof(
            serviceEndpoint: serviceEndpoint,
            vpRequest: presentationWithCredential,
          );

          expect(result['errors'].runtimeType, List);
          expect(result['errors'].length, 0);
          expect(result['vp']['type'].runtimeType, List);
          expect(result['vp']['type'][0].runtimeType, String);
          expect(result['vp']['type'][0], 'VerifiablePresentation');
          expect(result['vp']['verifiableCredential'].runtimeType, List);
          expect(result['vp']['verifiableCredential'][0]['type'][0].runtimeType, String);
          expect(result['vp']['verifiableCredential'][0]['type'][0], 'VerifiableCredential');
          expect(result['vp']['proof']['type'].runtimeType, String);
          expect(result['vp']['proof']['verificationMethod'].runtimeType, String);
          expect(result['vp']['proof']['created'].runtimeType, String);
          expect(DateTime.parse(result['vp']['proof']['created']).runtimeType, DateTime);
          expect(result['vp']['proof']['jws'].runtimeType, String);
          expect(result['processingInProgress'].runtimeType, bool);
          expect(result['processingInProgress'], false);
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );
  });
}
