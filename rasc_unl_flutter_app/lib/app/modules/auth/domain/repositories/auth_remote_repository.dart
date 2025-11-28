import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/auth_models.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';

/// Repositorio abstracto para operaciones de autenticación remota
abstract class AuthRemoteRepository {
  /// Registra un nuevo usuario en el servidor
  Future<UserApiResponse> register(RegisterRequest request);

  /// Inicia sesión y retorna tokens
  Future<LoginResponse> login(LoginRequest request);

  /// Refresca el token de acceso
  Future<LoginResponse> refreshToken(String refreshToken);

  /// Cierra sesión revocando tokens
  Future<void> logout(String refreshToken);

  /// Obtiene la información del usuario actual autenticado
  Future<UserApiResponse> getCurrentUser(String accessToken);

  /// Actualiza la información del usuario actual
  Future<UserApiResponse> updateCurrentUser(
    String accessToken,
    Map<String, dynamic> updates,
  );

  /// Obtiene todos los usuarios (solo admin)
  Future<List<UserApiResponse>> getAllUsers(
    String accessToken, {
    int skip = 0,
    int limit = 100,
    String? role,
    bool? isActive,
    String? search,
  });

  /// Obtiene un usuario por ID (solo admin)
  Future<UserApiResponse> getUserById(String accessToken, String userId);

  /// Actualiza un usuario (solo admin)
  Future<UserApiResponse> updateUser(
    String accessToken,
    String userId,
    Map<String, dynamic> updates,
  );

  /// Activa un usuario (solo admin)
  Future<UserApiResponse> activateUser(String accessToken, String userId);

  /// Desactiva un usuario (solo admin)
  Future<UserApiResponse> deactivateUser(String accessToken, String userId);
}
