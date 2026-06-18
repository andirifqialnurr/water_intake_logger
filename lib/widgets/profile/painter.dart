import 'dart:math';

import 'package:flutter/material.dart';

class RotatingRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;

    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth;

    final ringRect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          Colors.transparent,
          Colors.blueGrey.withValues(alpha: 0.12),
          Colors.blueGrey.withValues(alpha: 0.45),
          Colors.blueGrey.withValues(alpha: 0.95),
        ],
        stops: const [0.0, 0.45, 0.75, 1.0],
      ).createShader(rect);
    canvas.drawArc(ringRect, -pi / 2, pi * 1.45, false, paint);
  }

  @override
  bool shouldRepaint(covariant RotatingRingPainter oldDelegate) {
    return false;
  }
}
