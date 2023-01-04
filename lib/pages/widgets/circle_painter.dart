import 'package:elia_ssi_wallet/base/colors/colors.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({this.circles = 8, this.distance = 25.0, this.left = true});

  final int circles;
  final double distance;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey1
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= circles; i++) {
      canvas.drawCircle(left ? const Offset(70, 60) : Offset(size.width - 70, size.height - 60), (i * distance) - 14, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
