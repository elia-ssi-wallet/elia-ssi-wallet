import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/pages/widgets/vc_detail_reader.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CompatibleContractItem extends StatelessWidget {
  const CompatibleContractItem({
    Key? key,
    required this.selected,
    required this.expanded,
    required this.vc,
    required this.toggleSelected,
    required this.toggleExpanded,
  }) : super(key: key);

  final bool selected;
  final bool expanded;
  final Function(bool?) toggleSelected;
  final Function(bool?) toggleExpanded;
  final VC vc;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: ExpandableController(initialExpanded: expanded),
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          useInkWell: false,
          crossFadePoint: 0,
        ),
        collapsed: GestureDetector(
          onTap: () {
            toggleExpanded(!expanded);
          },
          child: AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColors.grey1,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: expanded ? AppColors.grey3 : AppColors.grey1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      side: const BorderSide(color: AppColors.dark, width: 1.5),
                      checkColor: AppColors.green,
                      value: selected,
                      onChanged: toggleSelected,
                      activeColor: AppColors.dark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        vc.label,
                        style: AppStyles.title,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
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
            border: Border.all(color: expanded ? AppColors.grey3 : AppColors.grey1),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  toggleExpanded(!expanded);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            side: const BorderSide(color: AppColors.dark, width: 1.5),
                            checkColor: AppColors.green,
                            value: selected,
                            onChanged: toggleSelected,
                            activeColor: AppColors.dark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              vc.label,
                              style: AppStyles.title,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
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
                vc: jsonDecode(vc.vc),
                issuer: vc.issuer,
                issuanceDate: vc.issuanceDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
