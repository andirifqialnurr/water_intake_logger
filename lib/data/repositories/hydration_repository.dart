import 'package:drift/drift.dart';
import 'package:water_intake_logger/data/local/app_database.dart';
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

  Future<int> getTotalMlByDate(DateTime date) async {
    final localDate = _dateKey(date);

    final rows =
        await (db.select(db.hydrationEntries)
              ..where((entry) => entry.localDate.equals(localDate))
              ..where((entry) => entry.deletedAt.isNull()))
            .get();
    return rows.fold<int>(0, (total, entry) => total + entry.amountMl);
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
}
