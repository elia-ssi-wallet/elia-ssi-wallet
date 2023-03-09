import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:flutter/material.dart';

import 'package:elia_ssi_wallet/generated/l10n.dart';

enum PendingState {
  pending,
  approved,
  declined;

  Widget label(context) {
    switch (this) {
      case PendingState.pending:
        return Text(
          S.of(context).pending,
          style: const TextStyle(color: AppColors.grey1),
        );
      case PendingState.approved:
        return Text(
          S.of(context).approved,
          style: const TextStyle(color: AppColors.green),
        );
      case PendingState.declined:
        return Text(
          S.of(context).declined,
          style: const TextStyle(color: AppColors.red),
        );
    }
  }
}

class PendingBadge extends StatelessWidget {
  const PendingBadge({
    Key? key,
    required this.state,
  }) : super(key: key);

  final PendingState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: AppColors.dark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: state.label(context),
    );
  }
}
