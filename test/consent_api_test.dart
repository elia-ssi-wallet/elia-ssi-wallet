import 'package:dio/dio.dart';
import 'package:elia_ssi_wallet/networking/api_manager_service.dart';
import 'package:elia_ssi_wallet/networking/test_rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  handleError(DioError e) {
    final res = e.response;
    throw Exception(res?.data);
  }

  final client = ApiManagerService(TestRestClient().dio);
  const exchangeId = "test_consent_11";
  const baseUrl = "https://vc-api-dev.energyweb.org";
  String endpoint = "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/$exchangeId";
  String challenge = "";
  String continueExchangeEndpoint = "https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/$exchangeId/412d5932-df75-41c1-ab29-252c9fc62f6a";

  final inputDescriptor = {
    "constraints": {
      "subject_is_issuer": "required",
      "fields": [
        {
          "path": ["\$.id"],
          "filter": {"const": "urn:uuid:49f69fb8-f256-4b2e-b15d-c7ebec3a507e"}
        },
        {
          "path": ["\$.@context"],
          "filter": {
            "\$schema": "http://json-schema.org/draft-07/schema#",
            "type": "array",
            "items": [
              {"const": "https://www.w3.org/2018/credentials/v1"},
              {"\$ref": "#/definitions/eliaGroupContext"}
            ],
            "additionalItems": false,
            "minItems": 2,
            "maxItems": 2,
            "definitions": {
              "eliaGroupContext": {
                "type": "object",
                "properties": {
                  "elia": {"const": "https://www.eliagroup.eu/ld-context-2022#"},
                  "consent": {"const": "elia:consent"}
                },
                "additionalProperties": false,
                "required": ["elia", "consent"]
              }
            }
          }
        },
        {
          "path": ["\$.credentialSubject"],
          "filter": {
            "type": "object",
            "properties": {
              "consent": {"const": "I consent to such and such"}
            },
            "additionalProperties": false
          }
        },
        {
          "path": ["\$.type"],
          "filter": {
            "type": "array",
            "items": [
              {"const": "VerifiableCredential"}
            ]
          }
        }
      ]
    }
  };

  final credential = {
    "credential": {
      "id": "urn:uuid:49f69fb8-f256-4b2e-b15d-c7ebec3a507e",
      "@context": [
        "https://www.w3.org/2018/credentials/v1",
        {
          "elia": "https://www.eliagroup.eu/ld-context-2022#",
          "consent": "elia:consent",
        }
      ],
      "credentialSubject": {
        "consent": "I consent to such and such",
        "id": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
      },
      "type": ["VerifiableCredential"],
      "issuer": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
      "issuanceDate": "2023-01-19T14:56:18+00:00"
    }
  };

  final presentation = {
    "presentation": {
      "@context": ["https://www.w3.org/2018/credentials/v1", "https://www.w3.org/2018/credentials/examples/v1"],
      "type": ["VerifiablePresentation"],
      "verifiableCredential": [
        {
          "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {"consent": "elia:consent", "elia": "https://www.eliagroup.eu/ld-context-2022#"}
          ],
          "id": "urn:uuid:49f69fb8-f256-4b2e-b15d-c7ebec3a507e",
          "type": ["VerifiableCredential"],
          "credentialSubject": {"id": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7", "consent": "I consent to such and such"},
          "issuer": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
          "issuanceDate": "2023-01-19T13:18:39+00:00",
          "proof": {
            "type": "Ed25519Signature2018",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7#z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
            "created": "2023-01-19T13:18:40.525Z",
            "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..43ERQW6Ba6U61Ejb5bsnYKpWLzx739xK_7byUIL2HeC9o2TLwpIb2HFe3LCb0Eb2rJoxFD6hzeB30IgZdoetBg"
          }
        }
      ],
      "holder": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7"
    },
    "options": {
      "verificationMethod": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7#z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
      "proofPurpose": "authentication",
      "challenge": challenge,
    }
  };

  final presentationWithCredential = {
    "@context": ["https://www.w3.org/2018/credentials/v1", "https://www.w3.org/2018/credentials/examples/v1"],
    "type": ["VerifiablePresentation"],
    "verifiableCredential": [
      {
        "@context": [
          "https://www.w3.org/2018/credentials/v1",
          {"elia": "https://www.eliagroup.eu/ld-context-2022#", "consent": "elia:consent"}
        ],
        "id": "urn:uuid:49f69fb8-f256-4b2e-b15d-c7ebec3a507e",
        "type": ["VerifiableCredential"],
        "credentialSubject": {"id": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7", "consent": "I consent to such and such"},
        "issuer": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
        "issuanceDate": "2023-01-19T15:18:23+00:00",
        "proof": {
          "type": "Ed25519Signature2018",
          "proofPurpose": "assertionMethod",
          "verificationMethod": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7#z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
          "created": "2023-01-19T15:18:24.281Z",
          "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..wetCSvVUOuNHd9Quw88ShdZ1d7NVnMzmbY-cRqAndnQh9-R-9RavUXjxZLa_31DpRA9qYrRALhnSZbvXwibVAw"
        }
      }
    ],
    "proof": {
      "type": "Ed25519Signature2018",
      "proofPurpose": "authentication",
      "challenge": challenge,
      "verificationMethod": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7#z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7",
      "created": "2023-01-19T15:18:25.404Z",
      "jws": "eyJhbGciOiJFZERTQSIsImNyaXQiOlsiYjY0Il0sImI2NCI6ZmFsc2V9..dPRBj2PxXynhnEyJ24J_bx_TNHeIiGuKirhT0Ph7U64mIpbrKWhsTtX1hga1g2iTP9spf_cK_peCaTjHDGI6CQ"
    },
    "holder": "did:key:z6Mkuw1e3AUMnnVquUL1LGZHbPdoz7H7oGAWxJdG3Tar9UX7"
  };

  test(
    'Initiate Consent Issuance',
    () async {
      try {
        dynamic result = await client.initiateConsentIssuance(endpoint: endpoint);

        expect(result['vpRequest']['challenge'].runtimeType, String);
        challenge = result['vpRequest']['challenge'];
        expect(result['vpRequest']['query'].runtimeType, List);

        for (var query in result['vpRequest']['query']) {
          expect(query["type"].runtimeType, String);
          expect(query["credentialQuery"].runtimeType, List);
          for (var credentialQuery in query["credentialQuery"]) {
            expect(credentialQuery["presentationDefinition"].runtimeType, isNot(null));
            expect(credentialQuery["presentationDefinition"]["id"].runtimeType, String);
            expect(credentialQuery["presentationDefinition"]["id"].runtimeType, String);
            // expect(credentialQuery["presentationDefinition"].runtimeType, String);
          }
        }
        expect(result['vpRequest']['query'].runtimeType, List);

        expect(result['vpRequest']['interact']['service'][0]['serviceEndpoint'].runtimeType, String);
        continueExchangeEndpoint = result['vpRequest']['interact']['service'][0]['serviceEndpoint'];

        //check if exchangeId is the same
        Uri uri = Uri.parse(result['vpRequest']['interact']['service'][0]['serviceEndpoint'] as String);
        expect(uri.pathSegments[uri.pathSegments.length - 2], exchangeId);

        expect(result['processingInProgress'].runtimeType, bool);
      } on DioError catch (e) {
        handleError(e);
      }
    },
  );

  test(
    'Convert Input Descriptor To Credential',
    () async {
      try {
        String idcUrl = "https://inpdesc-to-cred-dev.energyweb.org";
        dynamic result = await client.convertInputDescriptorToCredential(idcUrl: idcUrl, inputDescriptor: inputDescriptor);
        expect(result["credential"]["id"].runtimeType, String);
        expect(result["credential"]["@context"].runtimeType, List);
        expect(result["credential"]["credentialSubject"].runtimeType, isNot(null));
        expect(result["credential"]["type"].runtimeType, List);
      } on DioError catch (e) {
        handleError(e);
      }
    },
  );

  test(
    'Issue a self-signed credential',
    () async {
      try {
        dynamic result = await client.issueSelfSignedContract(baseUrl: baseUrl, credential: credential);
        expect(result["id"].runtimeType, String);
        expect(result["@context"].runtimeType, List);
        expect(result["type"].runtimeType, List);
        expect(result["credentialSubject"]["id"].runtimeType, String);
        expect(result["issuer"].runtimeType, String);
        expect(result["issuanceDate"].runtimeType, String);
        expect(result["proof"].runtimeType, isNot(null));
      } on DioError catch (e) {
        handleError(e);
      }
    },
  );

  test(
    'Create a presentation with the self-signed credential',
    () async {
      try {
        dynamic result = await client.createPresentationWithSelfSignedCredential(baseUrl: baseUrl, presentation: presentation);

        expect(result["@context"].runtimeType, List);
        expect(result["type"].runtimeType, List);
        expect(result["verifiableCredential"].runtimeType, List);
        expect(result["proof"].runtimeType, isNot(null));
        expect(result["holder"].runtimeType, String);
      } on DioError catch (e) {
        handleError(e);
      }
    },
  );

  test(
    'Continue exchange by submitting',
    () async {
      try {
        dynamic result = await client.continueExchangeBySubmitting(endpoint: continueExchangeEndpoint, presentationWithCredential: presentationWithCredential);

        expect(result["errors"].runtimeType, List);
        expect((result["errors"] as List).isEmpty, true);
        expect(result["processingInProgress"].runtimeType, bool);
      } on DioError catch (e) {
        handleError(e);
      }
    },
  );
}
