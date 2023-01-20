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

  // group('Initiate Issuence & Create Did Authentication Proof', () {
  //   dynamic body = {
  //     "did": 'did:key:z6MkqDkpUZMebGpkn6YE6XmFWodMKWeBKurWPMJqndgTrEpz',
  //     "options": {
  //       "verificationMethod": 'did:key:z6MkqDkpUZMebGpkn6YE6XmFWodMKWeBKurWPMJqndgTrEpz#z6MkqDkpUZMebGpkn6YE6XmFWodMKWeBKurWPMJqndgTrEpz',
  //       "proofPurpose": "authentication",
  //       "challenge": 'ddd41098-17b3-4a14-a644-7854ff373084',
  //     },
  //   };

  //   String exchangeURL = 'https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test';

  //   final client = ApiManagerService(TestRestClient().dio);

  //   test(
  //     'Initiate Issuance',
  //     () async {
  //       try {
  //         dynamic result = await client.initiateIssuance(exchangeURL: exchangeURL);

  //         expect(result['vpRequest']['challenge'].runtimeType, String);

  //         expect(result['vpRequest']['interact']['service'][0]['serviceEndpoint'].runtimeType, String);

  //         expect(result['processingInProgress'].runtimeType, bool);

  //         // body['options']['challenge'] = result['vpRequest']['challenge'];
  //       } on DioError catch (e) {
  //         handleError(e);
  //       }
  //     },
  //   );

  //   test(
  //     'Create Did Authentication Proof',
  //     () async {
  //       try {
  //         dynamic result = await client.createDidAuthenticationProof(
  //           baseUrl: exchangeURL.getBaseUrlfromExchangeUrl(),
  //           body: body,
  //         );

  //         expect(result['@context'].runtimeType, List<dynamic>);
  //         expect(result['type'].runtimeType, String);
  //         expect(result['proof']['type'].runtimeType, String);
  //         expect(result['proof']['proofPurpose'].runtimeType, String);
  //         expect(result['proof']['challenge'].runtimeType, String);
  //         expect(result['proof']['verificationMethod'].runtimeType, String);
  //         expect(result['proof']['verificationMethod'].substring(0, 7), 'did:key');
  //         expect(result['proof']['created'].runtimeType, String);
  //         expect(result['proof']['jws'].runtimeType, String);
  //         expect(result['holder'].runtimeType, String);
  //         expect(result['holder'].substring(0, 7), 'did:key');
  //       } on DioError catch (e) {
  //         handleError(e);
  //       }
  //     },
  //   );
  // });

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

          challenge = result['vpRequest']['challenge'];

          // body['options']['challenge'] = result['vpRequest']['challenge'];
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
            dynamic result = await client.createDidAuthenticationProof(
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
  });
}
