import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DeletePendingDialog extends StatelessWidget {
  const DeletePendingDialog({
    Key? key,
    required this.pendingRequest,
  }) : super(key: key);

  final PendingRequest pendingRequest;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure you want to delete this pending request from ${pendingRequest.serviceEndpoint.prettifyDomain()}?"),
      actions: [
        CupertinoButton(
            child: const Text("NO"),
            onPressed: () {
              context.popRoute();
            }),
        CupertinoButton(
            child: const Text("YES"),
            onPressed: () async {
              await ExchangeRepository.pendingRequestDao.deletePendingRequestWithId(id: pendingRequest.id);
              // ignore: use_build_context_synchronously
              context.popRoute();
            })
      ],
    );
  }
}
