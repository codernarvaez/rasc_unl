import 'package:flutter/material.dart';

class DiagonalBackgroundWhite extends StatelessWidget {
  const DiagonalBackgroundWhite({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 150,
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
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.1)
      ..lineTo(0, size.height * 1)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DiagonalPainter oldDelegate) => false;
}
