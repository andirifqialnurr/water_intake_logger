import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';

class HistoryCardWidget extends StatelessWidget {
  final bool isAchieved;
  final String date;
  final String goal;
  final String achieved;

  const HistoryCardWidget({
    required this.date,
    required this.goal,
    required this.achieved,
    required this.isAchieved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final languageController = LanguageScope.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: colors.surface,
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 5, offset: Offset(1, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isAchieved
              ? Container(
                  decoration: BoxDecoration(
                    color: colors.primarySoft,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(14),
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: colors.primary,
                    size: 24,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(14),
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: colors.outline,
                    size: 24,
                  ),
                ),
          SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colors.onSurface,
                ),
              ),
              Text(
                "${languageController.strings.dailyGOalCard}: $goal L",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$achieved L",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isAchieved ? colors.primary : colors.onSurface,
                  ),
                ),
                isAchieved
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.verified, size: 14, color: colors.success),
                          SizedBox(width: 4),
                          Text(
                            languageController.strings.achieve.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: colors.success,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "72% ${languageController.strings.notAchieve.toUpperCase()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: colors.onSurfaceMuted,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
