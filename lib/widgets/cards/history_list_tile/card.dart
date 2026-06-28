import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';

class HistoryCardWidget extends StatelessWidget {
  final bool isAchieved;
  final String date;
  final String goal;
  final String achieved;
  final bool isExceeded;
  final int percentage;

  const HistoryCardWidget({
    required this.date,
    required this.goal,
    required this.achieved,
    required this.isAchieved,
    required this.isExceeded,
    required this.percentage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final languageController = LanguageScope.of(context);

    final statusColor = isExceeded
        ? Colors.deepOrange
        : isAchieved
        ? colors.success
        : colors.onSurfaceMuted;

    final iconColors = isExceeded
        ? Colors.deepOrange
        : isAchieved
        ? colors.primary
        : colors.outline;

    final iconBackgroundColor = isExceeded
        ? Colors.deepOrange.withValues(alpha: 0.14)
        : isAchieved
        ? colors.primarySoft
        : colors.surfaceMuted;

    final statusIcon = isExceeded
        ? Icons.local_fire_department_rounded
        : Icons.verified;

    final statusText = isAchieved
        ? languageController.strings.achieve.toUpperCase()
        : "$percentage% ${languageController.strings.notAchieve.toUpperCase()}";

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
          Container(
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.all(14),
            child: Icon(
              isExceeded
                  ? Icons.local_fire_department_rounded
                  : Icons.water_drop_rounded,
              color: iconColors,
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
                    color: isAchieved ? iconColors : colors.onSurface,
                  ),
                ),
                isAchieved
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: statusColor,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        statusText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: statusColor,
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
