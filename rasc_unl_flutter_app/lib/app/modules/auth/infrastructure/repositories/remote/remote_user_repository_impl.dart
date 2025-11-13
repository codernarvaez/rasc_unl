import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class RemoteUserRepositoryImpl implements UserRepository {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  final String? _accessToken;

  RemoteUserRepositoryImpl({String? accessToken}) : _accessToken = accessToken;

  Map<String, String> get _headers {
    logging.i('🔑 RemoteUserRepository - Token status: ${_accessToken != null ? "Present (${_accessToken.length} chars)" : "NULL"}');
    return {
      'Content-Type': 'application/json',
      if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
    };
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/auth/users'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      }

      throw Exception('Error al obtener usuarios: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener usuarios: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/auth/users/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception('Error al obtener usuario por ID: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener usuario: $e');
    }
  }

  @override
  Future<UserModel?> getUserByDni(String dni) async {
    try {
      // La API no tiene un endpoint específico para buscar por DNI,
      // así que buscamos en todos los usuarios
      final users = await getAllUsers();
      try {
        return users.firstWhere((user) => user.dni == dni);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener usuario por DNI: $e');
    }
  }

  @override
  Future<void> insertUser(UserModel user) async {
    // La creación de usuarios se hace a través del endpoint de registro
    // Este método no tiene un equivalente directo en la API
    throw UnimplementedError(
        'La creación de usuarios se realiza a través del endpoint de registro');
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      // Usar el endpoint /me para actualizar el perfil del usuario actual
      // Este endpoint permite que cualquier usuario autenticado actualice su propio perfil
      final response = await http.put(
        Uri.parse('$_baseUrl/api/v1/auth/me'),
        headers: _headers,
        body: jsonEncode({
          'first_name': user.name,
          'last_name': user.lastName,
          'date_of_birth': user.birthDate?.toIso8601String().split('T')[0],
        }),
      );

      if (response.statusCode == 401) {
        throw Exception('No autorizado: El token de acceso es inválido o ha expirado');
      }

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al actualizar usuario: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar usuario: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/v1/auth/users/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al eliminar usuario: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al eliminar usuario: $e');
    }
  }
}
