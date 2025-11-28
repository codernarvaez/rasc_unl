import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/local_user_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/session_local_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

/// Implementacion local del repositorio de autenticación
class LocalAuthRepositoryImpl implements AuthRepository {
  final AppLocalDatabase _db;
  late final SessionLocalRepository _sessionRepo;
  late final UserRepository _userRepo;

  LocalAuthRepositoryImpl(this._db) {
    _sessionRepo = SessionLocalRepository(_db);
    _userRepo = LocalUserRepositoryImpl(_db);
  }

  @override
  Future<AuthResult> login({
    required String email,
    String? dni,
    String? password,
  }) async {
    try {
      // Modo offline: validar con sesión local usando DNI y email
      if (dni == null || dni.isEmpty) {
        return AuthResult(
          success: false,
          message: 'El DNI es requerido para iniciar sesi�n offline',
        );
      }

      final session = await _sessionRepo.getSessionByCredentials(
        dni: dni,
        email: email,
      );
      
      if (session == null) {
        return AuthResult(
          success: false,
          message: 'No se encontro una sesion previa para este usuario. Conectese a Internet para iniciar sesion por primera vez.',
        );
      }

      // Obtener usuario de la base de datos local
      final user = await _userRepo.getUserByDni(session.dni);
      
      if (user == null) {
        return AuthResult(
          success: false,
          message: 'Usuario no encontrado en la base de datos local.',
        );
      }

      return AuthResult(
        success: true,
        message: 'Inicio de sesion offline exitoso',
        user: user,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error al iniciar sesion offline: $e',
      );
    }
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String firstName,
    required String lastName,
    required String dni,
    required String password,
  }) async {
    return AuthResult(
      success: false,
      message: 'El registro requiere conexión a Internet',
    );
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    // En modo offline, simplemente limpiamos el estado local si es necesario
    // No hay tokens que invalidar
  }
}
