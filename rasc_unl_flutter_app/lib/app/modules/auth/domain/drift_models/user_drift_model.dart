import 'package:drift/drift.dart';

@DataClassName('user_drift_model')
class UserTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get dni =>
      text().unique()(); // número de cédula u otro identificador

  // Guardamos el rol como string (ADMINISTRATOR o MODERATOR)
  TextColumn get role => text().withDefault(const Constant('MODERATOR'))();

  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().unique()();
  DateTimeColumn get birthDate => dateTime().nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))(); // valor por defecto true

  // Campos para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync fields
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  // Password for offline creation (only stored locally)
  TextColumn get password => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
