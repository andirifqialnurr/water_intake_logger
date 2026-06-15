import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/sections.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
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
