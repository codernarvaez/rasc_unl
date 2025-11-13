import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/auth_models.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_remote_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/session_local_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

/// Resultado de operaciones de autenticación
class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final bool isOffline;

  AuthResult({
    required this.success,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.isOffline = false,
  });
}

/// Servicio de autenticación híbrido (online/offline)
class AuthService {
  final AuthRemoteRepository _remoteRepo;
  final UserRepository _localUserRepo;
  final SessionLocalRepository _sessionRepo;
  final bool _isOffline;

  AuthService({
    required AuthRemoteRepository remoteRepo,
    required UserRepository localUserRepo,
    required SessionLocalRepository sessionRepo,
    required bool isOffline,
  })  : _remoteRepo = remoteRepo,
        _localUserRepo = localUserRepo,
        _sessionRepo = sessionRepo,
        _isOffline = isOffline;

  /// Registra un nuevo usuario
  /// Solo funciona online
  Future<AuthResult> register({
    required String email,
    required String firstName,
    required String lastName,
    required String dni,
    required String password,
  }) async {
    try {
      if (_isOffline) {
        return AuthResult(
          success: false,
          message: 'No se puede registrar sin conexión a Internet',
        );
      }

      final request = RegisterRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        dni: dni,
        password: password,
      );

      final userApiResponse = await _remoteRepo.register(request);

      // Guardar usuario en BD local
      final user = _mapApiResponseToUserModel(userApiResponse);
      await _localUserRepo.insertUser(user);

      logging.i('Usuario registrado: ${user.email}');

      return AuthResult(
        success: true,
        message: 'Usuario registrado exitosamente',
        user: user,
      );
    } catch (e) {
      logging.e('Error al registrar usuario: $e');
      return AuthResult(
        success: false,
        message: 'Error al registrar: ${e.toString()}',
      );
    }
  }

  /// Inicia sesión (online o offline)
  Future<AuthResult> login({
    required String email,
    required String dni,
    String? password,
  }) async {
    try {
      if (_isOffline) {
        // Login offline: verificar DNI y email en BD local
        return await _loginOffline(dni: dni, email: email);
      } else {
        // Login online: autenticar con API
        if (password == null) {
          return AuthResult(
            success: false,
            message: 'La contraseña es requerida para login online',
          );
        }
        return await _loginOnline(email: email, password: password, dni: dni);
      }
    } catch (e) {
      logging.e('Error al iniciar sesión: $e');
      return AuthResult(
        success: false,
        message: 'Error al iniciar sesión: ${e.toString()}',
      );
    }
  }

  /// Login online
  Future<AuthResult> _loginOnline({
    required String email,
    required String password,
    required String dni,
  }) async {
    try {
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );

      // Autenticar con API
      final loginResponse = await _remoteRepo.login(loginRequest);

      // Obtener información del usuario
      final userApiResponse = await _remoteRepo.getCurrentUser(loginResponse.accessToken);
      final user = _mapApiResponseToUserModel(userApiResponse);

      // Guardar o actualizar usuario en BD local
      final existingUser = await _localUserRepo.getUserByDni(dni);
      if (existingUser == null) {
        await _localUserRepo.insertUser(user);
      } else {
        await _localUserRepo.updateUser(user.copyWith(id: existingUser.id));
      }

      // Calcular expiración del token (típicamente 30 minutos)
      final tokenExpiresAt = DateTime.now().add(const Duration(minutes: 30));

      // Desactivar sesiones anteriores
      await _sessionRepo.deactivateAllSessions();

      // Crear nueva sesión
      await _sessionRepo.createSession(
        userId: user.id,
        dni: dni,
        email: email,
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        tokenExpiresAt: tokenExpiresAt,
      );

      logging.i('Login online exitoso: ${user.email}');

      return AuthResult(
        success: true,
        message: 'Inicio de sesión exitoso',
        user: user,
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        isOffline: false,
      );
    } catch (e) {
      logging.e('Error en login online: $e');
      return AuthResult(
        success: false,
        message: 'Credenciales inválidas o error de conexión',
      );
    }
  }

  /// Login offline: verifica DNI y email en BD local
  Future<AuthResult> _loginOffline({
    required String dni,
    required String email,
  }) async {
    try {
      // Buscar sesión previa con estas credenciales
      final session = await _sessionRepo.getSessionByCredentials(
        dni: dni,
        email: email,
      );

      if (session == null) {
        return AuthResult(
          success: false,
          message: 'No se encontró una sesión previa. Debe conectarse a Internet para iniciar sesión por primera vez.',
        );
      }

      // Obtener usuario de BD local
      final user = await _localUserRepo.getUserById(session.userId);

      if (user == null) {
        return AuthResult(
          success: false,
          message: 'Usuario no encontrado en la base de datos local',
        );
      }

      if (!user.isActive) {
        return AuthResult(
          success: false,
          message: 'Usuario inactivo',
        );
      }

      // Actualizar último login
      await _sessionRepo.updateLastLogin(session.id);

      logging.i('Login offline exitoso: ${user.email}');

      return AuthResult(
        success: true,
        message: 'Inicio de sesión offline exitoso',
        user: user,
        isOffline: true,
      );
    } catch (e) {
      logging.e('Error en login offline: $e');
      return AuthResult(
        success: false,
        message: 'Error al iniciar sesión offline: ${e.toString()}',
      );
    }
  }

  /// Cierra sesión
  Future<AuthResult> logout({String? refreshToken}) async {
    try {
      // Si estamos online y tenemos refresh token, revocar en el servidor
      if (!_isOffline && refreshToken != null) {
        try {
          await _remoteRepo.logout(refreshToken);
        } catch (e) {
          logging.w('No se pudo revocar el token en el servidor: $e');
        }
      }

      // Desactivar sesión local
      await _sessionRepo.deactivateAllSessions();

      logging.i('Logout exitoso');

      return AuthResult(
        success: true,
        message: 'Sesión cerrada exitosamente',
      );
    } catch (e) {
      logging.e('Error al cerrar sesión: $e');
      return AuthResult(
        success: false,
        message: 'Error al cerrar sesión: ${e.toString()}',
      );
    }
  }

  /// Obtiene la sesión activa actual
  Future<AuthResult> getActiveSession() async {
    try {
      final session = await _sessionRepo.getActiveSession();

      if (session == null) {
        return AuthResult(
          success: false,
          message: 'No hay sesión activa',
        );
      }

      final user = await _localUserRepo.getUserById(session.userId);

      if (user == null) {
        return AuthResult(
          success: false,
          message: 'Usuario no encontrado',
        );
      }

      return AuthResult(
        success: true,
        user: user,
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        isOffline: _isOffline || session.accessToken == null,
      );
    } catch (e) {
      logging.e('Error al obtener sesión activa: $e');
      return AuthResult(
        success: false,
        message: 'Error al obtener sesión: ${e.toString()}',
      );
    }
  }

  /// Refresca el token de acceso (solo online)
  Future<AuthResult> refreshAccessToken(String refreshToken) async {
    try {
      if (_isOffline) {
        return AuthResult(
          success: false,
          message: 'No se puede refrescar el token sin conexión',
        );
      }

      final loginResponse = await _remoteRepo.refreshToken(refreshToken);
      final session = await _sessionRepo.getActiveSession();

      if (session != null) {
        final tokenExpiresAt = DateTime.now().add(const Duration(minutes: 30));
        await _sessionRepo.updateSessionTokens(
          sessionId: session.id,
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
          tokenExpiresAt: tokenExpiresAt,
        );
      }

      logging.i('Token refrescado exitosamente');

      return AuthResult(
        success: true,
        message: 'Token refrescado',
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );
    } catch (e) {
      logging.e('Error al refrescar token: $e');
      return AuthResult(
        success: false,
        message: 'Error al refrescar token: ${e.toString()}',
      );
    }
  }

  /// Mapea la respuesta de la API a UserModel
  UserModel _mapApiResponseToUserModel(UserApiResponse apiResponse) {
    return UserModel(
      id: apiResponse.id,
      dni: apiResponse.dni,
      rol: apiResponse.role,
      name: apiResponse.firstName,
      lastName: apiResponse.lastName,
      email: apiResponse.email,
      isActive: apiResponse.isActive,
      birthDate: apiResponse.dateOfBirth != null
          ? DateTime.tryParse(apiResponse.dateOfBirth!)
          : null,
    );
  }
}

/// Extension para copiar UserModel con cambios
extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    int? id,
    String? dni,
    String? rol,
    String? name,
    String? lastName,
    String? email,
    bool? isActive,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      rol: rol ?? this.rol,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
