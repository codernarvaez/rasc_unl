// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  dni: json['dni'] as String,
  role: json['role'] as String? ?? 'MODERATOR',
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool? ?? true,
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  password: json['password'] as String?,
  syncStatus: json['sync_status'] as String? ?? 'synced',
  lastSyncAt: json['last_sync_at'] == null
      ? null
      : DateTime.parse(json['last_sync_at'] as String),
  version: (json['version'] as num?)?.toInt() ?? 1,
  deviceId: json['device_id'] as String?,
  isDeleted: json['is_deleted'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'dni': instance.dni,
  'role': instance.role,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'is_active': instance.isActive,
  'birth_date': instance.birthDate?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'password': ?instance.password,
  'sync_status': instance.syncStatus,
  'last_sync_at': instance.lastSyncAt?.toIso8601String(),
  'version': instance.version,
  'device_id': instance.deviceId,
  'is_deleted': instance.isDeleted,
};
