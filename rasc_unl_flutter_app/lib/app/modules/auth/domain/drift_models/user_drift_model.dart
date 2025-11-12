import 'package:drift/drift.dart';

@DataClassName('user_drift_model')
class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get dni => text()(); // número de cédula u otro identificador

  // Guardamos el rol como string (ADMINISTRATOR o COMPETITOR)
  TextColumn get rol =>
      text().withDefault(const Constant('COMPETITOR'))(); 

  TextColumn get name => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))(); // valor por defecto true

  DateTimeColumn get birthDate => dateTime().nullable()();

}
