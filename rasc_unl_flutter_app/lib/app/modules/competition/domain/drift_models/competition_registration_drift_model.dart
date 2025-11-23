import 'package:drift/drift.dart';

@DataClassName('competition_registration_drift_model')
class CompetitionRegistrationTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get dorsalNumber => text()();
  IntColumn get nParticipants => integer()();
  TextColumn get name => text()();
  TextColumn get userDni => text()();
  IntColumn get competenceId => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
