import 'package:elia_ssi_wallet/pages/did/did_token_screen.dart';
import 'package:elia_ssi_wallet/pages/home/home_screen_viewmodel.dart';
import 'package:elia_ssi_wallet/pages/widgets/contract_list_widget.dart';
import 'package:elia_ssi_wallet/pages/widgets/scan_qr_code_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return DidTokenScreen();
                        },
                      );
                    },
                    child: const Text(
                      'My DID Data',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Hi Cas',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Observer(
                  builder: (_) => SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl(
                      groupValue: viewModel.index,
                      children: const {
                        0: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'External',
                          ),
                        ),
                        1: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Self Signed'),
                        ),
                      },
                      onValueChanged: (value) => viewModel.index = value as int,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Below you can find your linked contracts.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    shrinkWrap: true,
                    itemCount: viewModel.linkedContracts.length + 1,
                    itemBuilder: (context, index) => Material(
                      child: index < viewModel.linkedContracts.length
                          ? ContractListWidget(
                              contract: viewModel.linkedContracts[index],
                            )
                          : const ScanQrCodeButton(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
