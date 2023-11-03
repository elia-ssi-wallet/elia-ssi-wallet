import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/repositories/consent_repository.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:elia_ssi_wallet/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:developer';
import 'dart:convert';

part 'loading_screen_viewmodel.g.dart';

class LoadingScreenViewModel extends _LoadingScreenViewModel with _$LoadingScreenViewModel {}

abstract class _LoadingScreenViewModel with Store {
  @observable
  int attempts = 0;

  @observable
  bool exchangeCompleted = false;

  @observable
  bool error = false;

  @observable
  bool transactionSuccesful = false;

  @observable
  bool goToPending = false;

  @observable
  int? pendingRequestId;

  @observable
  String status = 'status';

  @computed
  bool get showPending => attempts >= 4;

  late AnimationController animationController;

  Future<void> initiateIssuance({required String exchangeUrl}) async {
    status = 'Initiating issuance';
    ExchangeRepository.initiateIssuance(
      exchangeURL: exchangeUrl,
      onSuccess: (vpRequest) async {
        if (vpRequest['vpRequest']['query'][0]['type'] == 'DIDAuth') {
          continueWithDIDAuthProof(
            vpRequest: vpRequest,
            exchangeUrl: exchangeUrl,
          );
        } else if (vpRequest['vpRequest']['query'][0]['type'] == 'PresentationDefinition') {
          List<dynamic> vCs = [];
          for (var element in vpRequest['vpRequest']['query'][0]['credentialQuery'][0]['presentationDefinition']['input_descriptors']) {
            if (element['constraints']['subject_is_issuer'] != null && element['constraints']['subject_is_issuer'] == 'required') {
              String? termsAndConditions;
              try {
                var targetField = element['constraints']['fields'].firstWhere((field) => field['path'][0] == '\$.credentialSubject');
                var filter = targetField['filter'];
                var properties = filter['properties'];
                var agreesTo = properties['agreesTo'];
                var agreesToProperties = agreesTo['properties'];
                // Extract the properties
                String expressionOfTheOffer = "Expression of the offer : " + agreesToProperties['expressionOfTheOffer']['const'];
                String compensationOfTheOffer = "Compensation of the offer : " + agreesToProperties['compensationOfTheOffer']['const'];
                String jurisdiction = "Jurisdiction : " + agreesToProperties['jurisdiction']['const'];
                String applicationLaw = "Application law : " + agreesToProperties['applicationLaw']['const'];

                termsAndConditions = '$expressionOfTheOffer\n$compensationOfTheOffer\n$jurisdiction\n$applicationLaw';
              } catch (e) {
                Logger().e(e);
                status = 'Count not find terms and conditions';
                error = true;
              }

              if (termsAndConditions != null) {
                await locator.get<NavigationService>().router.push(ConsentScreenRoute(termsAndContitions: termsAndConditions));
                dynamic verifiableCredential = await consentToverifiableCredential(constraints: element['constraints']);
                if (verifiableCredential != null) {
                  vCs.add(verifiableCredential);
                }
              }
            } else {
              if (element['constraints']['fields'].any((field) => field['path'][0] == '\$.type')) {
                List<String> filterTypes = [];
                for (var type in element['constraints']['fields'].where((field) => field['path'][0] == '\$.type').toList()) {
                  filterTypes.add(type['filter']['contains']['const']);
                }

                await locator.get<NavigationService>().router.push(
                      CompatibleContractsScreenRoute(
                        types: filterTypes,
                        vCsList: vCs,
                      ),
                    );
              } else {
                status = 'No filter types found';
                error = true;
              }
            }
          }
          createAndSubmitPresentation(vpRequest: vpRequest, vCs: vCs, exchangeUrl: exchangeUrl);
        } else {
          status = 'Unsupported query type';
          error = true;
        }
      },
      onError: (e) {
        Logger().e(e);
        status = 'Initiating issuance failed';
        error = true;
      },
    );
  }

  Future<void> periodicCall({required String serviceEndpoint, required dynamic vp, Function()? insertVCs}) async {
    String exchangeId = serviceEndpoint.getExchangeIdFromExchangeUrl();
    try {
      await NotificationsRepository.addData(exchangeId: exchangeId);
    } catch (e) {
      Sentry.captureException(e);
    }

    while (!exchangeCompleted && !error && !goToPending) {
      await Future.delayed(
        Duration(seconds: attempts),
        () async {
          attempts++;
          //todo: add DID check
          await ExchangeRepository.submitPresentation(
            serviceEndpoint: serviceEndpoint,
            vpRequest: vp,
            onSuccess: (response) async {
              if (attempts == 1) {
                if (insertVCs != null) {
                  insertVCs();
                }
              }
              if (response['processingInProgress'] == true) {
                status = 'Waiting for review';

                exchangeCompleted = false;
              } else {
                debugPrint('Exchange completed');
                if (pendingRequestId != null) {
                  ExchangeRepository.pendingRequestDao.updatePendingRequests(
                    id: pendingRequestId!,
                    vp: response['vp'],
                  );
                  locator.get<NavigationService>().router.push(
                        ConfirmContractRoute(
                          pendingRequestId: pendingRequestId!,
                          vp: response['vp'],
                        ),
                      );
                }

                exchangeCompleted = true;
              }
            },
            onError: (_) {
              status = 'Submitting DID proof failed';
              error = true;
            },
            showDialogs: false,
          );
        },
      );
    }
  }

