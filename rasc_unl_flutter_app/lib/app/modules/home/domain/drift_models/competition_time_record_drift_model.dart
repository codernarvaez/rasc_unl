import 'package:drift/drift.dart';

@DataClassName('competition_time_record_drift_model')
class CompetitionTimeRecordTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK autoincremental
  TextColumn get registrationNumber => text().nullable()(); // número de registro/dorsal - opcional
  IntColumn get time => integer()(); // tiempo en milisegundos - requerido
  IntColumn get competenceId => integer()(); // referencia al id de la competencia
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
