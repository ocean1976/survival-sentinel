import 'package:flutter/material.dart';

class CRTOverlay extends StatelessWidget {
  const CRTOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CRTPainter());
  }
}

class _CRTPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..color = const Color(0x1A000000);
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), linePaint);
    }
    final vignette = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: const [Colors.transparent, Color(0x66000000)],
        stops: const [0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
