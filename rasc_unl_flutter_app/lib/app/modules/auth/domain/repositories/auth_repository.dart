import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';

/// Resultado de operaciones de autenticación
class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });
}

/// Repositorio abstracto para autenticación
abstract class AuthRepository {
  Future<AuthResult> login({
    required String email,
    String? dni,
    String? password,
  });

  Future<AuthResult> register({
    required String email,
    required String firstName,
    required String lastName,
    required String dni,
    required String password,
  });

  Future<void> logout({String? refreshToken});
}
