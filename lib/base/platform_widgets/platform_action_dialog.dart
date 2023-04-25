import 'package:elia_ssi_wallet/base/get_it.dart';
import 'package:elia_ssi_wallet/base/navigation_service.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformActionDialog extends PlatformWidget<CupertinoActionSheet, Material> {
  final String? title;
  final String? message;
  final List<Widget?> actions;
  final List<Function()> functions;

  PlatformActionDialog({
    required this.title,
    this.message,
    required this.actions,
    required this.functions,
  });

  @override
  CupertinoActionSheet createCupertinoWidget(BuildContext context) => CupertinoActionSheet(
        title: Text(title ?? ""),
        actions: List.generate(
            actions.length,
            (index) => CupertinoActionSheetAction(
                  child: actions[index]!,
                  onPressed: () {
                    functions[index]();
                    locator.get<NavigationService>().router.pop();
                  },
                )),
        cancelButton: CupertinoButton(
            child: Text(S.current.cancel, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              locator.get<NavigationService>().router.pop();
            }),
      );

  @override
  Material createMaterialWidget(BuildContext context) => Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        child: BottomSheet(
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  // title
                  Text(
                    title ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Divider(height: 1),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                        title: actions[index]!,
                        onTap: () {
                          functions[index]();
                          locator.get<NavigationService>().router.pop();
                        },
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: actions.length,
                    ),
                  ),
                ],
              ),
            );
          },
          onClosing: () {},
        ),
      ));
}
