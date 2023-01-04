import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:elia_ssi_wallet/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class VCDetailScreen extends StatelessWidget {
  const VCDetailScreen({required this.vc, super.key});

  final VC vc;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 60.0),
              child: Text(
                vc.label,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.5,
        ),
        body: Observer(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contract info',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.grey1,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 10.0, bottom: 5),
                      child: Text(vc.toString()),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
