import 'dart:math';

import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';

class BadgeBurstPainter extends CustomPainter {
  final double progress;

  const BadgeBurstPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final center = size.center(Offset.zero);
    final radius = size.width * 0.38;

    final ringRect = Rect.fromCircle(center: center, radius: radius);

    final baseAngles = <double>[
      -0,
      2,
      pi / 4,
      pi / 1.8,
      pi,
      pi * 1.35,
      pi * 1.75,
    ];

    for (var i = 0; i < baseAngles.length; i++) {
      final delay = i * 0.055;
      final local = ((progress - delay) / 0.72).clamp(0.0, 1.0);

      if (local <= 0 || local >= 1) continue;

      final visibility = sin(local * pi);
      final travel = 0.45 * local;
      final headAngle = baseAngles[i] + travel;

      const trailCount = 4;
      const segmentSweep = pi / 28;

      for (var j = 0; j < trailCount; j++) {
        final trailFade = 1 - (j / trailCount);
        final alpha = 0.75 * visibility * trailFade;

        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = AppColors.primary.withValues(alpha: alpha);

        canvas.drawArc(
          ringRect,
          headAngle - (j * segmentSweep * 1.2),
          segmentSweep,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BadgeBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
