import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_daily_summary.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/widgets/cards/summary_progress_chart.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/cover_widget.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  String _dayLabel(BuildContext context, DateTime date) {
    final strings = LanguageScope.of(context).strings;

    switch (date.weekday) {
      case DateTime.monday:
        return strings.monday;
      case DateTime.tuesday:
        return strings.tuesday;
      case DateTime.wednesday:
        return strings.wednesday;
      case DateTime.thursday:
        return strings.thursday;
      case DateTime.friday:
        return strings.friday;
      case DateTime.saturday:
        return strings.saturday;
      case DateTime.sunday:
        return strings.sunday;
      default:
        return '';
    }
  }

  double _chartMaxMl(List<WaterBarChartData> data) {
    if (data.isEmpty) return 2000;

    final highestMl = data.fold<double>(0, (highest, item) {
      return item.ml > highest ? item.ml : highest;
    });

    if (highestMl <= 0) return 2000;

    const yAxisSectionCount = 4;
    const stepMultipleMl = 500.0;

    final rawStep = highestMl / yAxisSectionCount;
    final roundedStep = (rawStep / stepMultipleMl).ceil() * stepMultipleMl;

    return roundedStep * yAxisSectionCount;
  }

  List<HydrationDailySummary> _daysUntilToday(
    List<HydrationDailySummary> days,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return days.where((day) => !day.date.isAfter(today)).toList();
  }

  String _averageLiterText(List<HydrationDailySummary> days) {
    if (days.isEmpty) return '0.0';

    final totalMl = days.fold<int>(0, (total, day) => total + day.totalMl);

    return (totalMl / days.length / 1000).toStringAsFixed(1);
  }

  int _averageGoalPercentage(List<HydrationDailySummary> days) {
    if (days.isEmpty) return 0;

    final totalPercentage = days.fold<int>(
      0,
      (total, day) => total + day.percentage,
    );

    return (totalPercentage / days.length).round();
  }

  int _streakDays(List<HydrationDailySummary> days) {
    final sortedDays = [...days]..sort((a, b) => b.date.compareTo(a.date));

    var streak = 0;

    for (final day in sortedDays) {
      if (!day.isAchieved) break;
      streak++;
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HydrationBloc, HydrationState>(
        builder: (context, state) {
          if (state is HydrationLoading || state is HydrationInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HydrationFailure) {
            return Center(child: Text(state.message));
          }

          if (state is! HydrationSuccess) {
            return const SizedBox.shrink();
          }

          final daysUntilToday = _daysUntilToday(state.weeklyProgress);

          final chartData = state.weeklyProgress.map((day) {
            return WaterBarChartData(
              day: _dayLabel(context, day.date),
              ml: day.totalMl.toDouble(),
            );
          }).toList();

          return Center(
            child: Column(
              children: [
                // Summary Section
                SizedBox(height: 20),
                SummaryProgressCard(
                  averageLiter: _averageLiterText(daysUntilToday),
                  goalPercentage: _averageGoalPercentage(daysUntilToday),
                  streakDays: _streakDays(daysUntilToday),
                ),
                SizedBox(height: 30),
                BarChartProgressWidget(
                  data: chartData,
                  maxMl: _chartMaxMl(chartData),
                  activeIndex: DateTime.now().weekday - 1,
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
