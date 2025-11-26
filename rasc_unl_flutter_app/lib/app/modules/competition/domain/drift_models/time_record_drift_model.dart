import 'package:drift/drift.dart';

@DataClassName('competition_time_record_drift_model')
class CompetitionTimeRecordTable extends Table {
  TextColumn get id => text()(); // UUID
  IntColumn get time => integer()(); // Time in milliseconds
  TextColumn get competitionRegistrationId => text()(); // UUID FK
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // Sync fields
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
