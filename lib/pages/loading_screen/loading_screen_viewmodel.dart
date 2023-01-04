import 'package:elia_ssi_wallet/base/router/routes.dart';
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
  String status = 'status';

  Future<void> initiateIssuance({required String serviceEndpoint, required context}) async {
    status = 'Initiating issuance';
    ExchangeRepository.initiateIssuance(
      exchangeURL: serviceEndpoint,
      onSuccess: (vpRequest) {
        status = 'Creating DID authentication proof';
        ExchangeRepository.createDidAuthenticationProof(
          challenge: vpRequest['vpRequest']['challenge'],
          onSuccess: (vp) {
            status = 'Submitting DID proof';
            periodicCall(
              serviceEndpoint: vpRequest['vpRequest']['interact']['service'][0]['serviceEndpoint'],
              vp: vp,
              context: context,
            );
          },
          onError: (_) {
            status = 'Creating DID authentication proof failed';
          },
        );
      },
      onError: (_) {
        status = 'Initiating issuance failed';
      },
    );
  }

  Future<void> periodicCall({required String serviceEndpoint, required dynamic vp, required context}) async {
    while (!exchangeCompleted) {
      await Future.delayed(
        Duration(seconds: attempts),
        () async {
          attempts++;
          await ExchangeRepository.continueExchangeBySubmittingDIDProof(
            serviceEndpoint: serviceEndpoint,
            vpRequest: vp,
            onSuccess: (response) async {
              if (response['processingInProgress'] == true) {
                status = 'Waiting for review: attempt $attempts';
                exchangeCompleted = false;
              } else {
                print('Exchange completed');
                exchangeCompleted = true;
                Navigator.of(context).pushNamed(Routes.confirmContract, arguments: response['vp']);
              }
            },
            onError: (_) {
              status = 'Submitting DID proof failed';
              // exchangeCompleted = false;
            },
          );
        },
      );
    }
  }
}
