import 'package:drift/drift.dart';
import 'package:water_intake_logger/data/local/app_database.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_daily_summary.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_profile_summary.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_today_summary.dart';

class HydrationRepository {
  final AppDatabase db;

  HydrationRepository(this.db);

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> addWater({
    required int amountMl,
    required String sourceType,
    required String sourceLabel,
    DateTime? consumeAt,
  }) async {
    final now = consumeAt ?? DateTime.now();

    await db
        .into(db.hydrationEntries)
        .insert(
          HydrationEntriesCompanion.insert(
            amountMl: amountMl,
            sourceType: sourceType,
            sourceLabel: sourceLabel,
            consumeAt: now,
            localDate: _dateKey(now),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> removeWater({
    required int amountMl,
    required String sourceType,
    required String sourceLabel,
    DateTime? consumeAt,
  }) async {
    final now = consumeAt ?? DateTime.now();
    final currentTotal = await getTotalMlByDate(now);
    final amountToRemove = amountMl > currentTotal ? currentTotal : amountMl;

    if (amountToRemove <= 0) return;

    await db
        .into(db.hydrationEntries)
        .insert(
          HydrationEntriesCompanion.insert(
            amountMl: -amountToRemove,
            sourceType: sourceType,
            sourceLabel: sourceLabel,
            consumeAt: now,
            localDate: _dateKey(now),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<int> getTotalMlByDate(DateTime date) async {
    final localDate = _dateKey(date);

    final rows =
        await (db.select(db.hydrationEntries)
              ..where((entry) => entry.localDate.equals(localDate))
              ..where((entry) => entry.deletedAt.isNull()))
            .get();
    final total = rows.fold<int>(0, (total, entry) => total + entry.amountMl);

    return total < 0 ? 0 : total;
  }

  Future<DailyGoal> getOrCreateGoalByDate(DateTime date) async {
    final localDate = _dateKey(date);
    final now = DateTime.now();

    final existing = await (db.select(
      db.dailyGoals,
    )..where((goal) => goal.localDate.equals(localDate))).getSingleOrNull();

    if (existing != null) return existing;

    final id = await db
        .into(db.dailyGoals)
        .insert(
          DailyGoalsCompanion.insert(
            localDate: localDate,
            createdAt: now,
            updatedAt: now,
          ),
        );

    return (db.select(
      db.dailyGoals,
    )..where((goal) => goal.id.equals(id))).getSingle();
  }

  Future<HydrationTodaySummary> getTodaySummary() async {
    final today = DateTime.now();

    final totalMl = await getTotalMlByDate(today);
    final goal = await getOrCreateGoalByDate(today);

    return HydrationTodaySummary(totalMl: totalMl, targetMl: goal.targetMl);
  }

  Future<void> setTodayGoal(int targetMl) async {
    final today = DateTime.now();
    final localDate = _dateKey(today);
    final now = DateTime.now();

    final existing = await (db.select(
      db.dailyGoals,
    )..where((goal) => goal.localDate.equals(localDate))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.dailyGoals)
          .insert(
            DailyGoalsCompanion.insert(
              localDate: localDate,
              targetMl: Value(targetMl),
              createdAt: now,
              updatedAt: now,
            ),
          );
      return;
    }

    await (db.update(
      db.dailyGoals,
    )..where((goal) => goal.id.equals(existing.id))).write(
      DailyGoalsCompanion(targetMl: Value(targetMl), updatedAt: Value(now)),
    );
  }

  Future<int> getTargetMlByDate(DateTime date) async {
    final localDate = _dateKey(date);

    final goal = await (db.select(
      db.dailyGoals,
    )..where((goal) => goal.localDate.equals(localDate))).getSingleOrNull();

    return goal?.targetMl ?? 2000;
  }

  Future<HydrationDailySummary> getDailySummaryByDate(DateTime date) async {
    final totalMl = await getTotalMlByDate(date);
    final targetMl = await getTargetMlByDate(date);

    return HydrationDailySummary(
      date: _dateOnly(date),
      totalMl: totalMl,
      targetMl: targetMl,
    );
  }

  Future<List<HydrationDailySummary>> getCurrentWeekSummaries() async {
    final today = _dateOnly(DateTime.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final summaries = <HydrationDailySummary>[];

    for (var i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      summaries.add(await getDailySummaryByDate(date));
    }

    return summaries;
  }

  Future<List<HydrationDailySummary>> getHistorySummaries({
    int days = 4,
  }) async {
    final today = _dateOnly(DateTime.now());
    final summaries = <HydrationDailySummary>[];

    for (var i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final summary = await getDailySummaryByDate(date);

      if (summary.totalMl > 0) {
        summaries.add(summary);
      }
    }

    return summaries;
  }

  Future<int> getLifetimeTotalMl() async {
    final rows = await (db.select(
      db.hydrationEntries,
    )..where((entry) => entry.deletedAt.isNull())).get();

    final total = rows.fold<int>(0, (total, entry) {
      return total + entry.amountMl;
    });

    return total < 0 ? 0 : total;
  }

  Future<DateTime?> getLastDrink() async {
    final rows =
        await (db.select(db.hydrationEntries)
              ..where((entry) => entry.deletedAt.isNull())
              ..where((entry) => entry.amountMl.isBiggerThanValue(0))
              ..orderBy([
                (entry) => OrderingTerm(
                  expression: entry.consumeAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .get();
    if (rows.isEmpty) return null;

    return rows.first.consumeAt;
  }

  Future<int> getCurrentStreakDays({int maxLookbackDays = 365}) async {
    final today = _dateOnly(DateTime.now());

    var streak = 0;

    for (var i = 0; i < maxLookbackDays; i++) {
      final date = today.subtract(Duration(days: i));
      final summary = await getDailySummaryByDate(date);

      if (!summary.isAchieved) break;

      streak++;
    }

    return streak;
  }

  Future<HydrationProfileSummary> getProfileSummary() async {
    final lifetimeMl = await getLifetimeTotalMl();
    final currentStreakDays = await getCurrentStreakDays();
    final lastDrinkAt = await getLastDrink();

    return HydrationProfileSummary(
      lifetimeMl: lifetimeMl,
      currentStreakDays: currentStreakDays,
      lastDrinkAt: lastDrinkAt,
    );
  }
}