  Future<void> continueWithDIDAuthProof({required dynamic vpRequest, required String exchangeUrl}) async {
    await DIDRepository.initalCheckForDID();
    status = 'Creating DID authentication proof';
    ExchangeRepository.createDidAuthenticationProof(
      baseUrl: exchangeUrl.getBaseUrlfromExchangeUrl(),
      challenge: vpRequest['vpRequest']['challenge'],
      onSuccess: (vp) async {
        pendingRequestId = await ExchangeRepository.pendingRequestDao.insertPendingRequests(
          serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
          requestVp: vp,
        );
        status = 'Submitting DID proof';

        periodicCall(
          serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
          vp: vp,
        );
      },
      onError: (_) {
        status = 'Creating DID authentication proof failed';
        error = true;
      },
    );
  }

  void convertAdditionalProperties(dynamic obj) {
    if (obj is Map) {
      for (var key in obj.keys.toList()) {
        if (key == "additionalProperties" && obj[key] == true) {
          obj[key] = false;
        }
        convertAdditionalProperties(obj[key]);
      }
    } else if (obj is List) {
      for (var item in obj) {
        convertAdditionalProperties(item);
      }
    }
  }

  Future<dynamic> consentToverifiableCredential({required dynamic constraints}) async {
    status = 'Converting input descriptor to credential';
    dynamic result;

    convertAdditionalProperties(constraints);

    await ConsentRepository.convertInputToCredential(
      inputDescriptor: {
        'constraints': constraints,
      },
      onSuccess: (credential) async {
        await DIDRepository.initalCheckForDID();
        DIDToken? didToken = await DIDRepository.getDidTokenFromSecureStorage();

        if (didToken != null) {
          status = 'Issuing self signed credential';
          var payload = {
              'credential': {
                'issuer': didToken.id,
                'issuanceDate': '${DateTime.now().toIso8601String()}Z',
                'id': credential['credential']['id'],
                '@context': credential['credential']['@context'],
                'credentialSubject': {
                  ...credential['credential']['credentialSubject'], // Spread the existing content
                  'id': didToken?.id, // Inject the new id field
                },
                'type': credential['credential']['type']
              },
            };
          await ConsentRepository.issueSelfSignedCredential(
            credential: payload,
            onSuccess: (verifiableCredential) async {
              result = verifiableCredential;
            },
            onError: (e) {
              
              Logger().e(e);
              status = 'Issuing self signed credential failed';
              error = true;
            },
          );
        } else {
          status = 'No DID token found';
          error = true;
        }
      },
      onError: (e) {
        Logger().e(e);
        status = 'Converting input descriptor to credential failed';
        error = true;
      },
    );

    return result;
  }


  Future<void> createAndSubmitPresentation({required dynamic vpRequest, required List<dynamic> vCs, required String exchangeUrl}) async {
    await DIDRepository.initalCheckForDID();
    DIDToken? didToken = await DIDRepository.getDidTokenFromSecureStorage();
    if (didToken != null) {
      status = 'Creating presentation';
      await ExchangeRepository.createPresentation(
        presentation: {
          'presentation': {
            '@context': [
              'https://www.w3.org/2018/credentials/v1',
              'https://www.w3.org/2018/credentials/examples/v1',
            ],
            'type': ['VerifiablePresentation'],
            'verifiableCredential': vCs,
            'holder': didToken.id,
          },
          "options": {
            "verificationMethod": didToken.verificationMethod.first.id,
            "proofPurpose": "authentication",
            "challenge": vpRequest['vpRequest']['challenge'],
          },
        },
        onSuccess: (vp) async {
          if (vpRequest['vpRequest']['interact']['service'][0]['type'] == 'UnmediatedHttpPresentationService2021') {
            status = 'Submitting presentation';

            await ExchangeRepository.submitPresentation(
              serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
              vpRequest: vp,
              onSuccess: (result) async {
                await ExchangeRepository.dao.insertUniqueVCs(
                  vCsList: vCs,
                  exchangeBaseUrl: exchangeUrl.getBaseUrlfromExchangeUrl(),
                );
                animationController.forward();
                transactionSuccesful = true;
                status = 'Transaction successful';
              },
              onError: (e) {
                status = 'failed to submit presentation';
                error = true;
                Logger().e(e);
              },
            );
          } else if (vpRequest['vpRequest']['interact']['service'][0]['type'] == 'MediatedHttpPresentationService2021') {
            pendingRequestId = await ExchangeRepository.pendingRequestDao.insertPendingRequests(
              serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
              requestVp: vp,
            );
            periodicCall(
                serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
                vp: vp,
                insertVCs: () async {
                  await ExchangeRepository.dao.insertUniqueVCs(
                    vCsList: vCs,
                    exchangeBaseUrl: exchangeUrl.getBaseUrlfromExchangeUrl(),
                  );
                });
          } else {
            status = 'Unknown service type';
            error = true;
          }
        },
        onError: (e) {
          status = 'failed to create presentation';
          error = true;
          Logger().e(e);
        },
      );
    }
  }
}
