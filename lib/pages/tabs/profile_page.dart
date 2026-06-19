import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/sections.dart';
import 'package:water_intake_logger/widgets/profile/animated_profile_avatar_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              const AnimatedProfileAvatarWidget(),
              SizedBox(height: 10),
              TextWidget(text: "Aran", variant: TextWidgetStyle.headline),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Lifetime:"),
                        TextSpan(
                          text: "1,248 Liters",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
