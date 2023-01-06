import 'package:elia_ssi_wallet/base/helpers/alert_dialog_helper.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/did/did_token_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/did/widgets/token_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DidTokenScreen extends StatelessWidget {
  DidTokenScreen({super.key});

  final DidTokenViewModel viewModel = DidTokenViewModel();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(S.of(context).my_did_date, style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.5,
        ),
        body: Observer(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(S.of(context).DID, style: AppStyles.title),
                  ),
                  TokenTextField(
                    text: viewModel.didToken?.id ?? "",
                    subtitle: S.of(context).did_info,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(S.of(context).did_controller_key, style: AppStyles.title),
                  ),
                  TokenTextField(
                    text: viewModel.didToken?.verificationMethod.first.controller ?? "",
                    subtitle: S.of(context).did_controller_key_info,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(S.of(context).signature_algorithm, style: AppStyles.title),
                  ),
                  TokenTextField(
                    text: viewModel.didToken?.verificationMethod.first.type ?? "",
                    subtitle: S.of(context).signature_algorithm_info,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(S.of(context).did_private_key, style: AppStyles.title),
                  ),
                  TokenTextField(
                    text: viewModel.didToken?.verificationMethod.first.publicKeyJwk.kid ?? "",
                    obscure: viewModel.obscure,
                    onTap: () {
                      if (viewModel.obscure) {
                        showPlatformAlertDialog(
                          title: S.of(context).show_private_key,
                          subtitle: S.of(context).show_private_key_extra,
                          isDismissable: true,
                          actions: [
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
                          ],
                        );
                      } else {
                        viewModel.obscure = !viewModel.obscure;
                      }
                    },
                    subtitle: S.of(context).did_private_key_info,
                  ),
                  // -----------------

                  // CupertinoButton(
                  //     child: const Text("create key"),
                  //     onPressed: () async {
                  //       await DIDRepository.createDID(onSuccess: (v) async {
                  //         await DIDRepository.exportKey(
                  //             didToken: v,
                  //             onSuccess: (_, __) {
                  //               print("exported");
                  //             });
                  //       });
                  //     }),
                  // CupertinoButton(
                  //     child: const Text("import key"),
                  //     onPressed: () async {
                  //       await DIDRepository.importKey(onSuccess: (val) async {
                  //         await DIDRepository.registerDID(keyId: val, onSuccess: (_) {});
                  //       });
                  //     }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
