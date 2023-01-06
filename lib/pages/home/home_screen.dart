import 'package:elia_ssi_wallet/base/assets/assets.dart';
import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/base/router/routes.dart';
import 'package:elia_ssi_wallet/base/text_styles/app_text_styles.dart';
import 'package:elia_ssi_wallet/generated/l10n.dart';
import 'package:elia_ssi_wallet/pages/did/did_token_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/home/widgets/vc_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  final SliverOverlapAbsorberHandle appbarHandle = SliverOverlapAbsorberHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.dark,
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.qr);
              },
              label: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppAssets.scanIcon),
                      const SizedBox(width: 10.0),
                      Text(
                        S.of(context).add_contract,
                        textAlign: TextAlign.center,
                        style: AppStyles.button.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverOverlapAbsorber(
            handle: appbarHandle,
            sliver: CupertinoSliverNavigationBar(
              automaticallyImplyLeading: false,
              largeTitle: Text(S.of(context).hello_name("Elia")),
              trailing: CupertinoButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return DidTokenScreen();
                    },
                  );
                },
                padding: EdgeInsets.zero,
                child: Text(
                  S.of(context).my_did_date,
                  style: AppStyles.title,
                ),
              ),
            ),
          ),
          SliverOverlapInjector(handle: appbarHandle),
          Observer(
            builder: (_) => Visibility(
              visible: viewModel.vCsStream.value?.isNotEmpty ?? false,
              replacement: const SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No items in the list",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              child: Observer(
                builder: (_) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => VcItem(
                      vc: viewModel.vCsStream.value![index],
                    ),
                    childCount: viewModel.vCsStream.value?.length ?? 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
