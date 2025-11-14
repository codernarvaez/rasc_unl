import 'package:drift/drift.dart';

@DataClassName('competition_time_record_drift_model')
class CompetitionTimeRecordTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get registrationNumber => text().nullable()(); // número de registro/dorsal - opcional
  IntColumn get time => integer()(); // tiempo en milisegundos - requerido
  IntColumn get position => integer().nullable()(); // Posición/rank del registro (1st, 2nd, 3rd, etc.)
  TextColumn get recordedByDni => text()(); // DNI del moderador que registró
  BoolColumn get isEarly => boolean().withDefault(const Constant(false))(); // Si se registró antes del tiempo de referencia
  BoolColumn get isReference => boolean().withDefault(const Constant(false))(); // Si este es el primer registro de referencia
  IntColumn get competenceId => integer()(); // referencia al id de la competencia
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
