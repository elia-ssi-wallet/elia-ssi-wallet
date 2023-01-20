import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

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
  int? pendingRequestId;

  @observable
  String status = 'status';

  Future<void> initiateIssuance({required String exchangeUrl, required context}) async {
    status = 'Initiating issuance';
    ExchangeRepository.initiateIssuance(
      exchangeURL: exchangeUrl,
      onSuccess: (vpRequest) async {
        status = 'Creating DID authentication proof';
        //todo: add DID check
        //* if true -> continue |
        //else -> status = 'Creating DID authentication proof failed';
        //error = true;
        await DIDRepository.initalCheckForDID();
        ExchangeRepository.createDidAuthenticationProof(
          baseUrl: exchangeUrl.getBaseUrlfromExchangeUrl(),
          challenge: vpRequest['vpRequest']['challenge'],
          onSuccess: (vp) async {
            pendingRequestId = await ExchangeRepository.pendingRequestDao.insertPendingRequests(
              serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
              vp: vp,
            );
            status = 'Submitting DID proof';
            periodicCall(
              serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
              vp: vp,
              context: context,
            );
          },
          onError: (_) {
            status = 'Creating DID authentication proof failed';
            error = true;
          },
        );
      },
      onError: (_) {
        status = 'Initiating issuance failed';
        error = true;
      },
    );
  }

  Future<void> periodicCall({required String serviceEndpoint, required dynamic vp, required context}) async {
    while (!exchangeCompleted) {
      await Future.delayed(
        Duration(seconds: attempts),
        () async {
          attempts++;
          //todo: add DID check
          await ExchangeRepository.continueExchangeBySubmittingDIDProof(
            serviceEndpoint: serviceEndpoint,
            vpRequest: vp,
            onSuccess: (response) async {
              if (response['processingInProgress'] == true) {
                status = 'Waiting for review: attempt $attempts';
                exchangeCompleted = false;
              } else {
                debugPrint('Exchange completed');
                if (pendingRequestId != null) {
                  ExchangeRepository.pendingRequestDao.updatePendingRequests(
                    id: pendingRequestId!,
                    vpVc: response['vp'],
                  );
                }
                exchangeCompleted = true;
                Navigator.of(context).pushNamed(Routes.confirmContract, arguments: response['vp']);
              }
            },
            onError: (_) {
              status = 'Submitting DID proof failed';
              error = true;
            },
          );
        },
      );
    }
  }
}
