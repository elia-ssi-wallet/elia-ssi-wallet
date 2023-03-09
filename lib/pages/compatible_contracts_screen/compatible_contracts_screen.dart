// ignore_for_file: use_build_context_synchronously

import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/models/did/did_token.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contract_item.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contracts_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:elia_ssi_wallet/repositories/consent_repository.dart';
import 'package:elia_ssi_wallet/repositories/did_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class CompatibleContractsScreen extends StatefulWidget {
  const CompatibleContractsScreen({
    Key? key,
    required this.type,
    required this.exchangeId,
  }) : super(key: key);

  final String type;
  final String exchangeId;

  @override
  State<CompatibleContractsScreen> createState() => _CompatibleContractsScreenState();
}

class _CompatibleContractsScreenState extends State<CompatibleContractsScreen> {
  late final CompatibleContractsScreenViewModel viewModel = CompatibleContractsScreenViewModel(type: widget.type);

  final SliverOverlapAbsorberHandle sliverOverlapAbsorberHandle = SliverOverlapAbsorberHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'confirmScreen1',
                  backgroundColor: AppColors.dark,
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.popUntil(context, (route) => route.settings.name == Routes.home);
                    // ExchangeRepository.pendingRequestDao.deletePendingRequest(vp: vp);
                  },
                  label: Center(
                    child: Text(
                      S.of(context).reject,
                      textAlign: TextAlign.center,
                      style: AppStyles.button.copyWith(color: AppColors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'confirmScreen2',
                  backgroundColor: AppColors.dark,
                  onPressed: () async {
                    Navigator.of(context).pushNamed(Routes.acceptTermsAndConditions);
                    await ConsentRepository().initiateIssuance(
                      endpoint: 'https://vc-api-dev.energyweb.org/v1/vc-api/exchanges/${widget.exchangeId}',
                      onError: (e) {
                        Logger().e(e);
                      },
                      onSuccess: (result) async {
                        await ConsentRepository().convertInputToCredential(
                          inputDescriptor: {
                            'constraints': result['vpRequest']['query'][0]['credentialQuery'][0]['presentationDefinition']['input_descriptors'][0]['constraints'],
                          },
                          onSuccess: (result2) async {
                            DIDToken? didToken = await DIDRepository.getDidTokenFromSecureStorage();
                            if (didToken != null) {
                              await ConsentRepository().issueSelfSignedCredential(
                                credential: {
                                  'credential': {
                                    'id': result2['credential']['id'],
                                    '@context': result2['credential']['@context'],
                                    'credentialSubject': {
                                      'consent': result2['credential']['credentialSubject']['consent'],
                                      'id': didToken.id,
                                    },
                                    'type': result2['credential']['type'],
                                    'issuer': didToken.id,
                                    'issuanceDate': '${DateTime.now().toIso8601String()}Z',
                                  },
                                },
                                onSuccess: (result3) async {
                                  await ConsentRepository().createPresentation(
                                    presentation: {
                                      'presentation': {
                                        '@context': [
                                          'https://www.w3.org/2018/credentials/v1',
                                          'https://www.w3.org/2018/credentials/examples/v1',
                                        ],
                                        'type': ['VerifiablePresentation'],
                                        'verifiableCredential': [result3],
                                        'holder': didToken.id,
                                      },
                                      "options": {
                                        "verificationMethod": didToken.verificationMethod.first.id,
                                        "proofPurpose": "authentication",
                                        "challenge": result['vpRequest']['challenge'],
                                      },
                                    },
                                    onSuccess: (result4) async {
                                      await ConsentRepository().submitExchange(
                                        endpoint: result['vpRequest']['interact']['service'][0]['serviceEndpoint'],
                                        presentationWithCredential: result4,
                                        onSuccess: (result5) async {},
                                        onError: (e) {
                                          Logger().e(e);
                                        },
                                      );
                                    },
                                    onError: (e) {
                                      Logger().e(e);
                                    },
                                  );
                                },
                                onError: (e) {
                                  Logger().e(e);
                                },
                              );
                            }
                          },
                          onError: (e) {
                            Logger().e(e);
                          },
                        );
                      },
                    );
                  },
                  label: Center(
                    child: Text(
                      S.of(context).next,
                      textAlign: TextAlign.center,
                      style: AppStyles.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            CustomPaint(
              painter: CirclePainter(left: false),
              size: const Size(double.infinity, double.infinity),
            ),
            CustomScrollView(
              slivers: [
                SliverOverlapAbsorber(
                  handle: sliverOverlapAbsorberHandle,
                  sliver: CupertinoSliverNavigationBar(
                    automaticallyImplyLeading: false,
                    largeTitle: Text(S.of(context).add_contract),
                    backgroundColor: Colors.white,
                    border: null,
                    trailing: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: SvgPicture.asset(
                          AppAssets.closeIcon,
                          color: AppColors.grey2,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverOverlapInjector(
                  handle: sliverOverlapAbsorberHandle,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).please_select_the_contract_from('APP'),
                            style: AppStyles.subtitle,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.dark,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(AppAssets.infoIcon),
                                  ),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Flexible(
                                  child: Text(
                                    S.of(context).requirement(widget.type),
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.grey2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            S.of(context).compatible_contracts,
                            style: AppStyles.title,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Observer(
                            builder: (_) => viewModel.vCs.isNotEmpty
                                ? SafeArea(
                                    top: false,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: viewModel.vCs.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(bottom: 26.0),
                                        child: CompatibleContractItem(
                                          selected: viewModel.boolList[index],
                                          vC: viewModel.vCs[index],
                                          toggleSelected: () {
                                            setState(() {
                                              viewModel.boolList[index] = !viewModel.boolList[index];
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 80,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 94,
                                          width: 94,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.dark,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(Color.getAlphaFromOpacity(0.15), 33, 37, 42),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              AppAssets.noContractIcon,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        S.of(context).no_available_contracts,
                                        style: AppStyles.title,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: Text(
                                          S.of(context).you_have_no_contracts(widget.type),
                                          style: AppStyles.subtitle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
