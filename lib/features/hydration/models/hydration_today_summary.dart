import 'package:equatable/equatable.dart';

class HydrationTodaySummary extends Equatable {
  final int totalMl;
  final int targetMl;

  const HydrationTodaySummary({required this.totalMl, required this.targetMl});

  double get progress {
    if (targetMl < 0) return 0;
    return totalMl / targetMl;
  }

  int get percentage {
    if (targetMl <= 0) return 0;
    return ((totalMl / targetMl) * 100).round();
  }

  int get remainingMl {
    final remaining = targetMl - totalMl;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isGoalReached {
    return totalMl >= targetMl;
  }

  @override
  List<Object?> get props => [totalMl, targetMl];
}
