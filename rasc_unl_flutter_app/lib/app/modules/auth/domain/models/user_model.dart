import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserModel {
  final String id; // Changed from int to String
  final String dni;
  final String role;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(includeIfNull: false)
  final String? password;

  // Sync fields
  @JsonKey(name: 'sync_status')
  final String syncStatus;
  @JsonKey(name: 'last_sync_at')
  final DateTime? lastSyncAt;
  final int version;
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  UserModel({
    required this.id,
    required this.dni,
    this.role = 'MODERATOR',
    required this.firstName,
    required this.lastName,
    required this.email,
    this.isActive = true,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
    this.password,
    this.syncStatus = 'synced',
    this.lastSyncAt,
    this.version = 1,
    this.deviceId,
    this.isDeleted = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? dni,
    String? role,
    String? firstName,
    String? lastName,
    String? email,
    bool? isActive,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? password,
    String? syncStatus,
    DateTime? lastSyncAt,
    int? version,
    String? deviceId,
    bool? isDeleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      password: password ?? this.password,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      version: version ?? this.version,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  bool get isAdministrator => role == 'ADMINISTRATOR';
  bool get isModerator => role == 'MODERATOR';
}

enum UserRoleType { ADMINISTRATOR, MODERATOR }
