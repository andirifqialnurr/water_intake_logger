import 'package:flutter/material.dart';
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
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: CustomPaint(
        painter: WaterIntakeBarChartPainter(data: data, maxMl: maxMl),
      ),
    );
  }
}
