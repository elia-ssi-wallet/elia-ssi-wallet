import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/app_router.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/consent_screen/consent_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

@RoutePage()
class ConsentScreen extends StatelessWidget {
  ConsentScreen({Key? key, required this.termsAndContitions}) : super(key: key);

  final String termsAndContitions;

  final ConsentScreenViewModel viewModel = ConsentScreenViewModel();

  final SliverOverlapAbsorberHandle sliverOverlapAbsorberHandle = SliverOverlapAbsorberHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  heroTag: 'consentScreen1',
                  backgroundColor: AppColors.dark,
                  onPressed: () {
                    context.router.popUntilRouteWithName(HomeScreenRoute.name);
                  },
                  label: Center(
                    child: Text(
                      S.of(context).reject,
                      textAlign: TextAlign.center,
                      style: AppStyles.button.copyWith(color: AppColors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: Observer(
                  builder: (_) => FloatingActionButton.extended(
                    heroTag: 'consentScreen2',
                    backgroundColor: viewModel.accepted ? AppColors.dark : AppColors.dark.withOpacity(0.4),
                    onPressed: viewModel.accepted
                        ? () async {
                            context.router.pop();
                          }
                        : null,
                    label: Center(
                      child: Text(
                        S.of(context).next,
                        textAlign: TextAlign.center,
                        style: AppStyles.button,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: CirclePainter(left: false),
            size: const Size(double.infinity, double.infinity),
          ),
          CustomScrollView(
            slivers: [
              SliverOverlapAbsorber(
                handle: sliverOverlapAbsorberHandle,
                sliver: CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AutoSizeText(
                      S.of(context).accept_terms_and_conditions,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  border: null,
                ),
              ),
              SliverOverlapInjector(
                handle: sliverOverlapAbsorberHandle,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        termsAndContitions,
                        style: AppStyles.subtitle,
                      ),
                      const SizedBox(height: 20.0),
                      Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: Observer(
                          builder: (_) => SwitchListTile.adaptive(
                            value: viewModel.accepted,
                            contentPadding: const EdgeInsets.all(0),
                            activeColor: AppColors.green,
                            inactiveTrackColor: AppColors.grey3,
                            title: Text(
                              'I accept the terms and conditions',
                              style: AppStyles.boldText,
                            ),
                            onChanged: (val) {
                              viewModel.accepted = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70.0 + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
