import 'package:drift/drift.dart';

class HydrationEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountMl => integer()();
  TextColumn get sourceType => text()();
  TextColumn get sourceLabel => text()();
  DateTimeColumn get consumeAt => dateTime()();
  TextColumn get localDate => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime()();
}
