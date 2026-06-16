import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/cover_widget.dart';

class WaterIntakeBarChartPainter extends CustomPainter {
  final List<WaterBarChartData> data;
  final double maxMl;
  final TextStyle labelStyle;
  final int? activeIndex;

  WaterIntakeBarChartPainter({
    required this.data,
    required this.maxMl,
    required this.labelStyle,
    this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // position
    final chartLeft = 44.0;
    final chartTop = 12.0;
    final chartRight = size.width;
    final chartBottom = size.height - 24;

    // width and height
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    // bar area
    final barAreaWidth = chartWidth / data.length;
    final barWidth = barAreaWidth * 0.82;

    // bar painters
    final gridPaint = Paint()
      ..color = AppColors.outline.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    final barBackgroundPaint = Paint()
      ..color = AppColors.error.withValues(alpha: 0.18);

    final barPaint = Paint()..color = AppColors.inversePrimary;
    final activeBarPaint = Paint()..color = AppColors.primary;

    // Grid horizontal + label Y
    final stepCount = 4;

    for (var i = 0; i <= stepCount; i++) {
      final step = maxMl / stepCount * i;
      final ratio = step / maxMl;
      final y = chartBottom - (chartHeight * ratio);

      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);

      _drawText(
        canvas,
        text: '${(step / 1000).toStringAsFixed(1)}L',
        // text: '${step.toInt()}ml',
        offset: Offset(0, y - 8),
        style: labelStyle,
      );
    }

    // Bars + label X
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final barCenterX = chartLeft + (barAreaWidth * i) + (barAreaWidth / 2);
      final barLeft = barCenterX - (barWidth / 2);
      final barRight = barCenterX + (barWidth / 2);
      final ratio = (item.ml / maxMl).clamp(0.0, 1.0);
      final barHeight = chartHeight * ratio;

      final isActive = i == activeIndex;

      final backgroundRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(barLeft, chartTop, barRight, chartBottom),
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      );

      final filledRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(barLeft, chartBottom - barHeight, barRight, chartBottom),
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      );

      canvas.drawRRect(backgroundRect, barBackgroundPaint);
      canvas.drawRRect(filledRect, isActive ? activeBarPaint : barPaint);

      _drawText(
        canvas,
        text: item.day,
        offset: Offset(barCenterX - 12, chartBottom + 10),
        style: labelStyle,
      );
    }
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
    return oldDeletage.data != data ||
        oldDeletage.maxMl != maxMl ||
        oldDeletage.activeIndex != activeIndex;
  }
}
