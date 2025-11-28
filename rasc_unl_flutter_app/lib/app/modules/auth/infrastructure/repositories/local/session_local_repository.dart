import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

/// Repositorio para gestionar sesiones locales en Drift
class SessionLocalRepository {
  final AppLocalDatabase _db;

  SessionLocalRepository(this._db);

  /// Crea una nueva sesión local
  Future<SessionDriftModel> createSession({
    required String userId,
    required String dni,
    required String email,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) async {
    final id = await _db.into(_db.sessionTable).insert(
      SessionTableCompanion.insert(
        userId: userId,
        dni: dni,
        email: email,
        accessToken: Value(accessToken),
        refreshToken: Value(refreshToken),
        tokenExpiresAt: Value(tokenExpiresAt),
      ),
    );

    return (await (_db.select(_db.sessionTable)..where((t) => t.id.equals(id))).getSingle());
  }

  /// Obtiene la sesión activa (solo debe haber una)
  Future<SessionDriftModel?> getActiveSession() async {
    return await (_db.select(_db.sessionTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.lastLoginAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Obtiene una sesión por DNI y email (para login offline)
  Future<SessionDriftModel?> getSessionByCredentials({
    required String dni,
    required String email,
  }) async {
    return await (_db.select(_db.sessionTable)
          ..where((t) => t.dni.equals(dni) & t.email.equals(email)))
        .getSingleOrNull();
  }

  /// Actualiza los tokens de una sesión
  Future<void> updateSessionTokens({
    required int sessionId,
    required String accessToken,
    required String refreshToken,
    required DateTime tokenExpiresAt,
  }) async {
    await (_db.update(_db.sessionTable)..where((t) => t.id.equals(sessionId)))
        .write(
      SessionTableCompanion(
        accessToken: Value(accessToken),
        refreshToken: Value(refreshToken),
        tokenExpiresAt: Value(tokenExpiresAt),
        lastLoginAt: Value(utcNow()),
      ),
    );
  }

  /// Actualiza el timestamp de último login
  Future<void> updateLastLogin(int sessionId) async {
    await (_db.update(_db.sessionTable)..where((t) => t.id.equals(sessionId)))
        .write(
      SessionTableCompanion(
        lastLoginAt: Value(utcNow()),
      ),
    );
  }

  /// Desactiva todas las sesiones
  Future<void> deactivateAllSessions() async {
    await _db.update(_db.sessionTable).write(
      const SessionTableCompanion(
        isActive: Value(false),
      ),
    );
  }

  /// Desactiva una sesión específica
  Future<void> deactivateSession(int sessionId) async {
    await (_db.update(_db.sessionTable)..where((t) => t.id.equals(sessionId)))
        .write(
      const SessionTableCompanion(
        isActive: Value(false),
      ),
    );
  }

  /// Elimina una sesión
  Future<void> deleteSession(int sessionId) async {
    await (_db.delete(_db.sessionTable)..where((t) => t.id.equals(sessionId)))
        .go();
  }

  /// Limpia tokens de una sesión (para logout parcial)
  Future<void> clearSessionTokens(int sessionId) async {
    await (_db.update(_db.sessionTable)..where((t) => t.id.equals(sessionId)))
        .write(
      const SessionTableCompanion(
        accessToken: Value(null),
        refreshToken: Value(null),
        tokenExpiresAt: Value(null),
      ),
    );
  }

  /// Obtiene todas las sesiones (para debugging)
  Future<List<SessionDriftModel>> getAllSessions() async {
    return await _db.select(_db.sessionTable).get();
  }
}
