import 'dart:math';

import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';

enum _BurstLineType { straight, curve, curl }

class _BurstLine {
  final double angle;
  final _BurstLineType type;
  final double length;
  final double delay;
  final double bend;
  final double strokeWidth;

  const _BurstLine({
    required this.angle,
    required this.type,
    required this.length,
    required this.delay,
    required this.bend,
    this.strokeWidth = 2.4,
  });
}

class BadgeBurstPainter extends CustomPainter {
  final double progress;

  const BadgeBurstPainter({required this.progress});

  // random lines a
  static const _lines = <_BurstLine>[
    _BurstLine(
      angle: pi / 4,
      type: _BurstLineType.curve,
      length: 18,
      delay: 0.00,
      bend: -8,
    ),
    _BurstLine(
      angle: 0,
      type: _BurstLineType.curl,
      length: 20,
      delay: 0.06,
      bend: 9,
    ),
    _BurstLine(
      angle: 3 * pi / 2,
      type: _BurstLineType.straight,
      length: 10,
      delay: 0.10,
      bend: 0,
      strokeWidth: 2.1,
    ),
    _BurstLine(
      angle: pi,
      type: _BurstLineType.curve,
      length: 17,
      delay: 0.14,
      bend: 7,
    ),
    _BurstLine(
      angle: 5 * pi / 4,
      type: _BurstLineType.curve,
      length: 14,
      delay: 0.18,
      bend: -6,
      strokeWidth: 2.0,
    ),
    _BurstLine(
      angle: 7 * pi / 4,
      type: _BurstLineType.curl,
      length: 16,
      delay: 0.22,
      bend: -8,
      strokeWidth: 2.0,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final center = size.center(Offset.zero);
    final startRadius = size.width * 0.34;

    for (final line in _lines) {
      final local = ((progress - line.delay) / 0.62).clamp(0.0, 1.0);

      if (local <= 0 || local >= 1) continue;

      _drawLine(
        canvas: canvas,
        center: center,
        startRadius: startRadius,
        line: line,
        local: local,
      );
    }
  }

  void _drawLine({
    required Canvas canvas,
    required Offset center,
    required double startRadius,
    required _BurstLine line,
    required double local,
  }) {
    final visibility = sin(local * pi);
    final grow = Curves.easeOutCubic.transform(local);
    final travel = 8 * grow;

    final direction = Offset(cos(line.angle), sin(line.angle));
    final normal = Offset(-direction.dy, direction.dx);

    final start = center + direction * (startRadius + travel);
    final end = center + direction * (startRadius + line.length + travel);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = line.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..color = AppColors.primary.withValues(alpha: 0.85 * visibility);

    switch (line.type) {
      case _BurstLineType.straight:
        canvas.drawLine(start, end, paint);
        break;
      case _BurstLineType.curve:
        final control =
            center +
            direction * (startRadius + (line.length * 0.55) + travel) +
            normal * line.bend;

        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

        _drawVisiblePath(canvas, path, paint, grow);
        break;

      case _BurstLineType.curl:
        final mid =
            center +
            direction * (startRadius + (line.length * 0.45) + travel) +
            normal * line.bend;
        final curlEnd = end - direction * 3 - normal * (line.bend * 0.65);

        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(mid.dx, mid.dy, curlEnd.dx, curlEnd.dy, end.dx, end.dy);

        _drawVisiblePath(canvas, path, paint, progress);
        break;
    }
  }

  void _drawVisiblePath(
    Canvas canvas,
    Path path,
    Paint paint,
    double progress,
  ) {
    for (final metric in path.computeMetrics()) {
      final visiblePath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(visiblePath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BadgeBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
