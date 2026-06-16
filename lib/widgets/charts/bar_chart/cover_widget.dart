import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/painter.dart';

class WaterBarChartData {
  final String day;
  final double ml;

  const WaterBarChartData({required this.day, required this.ml});
}

class BarChartProgressWidget extends StatelessWidget {
  final List<WaterBarChartData> data;
  final double maxMl;

  const BarChartProgressWidget({
    required this.data,
    required this.maxMl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomPaint(
        painter: WaterIntakeBarChartPainter(data: data, maxMl: maxMl),
      ),
    );
  }
}
