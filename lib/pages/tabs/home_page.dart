import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/card.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/sections.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.inversePrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            TextWidget(
              text: "Good Morning, Aran",
              variant: TextWidgetStyle.body,
              color: AppColors.onSecondaryContainer,
            ),
            TextWidget(
              text: "Stay Hydrated",
              variant: TextWidgetStyle.headline,
            ),
            SizedBox(height: 30),
            CircleAvatar(
              radius: 150,
              child: CircleAvatar(
                radius: 140,
                backgroundColor: AppColors.outlineVariant,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(text: "75%", variant: TextWidgetStyle.display),
                    SizedBox(height: 8),
                    TextWidget(
                      text: "1500 / 2000ml",
                      variant: TextWidgetStyle.subtitle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
