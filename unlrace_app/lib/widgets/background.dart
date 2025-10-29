import 'package:flutter/material.dart';
import 'package:unl_race/global/global_var.dart';

class DiagonalBackground extends StatelessWidget {
  const DiagonalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 220,
        width: double.infinity,
        child: CustomPaint(
          painter: DiagonalPainter(),
        ),
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(0, size.height * 0.9)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DiagonalPainter oldDelegate) => false;
}
