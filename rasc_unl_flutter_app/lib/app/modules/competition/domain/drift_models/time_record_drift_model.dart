import 'package:drift/drift.dart';

@DataClassName('competition_time_record_drift_model')
class CompetitionTimeRecordTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  IntColumn get time => integer()(); // Time in milliseconds
  IntColumn get competitionRegistrationId => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
