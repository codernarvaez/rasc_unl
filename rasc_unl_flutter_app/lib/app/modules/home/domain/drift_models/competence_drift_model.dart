import 'package:drift/drift.dart';
import 'dart:convert';

@DataClassName('competence_drift_model')
class CompetenceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get externalId => text()();
  TextColumn get name => text()();
  DateTimeColumn get competitionDate => dateTime().nullable()();
  DateTimeColumn get competitionLimitForRegistrationDate => dateTime().nullable()();
  IntColumn get nTurns => integer().withDefault(const Constant(0))();
  IntColumn get maxRegistrations => integer().nullable()(); // Límite de registros de tiempo
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isFinished => boolean().withDefault(const Constant(false))(); // Indica si finalizó
  TextColumn get createdBy => text()();

  // Guardamos los mapas como JSON strings
  TextColumn get startCoordinates =>
      text().map(const CoordinatesMapConverter())();

  TextColumn get finishCoordinates =>
      text().map(const CoordinatesMapConverter())();

}

/// Conversor para Map<String, List<double>>
class CoordinatesMapConverter
    extends TypeConverter<Map<String, List<double>>, String> {
  const CoordinatesMapConverter();

  @override
  Map<String, List<double>> fromSql(String fromDb) {
    try {
      final decoded = jsonDecode(fromDb);
      return (decoded as Map).map((key, value) => MapEntry(
        key.toString(),
        (value as List).map((e) => (e as num).toDouble()).toList(),
      ));
    } catch (_) {
      return {};
    }
  }

  @override
  String toSql(Map<String, List<double>> value) {
    return jsonEncode(value);
  }
}
