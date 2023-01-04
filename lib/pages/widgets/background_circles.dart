import 'package:elia_ssi_wallet/pages/widgets/circle_painter.dart';
import 'package:flutter/material.dart';

class BackGroundCircles extends StatelessWidget {
  const BackGroundCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomPaint(
            painter: CirclePainter(),
            size: const Size(double.infinity, double.infinity),
          ),
        ),
        Expanded(
          child: CustomPaint(
            painter: CirclePainter(left: false),
            size: const Size(double.infinity, double.infinity),
          ),
        ),
      ],
    );
  }
}
