class HydrationProfileSummary {
  final int lifetimeMl;
  final int currentStreakDays;
  final DateTime? lastDrinkAt;

  const HydrationProfileSummary({
    required this.lifetimeMl,
    required this.currentStreakDays,
    required this.lastDrinkAt,
  });

  String get lifetimeLiterText {
    return (lifetimeMl / 1000).toStringAsFixed(1);
  }
}
