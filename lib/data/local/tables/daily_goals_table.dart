import 'package:drift/drift.dart';

class DailyGoalsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get localDate => text().unique()();
  IntColumn get targetMl => integer().withDefault(const Constant(2000))();
  TextColumn get remoteId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pendingCreate'))();

  TextColumn get syncError => text().nullable()();
}
