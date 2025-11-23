import 'package:drift/drift.dart';
import 'dart:convert';

@DataClassName('competence_drift_model')
class CompetenceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get competitionDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isFinished => boolean().withDefault(const Constant(false))(); // Indica si finalizó
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}