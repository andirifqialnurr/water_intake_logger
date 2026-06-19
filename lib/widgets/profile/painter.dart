import 'dart:math';

import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';

class RotatingRingPainter extends CustomPainter {
  final double progress;

  const RotatingRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;

    const badgeAngle = pi / 4;
    const maxArchLength = pi / 2;
    const fullTurn = 2 * pi;

    const appearEnd = 0.15;
    const sinkStart = 0.85;

    final p = progress.clamp(0.0, 1.0);

    double headAngle;
    double visibleArcLength;

    if (p < appearEnd) {
      final t = p / appearEnd;

      visibleArcLength = maxArchLength * t;
      headAngle = badgeAngle + visibleArcLength;
    } else if (p < sinkStart) {
      final t = (p - appearEnd) / (sinkStart - appearEnd);

      visibleArcLength = maxArchLength;
      headAngle = badgeAngle + maxArchLength + ((fullTurn - maxArchLength) * t);
    } else {
      final t = (p - sinkStart) / (1 - sinkStart);

      visibleArcLength = maxArchLength * (1 - t);
      headAngle = badgeAngle;
    }

    if (visibleArcLength <= 0) {
      return;
    }

    final startAngle = headAngle - visibleArcLength;

    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth;

    final ringRect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: headAngle,
        colors: [
          AppColors.primary.withValues(alpha: 0),
          AppColors.primary.withValues(alpha: 0.01),
          AppColors.primary.withValues(alpha: 0.45),
          AppColors.primary.withValues(alpha: 0.95),
        ],
        stops: const [0.0, 0.25, 0.75, 1.0],
      ).createShader(rect);

    canvas.drawArc(ringRect, startAngle, visibleArcLength, false, paint);
  }

  @override
  bool shouldRepaint(covariant RotatingRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
