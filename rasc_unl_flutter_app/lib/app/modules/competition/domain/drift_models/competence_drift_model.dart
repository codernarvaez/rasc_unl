import 'package:drift/drift.dart';
import 'dart:convert';

@DataClassName('competence_drift_model')
class CompetenceTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  DateTimeColumn get competitionDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isFinished =>
      boolean().withDefault(const Constant(false))(); // Indica si finalizó
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // Sync fields
  TextColumn get syncStatus => text().withDefault(
    const Constant('pending'),
  )(); // synced, pending, conflict
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
