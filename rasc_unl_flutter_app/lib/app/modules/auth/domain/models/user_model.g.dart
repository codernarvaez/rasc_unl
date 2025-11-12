// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  dni: json['dni'] as String,
  rol:
      $enumDecodeNullable(_$UserRoleTypeEnumMap, json['rol']) ??
      UserRoleType.COMPETITOR,
  name: json['name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool? ?? true,
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'dni': instance.dni,
  'rol': _$UserRoleTypeEnumMap[instance.rol]!,
  'name': instance.name,
  'last_name': instance.lastName,
  'email': instance.email,
  'is_active': instance.isActive,
  'birth_date': instance.birthDate?.toIso8601String(),
};

const _$UserRoleTypeEnumMap = {
  UserRoleType.ADMINISTRATOR: 'ADMINISTRATOR',
  UserRoleType.COMPETITOR: 'COMPETITOR',
};
