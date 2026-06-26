import 'package:drift/drift.dart';

class DailyGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localDate => text().unique()();
  IntColumn get targetMl => integer().withDefault(const Constant(2000))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
