import 'dart:math';

import 'package:flutter/material.dart';

class RotatingRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  const RotatingRingPainter({required this.color, required this.progress});

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

    // final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokeWidth;

    final ringRect = Rect.fromCircle(center: center, radius: radius);

    _drawGradientArc(
      canvas,
      ringRect,
      startAngle: startAngle,
      sweepAngle: visibleArcLength,
      strokeWidth: strokeWidth,
    );
  }

  void _drawGradientArc(
    Canvas canvas,
    Rect rect, {
    required double startAngle,
    required double sweepAngle,
    required double strokeWidth,
  }) {
    const segments = 48;
    final segmentSweep = sweepAngle / segments;

    for (var i = 0; i < segments; i++) {
      final t = (i + 1) / segments;
      final alpha = 0.95 * Curves.easeIn.transform(t);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = i == segments - 1 ? StrokeCap.round : StrokeCap.butt
        ..isAntiAlias = true
        ..color = color.withValues(alpha: alpha);

      canvas.drawArc(
        rect,
        startAngle + (segmentSweep * i),
        segmentSweep * 1.08,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RotatingRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
