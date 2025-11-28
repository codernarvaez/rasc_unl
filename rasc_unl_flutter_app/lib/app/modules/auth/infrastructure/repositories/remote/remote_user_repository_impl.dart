import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/auth_models.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class RemoteUserRepositoryImpl implements UserRepository {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  final String? _accessToken;

  RemoteUserRepositoryImpl({String? accessToken}) : _accessToken = accessToken;

  Map<String, String> get _headers {
    logging.i(
      '🔑 RemoteUserRepository - Token status: ${_accessToken != null ? "Present (${_accessToken.length} chars)" : "NULL"}',
    );
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
  Future<UserModel?> getUserById(String id) async {
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

      throw Exception(
        'Error al obtener usuario por ID: ${response.statusCode}',
      );
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
    if (user.password == null) {
      throw Exception(
        'No se puede sincronizar el usuario ${user.email} sin contraseña',
      );
    }

    final request = RegisterRequest(
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      dni: user.dni,
      password: user.password!,
    );

    try {
      final url = Uri.parse('$_baseUrl/api/v1/auth/register');
      // No enviamos headers con token para registro, o sí?
      // Usualmente registro es público.
      // Pero si queremos que el admin cree usuarios, tal vez deberíamos usar otro endpoint.
      // Por ahora usamos registro público.
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Error al crear usuario: ${errorData['detail'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión al crear usuario: $e');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      // Usar el endpoint de admin /users/{id} que permite actualizar rol e is_active
      final body = <String, dynamic>{
        'first_name': user.firstName,
        'last_name': user.lastName,
      };

      // Agregar campos opcionales si están presentes
      if (user.birthDate != null) {
        body['date_of_birth'] = user.birthDate!.toIso8601String().split('T')[0];
      }

      // Agregar rol si está presente (para admins)
      if (user.role.isNotEmpty) {
        body['role'] = user.role;
      }

      // Agregar is_activee
      body['is_active'] = user.isActive;

      final response = await http.put(
        Uri.parse('$_baseUrl/api/v1/auth/users/${user.id}'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 401) {
        throw Exception(
          'No autorizado: El token de acceso es inválido o ha expirado',
        );
      }

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Error al actualizar usuario: ${errorData['detail'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar usuario: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/v1/auth/users/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Error al eliminar usuario: ${errorData['detail'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión al eliminar usuario: $e');
    }
  }

  @override
  Future<List<UserModel>> getPendingSyncUsers() {
    throw UnimplementedError(
      'Remote repository does not support local sync status check',
    );
  }
}
