import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/badge_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class SummaryProgressCard extends StatelessWidget {
  const SummaryProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
