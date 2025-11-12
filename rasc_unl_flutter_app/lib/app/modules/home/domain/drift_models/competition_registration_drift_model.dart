import 'package:drift/drift.dart';

@DataClassName('competition_registration_drift_model')
class CompetitionRegistrationTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get externalId => text()(); // UUID o similar
  IntColumn get registrationNumber => integer()(); // número dorsal
  IntColumn get time => integer().withDefault(const Constant(0))(); 
  // tiempo en milisegundos (compatible con tu DurationConverter)

  TextColumn get userDni => text()(); // referencia al usuario
  IntColumn get nTurns => integer().withDefault(const Constant(0))(); // número de vueltas
  IntColumn get competenceId => integer()(); // referencia al id de la competencia
}
