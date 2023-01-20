import 'package:elia_ssi_wallet/base/platform_widgets/platform_widgets.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/pending_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/pending_screen/widgets/pending_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PendingScreen extends StatelessWidget {
  PendingScreen({super.key});

  final PendingScreenViewModel viewModel = PendingScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      navigationBar: PlatformAppBar(
        title: const Text("Pending requests"),
      ),
      child: Observer(builder: (_) {
        return Visibility(
          visible: viewModel.pendingRequests.value?.isNotEmpty == true,
          replacement: const Center(
            child: Text("No pending requests"),
          ),
          child: ListView.builder(
            itemBuilder: ((context, index) {
              var value = viewModel.pendingRequests.value?[index];
              return PendingItem(pendingRequest: value!);
            }),
            itemCount: viewModel.pendingRequests.value?.length ?? 0,
          ),
        );
      }),
    );
  }
}
