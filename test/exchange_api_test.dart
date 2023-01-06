import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/test_rest_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

void main() {
  handleError(DioError e) {
    final res = e.response;
    throw Exception(res?.data);
  }

  group('Initiate Issuence & Create Did Authentication Proof', () {
    dynamic body = {
      "did": 'did:key:z6MkqDkpUZMebGpkn6YE6XmFWodMKWeBKurWPMJqndgTrEpz',
      "options": {
        "verificationMethod": 'did:key:z6MkqDkpUZMebGpkn6YE6XmFWodMKWeBKurWPMJqndgTrEpz#z6MkqDkpUZMebGpkn6YE6XmFWodMKWeBKurWPMJqndgTrEpz',
        "proofPurpose": "authentication",
        "challenge": 'ddd41098-17b3-4a14-a644-7854ff373084',
      },
    };

    String exchangeURL = 'https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/test';

    test(
      'Initiate Issuance',
      () async {
        try {
          final client = ApiManagerService(TestRestClient().dio);
          dynamic result = await client.initiateIssuance(exchangeURL: exchangeURL);

          expect(result['vpRequest']['challenge'].runtimeType, String);

          expect(result['vpRequest']['interact']['service'][0]['serviceEndpoint'].runtimeType, String);

          expect(result['processingInProgress'].runtimeType, bool);

          body['options']['challenge'] = result['vpRequest']['challenge'];
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );

    test(
      'Create Did Authentication Proof',
      () async {
        try {
          final client = ApiManagerService(TestRestClient().dio);
          dynamic result = await client.createDidAuthenticationProof(body: body);

          expect(result['@context'].runtimeType, List<dynamic>);
          expect(result['type'].runtimeType, String);
          expect(result['proof']['type'].runtimeType, String);
          expect(result['proof']['proofPurpose'].runtimeType, String);
          expect(result['proof']['challenge'].runtimeType, String);
          expect(result['proof']['verificationMethod'].runtimeType, String);
          expect(result['proof']['verificationMethod'].substring(0, 7), 'did:key');
          expect(result['proof']['created'].runtimeType, String);
          expect(result['proof']['jws'].runtimeType, String);
          expect(result['holder'].runtimeType, String);
          expect(result['holder'].substring(0, 7), 'did:key');
        } on DioError catch (e) {
          handleError(e);
        }
      },
    );
  });
}
