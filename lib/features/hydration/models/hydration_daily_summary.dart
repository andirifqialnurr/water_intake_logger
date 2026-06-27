import 'package:equatable/equatable.dart';

class HydrationDailySummary extends Equatable {
  final DateTime date;
  final int totalMl;
  final int targetMl;

  const HydrationDailySummary({
    required this.date,
    required this.totalMl,
    required this.targetMl,
  });

  int get percentage {
    if (targetMl <= 0) return 0;
    return ((totalMl / targetMl) * 100).round();
  }

  bool get isAchieved => totalMl >= targetMl;

  String get totalLiterText => (totalMl / 1000).toStringAsFixed(1);
  String get targetLiterText => (targetMl / 1000).toStringAsFixed(1);

  @override
  List<Object?> get props => [date, totalMl, targetMl];
}
