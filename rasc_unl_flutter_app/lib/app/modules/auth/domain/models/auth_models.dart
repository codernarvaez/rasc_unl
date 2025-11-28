import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Modelo para el login request
@JsonSerializable()
class LoginRequest {
  final String username; // email
  final String password;
  @JsonKey(name: 'grant_type')
  final String? grantType;
  final String? scope;
  @JsonKey(name: 'client_id')
  final String? clientId;
  @JsonKey(name: 'client_secret')
  final String? clientSecret;

  LoginRequest({
    required this.username,
    required this.password,
    this.grantType,
    this.scope = "",
    this.clientId,
    this.clientSecret,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Modelo para el registro request
@JsonSerializable()
class RegisterRequest {
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String dni;
  final String password;

  RegisterRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// Modelo para la respuesta de login
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'token_type')
  final String tokenType;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// Modelo para la respuesta del usuario desde la API
@JsonSerializable(fieldRename: FieldRename.snake)
class UserApiResponse {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String dni;
  final String? dateOfBirth;
  final String role;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final int version;

  UserApiResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dni,
    this.dateOfBirth,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.version = 1,
  });

  factory UserApiResponse.fromJson(Map<String, dynamic> json) =>
      _$UserApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiResponseToJson(this);
}
