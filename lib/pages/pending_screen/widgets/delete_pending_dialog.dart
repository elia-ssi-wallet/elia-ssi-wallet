import 'package:elia_ssi_wallet/base/extensions/strings.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:elia_ssi_wallet/database/database.dart';

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
              Navigator.of(context).pop();
            }),
        CupertinoButton(
            child: const Text("YES"),
            onPressed: () async {
              await ExchangeRepository.pendingRequestDao.deletePendingRequestWithId(id: pendingRequest.id);
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
