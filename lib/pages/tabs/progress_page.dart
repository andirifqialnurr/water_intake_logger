import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/widgets/cards/summary_progress_chart.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/cover_widget.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = LanguageScope.of(context);

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
                WaterBarChartData(
                  day: languageController.strings.monday,
                  ml: 1800,
                ),
                WaterBarChartData(
                  day: languageController.strings.tuesday,
                  ml: 2200,
                ),
                WaterBarChartData(
                  day: languageController.strings.wednesday,
                  ml: 1600,
                ),
                WaterBarChartData(
                  day: languageController.strings.thursday,
                  ml: 2500,
                ),
                WaterBarChartData(
                  day: languageController.strings.friday,
                  ml: 2100,
                ),
                WaterBarChartData(
                  day: languageController.strings.saturday,
                  ml: 2800,
                ),
                WaterBarChartData(
                  day: languageController.strings.sunday,
                  ml: 2400,
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
