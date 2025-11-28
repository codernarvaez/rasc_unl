import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/auth_models.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_remote_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final String baseUrl;

  AuthRemoteRepositoryImpl({String? baseUrl})
    : baseUrl = baseUrl ?? dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Map<String, String> _getHeaders({String? accessToken}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  @override
  Future<UserApiResponse> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/register');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to register: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/login');

    // OAuth2 espera application/x-www-form-urlencoded
    final body = {
      'username': request.username,
      'password': request.password,
      'grant_type': request.grantType ?? '',
      'scope': request.scope ?? '',
      if (request.clientId != null) 'client_id': request.clientId!,
      if (request.clientSecret != null) 'client_secret': request.clientSecret!,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to login: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<LoginResponse> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/refresh');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to refresh token: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/logout');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to logout: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<UserApiResponse> getCurrentUser(String accessToken) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/me');
    final response = await http.get(
      url,
      headers: _getHeaders(accessToken: accessToken),
    );

    if (response.statusCode == 200) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to get current user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<UserApiResponse> updateCurrentUser(
    String accessToken,
    Map<String, dynamic> updates,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/me');
    final response = await http.put(
      url,
      headers: _getHeaders(accessToken: accessToken),
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to update current user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<List<UserApiResponse>> getAllUsers(
    String accessToken, {
    int skip = 0,
    int limit = 100,
    String? role,
    bool? isActive,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive.toString(),
      if (search != null) 'search': search,
    };

    final url = Uri.parse(
      '$baseUrl/api/v1/auth/users',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      url,
      headers: _getHeaders(accessToken: accessToken),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserApiResponse.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to get users: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<UserApiResponse> getUserById(String accessToken, String userId) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/users/$userId');
    final response = await http.get(
      url,
      headers: _getHeaders(accessToken: accessToken),
    );

    if (response.statusCode == 200) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to get user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<UserApiResponse> updateUser(
    String accessToken,
    String userId,
    Map<String, dynamic> updates,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/users/$userId');
    final response = await http.put(
      url,
      headers: _getHeaders(accessToken: accessToken),
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to update user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<UserApiResponse> activateUser(
    String accessToken,
    String userId,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/users/$userId/activate');
    final response = await http.put(
      url,
      headers: _getHeaders(accessToken: accessToken),
    );

    if (response.statusCode == 200) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to activate user: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<UserApiResponse> deactivateUser(
    String accessToken,
    String userId,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/users/$userId/deactivate');
    final response = await http.put(
      url,
      headers: _getHeaders(accessToken: accessToken),
    );

    if (response.statusCode == 200) {
      return UserApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to deactivate user: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
