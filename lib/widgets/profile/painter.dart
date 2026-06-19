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

    final headAngle = badgeAngle + (fullTurn * progress);

    double visibleArchLength;

    if (progress < 0.15) {
      visibleArchLength = maxArchLength * (progress / 0.15);
    } else if (progress > 0.85) {
      visibleArchLength = maxArchLength * ((1 - progress) / 0.15);
    } else {
      visibleArchLength = maxArchLength;
    }

    if (visibleArchLength <= 0) {
      return;
    }

    final startAngle = headAngle - visibleArchLength;

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
          AppColors.primary.withValues(alpha: 0.15),
          AppColors.primary.withValues(alpha: 0.65),
          AppColors.primary.withValues(alpha: 0.95),
        ],
        stops: const [0.0, 0.35, 0.75, 1.0],
      ).createShader(rect);

    canvas.drawArc(ringRect, startAngle, visibleArchLength, false, paint);
  }

  @override
  bool shouldRepaint(covariant RotatingRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
