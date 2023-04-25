import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contract_item.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contracts_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class CompatibleContractsScreen extends StatefulWidget {
  const CompatibleContractsScreen({
    Key? key,
    required this.types,
    required this.vCsList,
  }) : super(key: key);

  final List<String> types;
  final List<dynamic> vCsList;

  @override
  State<CompatibleContractsScreen> createState() => _CompatibleContractsScreenState();
}

class _CompatibleContractsScreenState extends State<CompatibleContractsScreen> {
  late final CompatibleContractsScreenViewModel viewModel = CompatibleContractsScreenViewModel(types: widget.types);

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
                    context.router.popUntilRouteWithName(HomeScreenRoute.name);
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
                  backgroundColor: viewModel.selectedBoolList.any((element) => element == true) ? AppColors.dark : AppColors.dark.withOpacity(0.4),
                  onPressed: viewModel.selectedBoolList.any((element) => element == true)
                      ? () async {
                          widget.vCsList.addAll(viewModel.vCs.where((vc) => viewModel.selectedBoolList[viewModel.vCs.indexOf(vc)]).map((e) => jsonDecode(e.vc)).toList());
                          context.router.pop();
                        }
                      : null,
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
                                    S.of(context).requirement(widget.types.stringListToCsvStyle()),
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
                                          expanded: viewModel.expanedBoolList[index],
                                          selected: viewModel.selectedBoolList[index],
                                          vc: viewModel.vCs[index],
                                          toggleSelected: (newValue) {
                                            setState(() {
                                              viewModel.selectedBoolList[index] = newValue;
                                            });
                                          },
                                          toggleExpanded: (newValue) {
                                            setState(() {
                                              viewModel.expanedBoolList[index] = newValue;
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
                                          S.of(context).you_have_no_contracts(widget.types.stringListToCsvStyle()),
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
