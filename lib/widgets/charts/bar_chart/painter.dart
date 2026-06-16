import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/cover_widget.dart';

class WaterIntakeBarChartPainter extends CustomPainter {
  final List<WaterBarChartData> data;
  final double maxMl;

  WaterIntakeBarChartPainter({required this.data, required this.maxMl});

  @override
  void paint(Canvas canvas, Size size) {
    final chartLeft = 44.0;
    final chartTop = 12.0;
    final chartRight = size.width;
    final chartBottom = size.height - 4;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;
  }

  void _drawText(
    Canvas canvas, {
    required String text,
    required Offset offset,
    required TextStyle style,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant WaterIntakeBarChartPainter oldDeletage) {
    return oldDeletage.data != data || oldDeletage.maxMl != maxMl;
  }
}
