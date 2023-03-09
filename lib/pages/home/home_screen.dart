import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/did/did_token_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/empty_state_contracts%20copy.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/empty_state_pending_requests.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/new_contract_notification.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_item.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/widgets/pending_item.dart';
import 'package:elia_ssi_wallet/pages/widgets/background_circles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  final ScrollController scrollControllerExternalContracts = ScrollController();
  final ScrollController scrollControllerSelfSigned = ScrollController();
  final ScrollController scrollControllerPending = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.dark,
                onPressed: () async {
                  // Navigator.of(context).pushNamed(
                  //   Routes.compatibleContractsScreen,
                  //   arguments: {
                  //     'type': 'VerifiableCredential',
                  //     'exchangeId': 'test_consent_14',
                  //   },
                  // );
                  Navigator.of(context).pushNamed(Routes.qr).then(
                    (_) async {
                      final arguments = ModalRoute.of(context)?.settings.arguments;

                      if ((arguments as Map).isNotEmpty) {
                        VC? newVc = (arguments)["vc"];
                        if (newVc != null) {
                          await viewModel.updateNotification(vc: newVc);
                        }
                      } else {
                        Logger().d("jan: map empty");
                      }
                    },
                  );
                },
                label: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.scanIcon),
                        const SizedBox(width: 10.0),
                        Text(
                          S.of(context).add_contract,
                          textAlign: TextAlign.center,
                          style: AppStyles.button.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            const BackGroundCircles(),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CupertinoButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return DidTokenScreen();
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                        child: Text(
                          S.of(context).my_did_date,
                          style: AppStyles.title,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        S.of(context).hello_name("ELIA"),
                        style: AppStyles.largeTitle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: CupertinoSearchTextField(
                        controller: viewModel.searchController,
                        placeholder: S.of(context).search_contracts,
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: viewModel.showNotificationComputed
                            ? Align(
                                alignment: Alignment.center,
                                child: NewContractNotification(
                                  vc: viewModel.newlyAddedVC!,
                                ),
                              )
                            : const SizedBox.shrink(),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              alignment: Alignment.topCenter,
                              child: SizeTransition(
                                sizeFactor: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 30,
                                child: TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  labelStyle: AppStyles.tabbarTextStyle.copyWith(fontWeight: FontWeight.w600),
                                  unselectedLabelStyle: AppStyles.tabbarTextStyle,
                                  indicatorColor: AppColors.green,
                                  indicatorWeight: 4.0,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: [
                                    Tab(
                                      text: S.of(context).external_contracts,
                                    ),
                                    Tab(
                                      text: S.of(context).self_signed,
                                    ),
                                    Tab(
                                      text: S.of(context).pending,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Observer(
                                    builder: (_) => Visibility(
                                      visible: viewModel.vCsStream.value?.isNotEmpty == true,
                                      replacement: EmptyStateContracts(noVcs: viewModel.noVcs),
                                      child: Scrollbar(
                                        controller: scrollControllerExternalContracts,
                                        child: ListView.builder(
                                          controller: scrollControllerExternalContracts,
                                          itemCount: viewModel.vCsStream.value?.length ?? 0,
                                          padding: const EdgeInsets.only(bottom: 100),
                                          itemBuilder: (BuildContext context, int index) {
                                            if (viewModel.vCsStream.value?[index] != null) {
                                              return VcItem(vc: viewModel.vCsStream.value![index]);
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Observer(
                                    builder: (_) => Visibility(
                                      visible: viewModel.selfSignedVcStream.value?.isNotEmpty == true,
                                      replacement: EmptyStateContracts(noVcs: viewModel.noSelfSignedVcs),
                                      child: Scrollbar(
                                        controller: scrollControllerSelfSigned,
                                        child: ListView.builder(
                                          controller: scrollControllerSelfSigned,
                                          itemCount: viewModel.selfSignedVcStream.value?.length ?? 0,
                                          padding: const EdgeInsets.only(bottom: 100),
                                          itemBuilder: (BuildContext context, int index) {
                                            if (viewModel.selfSignedVcStream.value?[index] != null) {
                                              return VcItem(vc: viewModel.selfSignedVcStream.value![index]);
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Observer(
                                    builder: (_) => Visibility(
                                      visible: viewModel.pendingRequests.value?.isNotEmpty == true,
                                      replacement: const EmptyStatePendingRequests(),
                                      child: Scrollbar(
                                        controller: scrollControllerPending,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                              child: Text(
                                                S.of(context).pending_info,
                                                style: AppStyles.infoTextStyle,
                                              ),
                                            ),
                                            Flexible(
                                              child: ListView.builder(
                                                controller: scrollControllerPending,
                                                itemCount: viewModel.pendingRequests.value?.length ?? 0,
                                                padding: const EdgeInsets.only(bottom: 100),
                                                itemBuilder: (BuildContext context, int index) {
                                                  PendingRequest? pendingRequest = viewModel.pendingRequests.value?[index];
                                                  if (viewModel.pendingRequests.value?[index] != null) {
                                                    // return VcItem(vc: viewModel.pendingRequests.value![index]);
                                                    return PendingItem(pendingRequest: pendingRequest!);
                                                  } else {
                                                    return const SizedBox.shrink();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic testConsentRequest = {
    "exchangeId": "test_consent_11",
    "query": [
      {
        "type": "PresentationDefinition",
        "credentialQuery": [
          {
            "presentationDefinition": {
              "id": "286bc1e0-f1bd-488a-a873-8d71be3c690e",
              "input_descriptors": [
                {
                  "id": "consent_agreement",
                  "name": "Consent Agreement",
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
                              "additionalProperties": true,
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
                          "additionalProperties": true
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
                }
              ]
            }
          }
        ]
      }
    ],
    "interactServices": [
      {"type": "UnmediatedHttpPresentationService2021"}
    ],
    "callback": [
      {"url": "https://webhook.site/83213d5a-e1ab-46ad-b284-372dcae1e6a9"}
    ],
    "isOneTime": true
  };
}
