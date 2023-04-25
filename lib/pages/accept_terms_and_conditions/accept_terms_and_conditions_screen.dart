import 'package:auto_route/auto_route.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/platform_widgets/platform_widgets.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/networking/do_call.dart';
import 'package:elia_ssi_wallet/pages/accept_terms_and_conditions/accept_terms_and_conditions_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/background_circles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_text/styled_text.dart';

@RoutePage()
class AcceptTermsAndConditions extends StatelessWidget {
  AcceptTermsAndConditions({Key? key, required this.onSuccess}) : super(key: key);

  final AcceptTermsAndConditionsViewModel viewModel = AcceptTermsAndConditionsViewModel();
  final Function(bool success) onSuccess;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      child: Stack(
        children: [
          const BackGroundCircles(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    S.of(context).accept_terms_and_conditions,
                    style: AppStyles.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    S.of(context).accept_terms_and_conditions_extra,
                    style: AppStyles.subtitle,
                  ),
                ),
                const SizedBox(height: 20.0),
                Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: Observer(
                    builder: (_) => SwitchListTile.adaptive(
                      value: viewModel.tos,
                      activeColor: AppColors.green,
                      inactiveTrackColor: AppColors.grey3,
                      title: StyledText(
                        text: S.of(context).read_and_accept_tos,
                        style: AppStyles.label,
                        textHeightBehavior: const TextHeightBehavior(),
                        tags: {
                          "link": StyledTextActionTag(
                            (text, attributes) {
                              //todo: go to TOS
                              showAlertDialog(title: S.of(context).app_name, message: "todo: go to Terms of Conditions");
                            },
                            style: AppStyles.label.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          )
                        },
                      ),
                      onChanged: (val) {
                        viewModel.tos = val;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Observer(
                      builder: (_) => Material(
                        color: Colors.transparent,
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(50.0),
                          onPressed: !viewModel.tos
                              ? null
                              : () async {
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  sharedPreferences.setBool("tos_accepted", true);
                                  onSuccess(true);
                                },
                          color: AppColors.dark,
                          disabledColor: AppColors.dark.withOpacity(0.4),
                          child: Text(
                            S.of(context).continu,
                            style: AppStyles.button,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
