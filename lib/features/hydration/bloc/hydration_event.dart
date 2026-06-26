import 'package:equatable/equatable.dart';

sealed class HydrationEvent extends Equatable {
  const HydrationEvent();

  @override
  List<Object?> get props => [];
}

final class HydrationStarted extends HydrationEvent {
  const HydrationStarted();
}

final class HydrationWaterAdded extends HydrationEvent {
  final int amountMl;
  final String sourceType;
  final String sourceLabel;

  const HydrationWaterAdded({
    required this.amountMl,
    required this.sourceType,
    required this.sourceLabel,
  });

  @override
  List<Object?> get props => [amountMl, sourceType, sourceLabel];
}

final class HydrationGoalChanged extends HydrationEvent {
  final int targetMl;

  const HydrationGoalChanged({required this.targetMl});

  @override
  List<Object?> get props => [targetMl];
}
