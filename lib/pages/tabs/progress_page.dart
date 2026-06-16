import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/badge_widget.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/sections.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/cover_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Summary Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 26, horizontal: 30),
              child: Column(
                children: [
                  // First Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "Weekly Average".toUpperCase(),
                              variant: TextWidgetStyle.caption,
                              color: AppColors.neutral,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "2.4 ",
                                    style: TextStyle(
                                      color: AppColors.neutral,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Liters",
                                    style: TextStyle(
                                      color: AppColors.neutral,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: "Goal Met".toUpperCase(),
                              variant: TextWidgetStyle.caption,
                              color: AppColors.neutral,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "85.8 ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Divider(),
                  SizedBox(height: 10),
                  // Second Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "+ 12% ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " last week",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: BadgeWidget(text: "Streak : 5 Days")),
                    ],
                  ),
                  // Second Row
                ],
              ),
            ),
            SizedBox(height: 30),
            BarChartProgressWidget(
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
            DashboardSummarySections(
              items: [
                DashboardSummaryItems(
                  iconData: Icons.fireplace_outlined,
                  title: "3 Days",
                  caption: "Current Winstreak",
                ),
                DashboardSummaryItems(
                  iconData: Icons.timer,
                  title: "45 m",
                  caption: "Since Last Sip",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
