import 'package:equatable/equatable.dart';
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

  const HydrationSuccess({required this.summary});

  @override
  List<Object?> get props => [summary];
}

final class HydrationFailure extends HydrationState {
  final String message;

  const HydrationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
