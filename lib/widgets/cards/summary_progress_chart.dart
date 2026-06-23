import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/badges/badge_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class SummaryProgressCard extends StatelessWidget {
  const SummaryProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final languageController = LanguageScope.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
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
                      text: languageController.strings.labelAvg.toUpperCase(),
                      variant: TextWidgetStyle.caption,
                      color: colors.onPrimary,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "2.4 ",
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: languageController.strings.liter,
                            style: TextStyle(
                              color: colors.onPrimary,
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
                      text: languageController.strings.labelGoal.toUpperCase(),
                      variant: TextWidgetStyle.caption,
                      color: colors.onPrimary,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "85.8 ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: colors.onPrimary,
                            ),
                          ),
                          TextSpan(
                            text: "%",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: colors.onPrimary,
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
          Divider(color: colors.onPrimary.withValues(alpha: 0.25)),
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
                            text: "+ 12%  ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: colors.onPrimary,
                            ),
                          ),
                          TextSpan(
                            text: languageController.strings.lastWeek,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BadgeWidget(
                  text:
                      "${languageController.strings.streak} : 5 ${languageController.strings.day}",
                ),
              ),
            ],
          ),
          // Second Row
        ],
      ),
    );
  }
}
