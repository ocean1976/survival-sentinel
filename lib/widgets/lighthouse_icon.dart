import 'package:flutter/material.dart';

class LighthouseIcon extends StatelessWidget {
  final Color color;
  const LighthouseIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(32, 32),
      painter: _LighthousePainter(color),
    );
  }
}

class _LighthousePainter extends CustomPainter {
  final Color color;
  _LighthousePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const beam = Color(0xFFF8E58A);

    paint.color = beam;
    canvas.drawRect(Rect.fromLTWH(0, size.height / 2 - 1, 8, 2), paint);
    canvas.drawRect(Rect.fromLTWH(2, size.height / 2 - 8, 6, 2), paint);
    canvas.drawRect(Rect.fromLTWH(2, size.height / 2 + 6, 6, 2), paint);
    canvas.drawRect(
        Rect.fromLTWH(size.width - 8, size.height / 2 - 1, 8, 2), paint);
    canvas.drawRect(
        Rect.fromLTWH(size.width - 8, size.height / 2 - 8, 6, 2), paint);
    canvas.drawRect(
        Rect.fromLTWH(size.width - 8, size.height / 2 + 6, 6, 2), paint);

    paint.color = color;
    final path = Path()
      ..moveTo(size.width / 2 - 4, size.height - 5)
      ..lineTo(size.width / 2 - 3, size.height / 2 + 5)
      ..lineTo(size.width / 2 + 3, size.height / 2 + 5)
      ..lineTo(size.width / 2 + 4, size.height - 5)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 4, size.height / 2, 8, 6),
      paint,
    );

    paint.color = beam;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2 + 3), 3, paint);
  }

  @override
  bool shouldRepaint(covariant _LighthousePainter oldDelegate) =>
      oldDelegate.color != color;
}
