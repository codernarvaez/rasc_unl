import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';

/// Implementación remota del repositorio de autenticación
class RemoteAuthRepositoryImpl implements AuthRepository {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';

  @override
  Future<AuthResult> login({
    required String email,
    String? dni,
    String? password,
  }) async {
    try {
      if (password == null || password.isEmpty) {
        return AuthResult(
          success: false,
          message: 'La contraseña es requerida para iniciar sesión online',
        );
      }

      // OAuth2 requiere application/x-www-form-urlencoded y username en lugar de email
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': password,
          'grant_type': 'password',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;

        // Obtener datos del usuario
        if (accessToken != null) {
          final userResponse = await http.get(
            Uri.parse('$_baseUrl/api/v1/auth/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          );

          if (userResponse.statusCode == 200) {
            final userData = jsonDecode(userResponse.body);
            final user = UserModel.fromJson(userData);

            return AuthResult(
              success: true,
              message: 'Inicio de sesión exitoso',
              user: user,
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
          }
        }
      }

      final errorData = jsonDecode(response.body);
      return AuthResult(
        success: false,
        message: errorData['detail'] ?? 'Error al iniciar sesión',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error de conexión: $e',
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
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'dni': dni,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return AuthResult(
          success: true,
          message: 'Registro exitoso. Por favor, inicie sesión.',
        );
      }

      final errorData = jsonDecode(response.body);
      return AuthResult(
        success: false,
        message: errorData['detail'] ?? 'Error al registrarse',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error de conexión: $e',
      );
    }
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    try {
      if (refreshToken != null) {
        await http.post(
          Uri.parse('$_baseUrl/api/v1/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh_token': refreshToken}),
        );
      }
    } catch (e) {
      // Ignorar errores de logout
    }
  }
}
