import 'package:drift/drift.dart';

@DataClassName('user_drift_model')
class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  IntColumn get remoteId => integer().nullable()(); // ID del servidor remoto
  TextColumn get dni => text().unique()(); // número de cédula u otro identificador

  // Guardamos el rol como string (ADMINISTRATOR o COMPETITOR)
  TextColumn get rol =>
      text().withDefault(const Constant('COMPETITOR'))(); 

  TextColumn get name => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().unique()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))(); // valor por defecto true

  DateTimeColumn get birthDate => dateTime().nullable()();
  
  // Campos para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()(); // Última sincronización con el servidor
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))(); // Indica si hay cambios sin sincronizar
  
  @override
  Set<Column> get primaryKey => {id};
}
