import 'package:drift/drift.dart';

@DataClassName('user_drift_model')
class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get dni => text().unique()(); // número de cédula u otro identificador

  // Guardamos el rol como string (ADMINISTRATOR o MODERATOR)
  TextColumn get role =>
      text().withDefault(const Constant('MODERATOR'))(); 

  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().unique()();
  DateTimeColumn get birthDate => dateTime().nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))(); // valor por defecto true

  
  // Campos para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}
