import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:water_intake_logger/data/local/tables/daily_goals_table.dart';
import 'package:water_intake_logger/data/local/tables/hidration_entries_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [HydrationEntries, DailyGoals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'water_intake_logger');
  }
}
