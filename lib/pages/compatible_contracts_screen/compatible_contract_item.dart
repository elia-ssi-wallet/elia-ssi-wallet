import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/pages/compatible_contracts_screen/compatible_contract_item_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/vc_detail_reader.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CompatibleContractItem extends StatelessWidget {
  CompatibleContractItem({
    super.key,
    required this.selected,
    required this.vC,
    required this.toggleSelected,
  });

  final bool selected;
  final Function() toggleSelected;
  final VC vC;

  final CompatibleContractsItemViewModel viewModel = CompatibleContractsItemViewModel();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => ExpandableNotifier(
        controller: viewModel.expandableController,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            useInkWell: false,
            crossFadePoint: 0,
          ),
          collapsed: GestureDetector(
            onTap: () {
              viewModel.expandedBool = !viewModel.expandedBool;
              viewModel.expandableController.toggle();
            },
            child: AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: AppColors.grey1,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: viewModel.expandedBool ? AppColors.grey3 : AppColors.grey1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => toggleSelected(),
                        child: Checkbox(
                          side: const BorderSide(color: AppColors.dark, width: 1.5),
                          checkColor: AppColors.green,
                          value: selected,
                          onChanged: (value) => value != null ? toggleSelected() : null,
                          activeColor: AppColors.dark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          vC.label,
                          style: AppStyles.title,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      viewModel.expandedBool ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 26,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          expanded: AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColors.grey1,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: viewModel.expandedBool ? AppColors.grey3 : AppColors.grey1),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.expandedBool = !viewModel.expandedBool;
                    viewModel.expandableController.toggle();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => toggleSelected(),
                              child: Checkbox(
                                side: const BorderSide(color: AppColors.dark, width: 1.5),
                                checkColor: AppColors.green,
                                value: selected,
                                onChanged: (value) => value != null ? toggleSelected() : null,
                                activeColor: AppColors.dark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                vC.label,
                                style: AppStyles.title,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            viewModel.expandedBool ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            size: 26,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const DottedLine(
                  dashLength: 3,
                  dashGapLength: 2,
                  dashColor: AppColors.grey3,
                  dashRadius: 10,
                ),
                VcDetailReader(
                  vc: jsonDecode(vC.vc)[0],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
