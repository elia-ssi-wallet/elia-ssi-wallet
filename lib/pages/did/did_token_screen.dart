import 'package:elia_ssi_wallet/base/helpers/alert_dialog_helper.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/did/did_token_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/did/widgets/token_textfield.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DidTokenScreen extends StatelessWidget {
  DidTokenScreen({super.key});

  final DidTokenViewModel viewModel = DidTokenViewModel();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: TextButton(
                onPressed: () async {
                  await DIDRepository.createAndRegisterNewDID();
                },
                child: const Text('Create DID'),
              ),
            ),
            Text(S.of(context).DID),
            TokenTextField(text: viewModel.didToken?.id ?? ""),
            Text(S.of(context).did_controller_key),
            TokenTextField(text: viewModel.didToken?.verificationMethod.first.controller ?? ""),
            Text(S.of(context).signature_algorithm),
            TokenTextField(text: viewModel.didToken?.verificationMethod.first.type ?? ""),
            Text(S.of(context).did_private_key),
            TokenTextField(
              text: viewModel.didToken?.verificationMethod.first.publicKeyJwk.kid ?? "",
              obscure: viewModel.obscure,
              onTap: () {
                if (viewModel.obscure) {
                  showPlatformAlertDialog(title: S.of(context).show_private_key, subtitle: S.of(context).show_private_key_extra, isDismissable: true, actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    MaterialButton(
                      onPressed: () {
                        viewModel.obscure = !viewModel.obscure;
                        Navigator.of(context).pop();
                      },
                      child: Text(S.of(context).show),
                    ),
                  ]);
                } else {
                  viewModel.obscure = !viewModel.obscure;
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
