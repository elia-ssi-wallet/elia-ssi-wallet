import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

abstract class PlatformWidget<I extends Widget, A extends Widget> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return createMaterialWidget(context);
    }
    if (Platform.isAndroid || Platform.isFuchsia || Platform.isWindows) {
      return createMaterialWidget(context);
    } else if (Platform.isIOS || Platform.isMacOS || Platform.isLinux) {
      return createCupertinoWidget(context);
    }

    // Platform not supported returns an empty widget
    return const SizedBox(width: 0, height: 0);
  }

  I createCupertinoWidget(BuildContext context);

  A createMaterialWidget(BuildContext context);
}
