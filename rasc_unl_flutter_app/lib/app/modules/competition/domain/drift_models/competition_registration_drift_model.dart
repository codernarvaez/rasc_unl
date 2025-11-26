import 'package:drift/drift.dart';

@DataClassName('competition_registration_drift_model')
class CompetitionRegistrationTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get dorsalNumber => text()();
  IntColumn get nParticipants => integer()();
  TextColumn get name => text()();
  TextColumn get userDni => text()();
  TextColumn get competenceId => text()(); // UUID FK
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // Sync fields
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
