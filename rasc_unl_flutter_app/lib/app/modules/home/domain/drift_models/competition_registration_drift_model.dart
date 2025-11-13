import 'package:drift/drift.dart';

@DataClassName('competition_registration_drift_model')
class CompetitionRegistrationTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get externalId => text().nullable()(); // UUID o similar - opcional
  TextColumn get registrationNumber => text().nullable()(); // número dorsal - opcional
  IntColumn get time => integer().nullable()(); // tiempo en milisegundos - opcional

  TextColumn get userDni => text()(); // referencia al usuario
  IntColumn get nTurns => integer().nullable()(); // número de vueltas - opcional
  IntColumn get competenceId => integer()(); // referencia al id de la competencia
}
