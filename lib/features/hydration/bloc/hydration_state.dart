import 'package:equatable/equatable.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_daily_summary.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_entry_log.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_profile_summary.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_today_summary.dart';

sealed class HydrationState extends Equatable {
  const HydrationState();

  @override
  List<Object?> get props => [];
}

final class HydrationInitial extends HydrationState {
  const HydrationInitial();
}

final class HydrationLoading extends HydrationState {
  const HydrationLoading();
}

final class HydrationSuccess extends HydrationState {
  final HydrationTodaySummary summary;
  final List<HydrationDailySummary> history;
  final List<HydrationDailySummary> weeklyProgress;
  final HydrationProfileSummary profileSummary;
  final List<HydrationEntryLog> entryLogs;

  const HydrationSuccess({
    required this.summary,
    required this.history,
    required this.weeklyProgress,
    required this.profileSummary,
    required this.entryLogs,
  });

  @override
  List<Object?> get props => [
    summary,
    history,
    weeklyProgress,
    profileSummary,
    entryLogs,
  ];
}

final class HydrationFailure extends HydrationState {
  final String message;

  const HydrationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
