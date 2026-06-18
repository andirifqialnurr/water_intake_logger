import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/cards/summary_progress_chart.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/cover_widget.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Summary Section
            SizedBox(height: 20),
            SummaryProgressCard(),
            SizedBox(height: 30),
            BarChartProgressWidget(
              activeIndex: 3,
              maxMl: 3000,
              data: [
                WaterBarChartData(day: 'Mon', ml: 1800),
                WaterBarChartData(day: 'Tue', ml: 2200),
                WaterBarChartData(day: 'Wed', ml: 1600),
                WaterBarChartData(day: 'Thu', ml: 2500),
                WaterBarChartData(day: 'Fri', ml: 2100),
                WaterBarChartData(day: 'Sat', ml: 2800),
                WaterBarChartData(day: 'Sun', ml: 2400),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
