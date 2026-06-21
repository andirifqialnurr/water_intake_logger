import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/sections.dart';
import 'package:water_intake_logger/widgets/inner_thumb_switch.dart';
import 'package:water_intake_logger/widgets/profile/animated_profile_avatar_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _avatarAnimationToken = 0;
  bool _modeSwitch = false;

  void _replayAvatarAnimation() {
    setState(() {
      _avatarAnimationToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: _replayAvatarAnimation,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  AnimatedProfileAvatarWidget(
                    animationToken: _avatarAnimationToken,
                  ),
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
                ],
              ),
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
              SizedBox(height: 30),
              TextWidget(text: "Setting", variant: TextWidgetStyle.subtitle),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.inverseOnSurface,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          _modeSwitch
                              ? Icons.wb_sunny_rounded
                              : Icons.dark_mode_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextWidget(
                            text: _modeSwitch ? "Bright Mode" : "Dark Mode",
                            variant: TextWidgetStyle.body,
                          ),
                        ),
                        InnerThumbSwitch(
                          value: _modeSwitch,
                          onChanged: (value) {
                            setState(() {
                              _modeSwitch = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
