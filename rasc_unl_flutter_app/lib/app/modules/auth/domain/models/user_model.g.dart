// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  dni: json['dni'] as String,
  rol: json['role'] as String? ?? 'COMPETITOR',
  name: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool? ?? true,
  birthDate: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'dni': instance.dni,
  'role': instance.rol,
  'first_name': instance.name,
  'last_name': instance.lastName,
  'email': instance.email,
  'is_active': instance.isActive,
  'date_of_birth': instance.birthDate?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
