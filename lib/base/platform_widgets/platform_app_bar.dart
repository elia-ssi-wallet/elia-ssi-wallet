import 'package:elia_ssi_wallet/base/base_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

import 'platform_widget.dart';

class PlatformAppBar extends PlatformWidget<Widget, AppBar> with ObstructingPreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final String? previousPageTitle;
  final Color? backgroundColor;
  final bool showBorder;
  final IconThemeData? iconTheme;
  final bool canGoBack;
  final Brightness? brightness;
  final double? height;

  PlatformAppBar(
      {Key? key,
      this.leading,
      this.title,
      this.actions,
      this.previousPageTitle,
      this.backgroundColor,
      this.showBorder = false,
      this.iconTheme = const IconThemeData(color: Colors.white),
      this.brightness,
      this.canGoBack = true,
      this.height})
      : super();

  @override
  Widget createCupertinoWidget(BuildContext context) => CupertinoNavigationBar(
        border: showBorder ? const Border(bottom: BorderSide(width: 1, color: Colors.grey)) : null,
        backgroundColor: backgroundColor,
        previousPageTitle: previousPageTitle ?? S.of(context).back,
        leading: leading,
        automaticallyImplyLeading: canGoBack,
        middle: title,
        // padding: iconTheme == null ? const EdgeInsetsDirectional.only(start: 0) : const EdgeInsetsDirectional.only(start: 0),
        trailing: actions != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              )
            : null,
        brightness: brightness,
      );

  @override
  AppBar createMaterialWidget(BuildContext context) => AppBar(
        iconTheme: iconTheme,
        elevation: showBorder ? 2.0 : 0.0,
        backgroundColor: isWeb ? Colors.white : backgroundColor,
        leading: leading,
        title: title,
        actions: actions,

        automaticallyImplyLeading: canGoBack,
        toolbarHeight: height,
        // titleTextStyle: AppBarTheme.of(context).toolbarTextStyle?.copyWith(
        //     color:
        //         backgroundColor == Colors.white ? Colors.black : Colors.white),
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarBrightness: brightness,
        //   statusBarIconBrightness: brightness,
        //   systemNavigationBarIconBrightness: brightness,
        // ),
      );

  @override
  Size get preferredSize => Size.fromHeight(isIos ? kMinInteractiveDimensionCupertino : kToolbarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) => false;
}
