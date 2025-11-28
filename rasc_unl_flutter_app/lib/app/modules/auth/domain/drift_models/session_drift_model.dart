import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/drift_models/user_drift_model.dart';

/// Tabla para almacenar información de sesión local
/// Permite login offline verificando DNI y email
@DataClassName('SessionDriftModel')
class SessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId =>
      text().references(UserTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get dni => text()();
  TextColumn get email => text()();
  DateTimeColumn get lastLoginAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get accessToken =>
      text().nullable()(); // Token de acceso (solo cuando hay conexión)
  TextColumn get refreshToken =>
      text().nullable()(); // Token de refresco (solo cuando hay conexión)
  DateTimeColumn get tokenExpiresAt =>
      dateTime().nullable()(); // Expiración del token

  @override
  Set<Column> get primaryKey => {id};
}
