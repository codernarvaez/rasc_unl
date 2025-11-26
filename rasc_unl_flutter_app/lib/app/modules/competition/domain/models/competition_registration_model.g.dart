// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetitionRegistrationModel _$CompetitionRegistrationModelFromJson(
  Map<String, dynamic> json,
) => CompetitionRegistrationModel(
  id: json['id'] as String,
  dorsalNumber: json['dorsal_number'] as String,
  nParticipants: (json['n_participants'] as num).toInt(),
  name: json['name'] as String,
  userDni: json['user_dni'] as String,
  competenceId: json['competence_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  syncStatus: json['sync_status'] as String? ?? 'pending',
  lastSyncAt: json['last_sync_at'] == null
      ? null
      : DateTime.parse(json['last_sync_at'] as String),
  version: (json['version'] as num?)?.toInt() ?? 1,
  deviceId: json['device_id'] as String?,
  isDeleted: json['is_deleted'] as bool? ?? false,
);

Map<String, dynamic> _$CompetitionRegistrationModelToJson(
  CompetitionRegistrationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'dorsal_number': instance.dorsalNumber,
  'n_participants': instance.nParticipants,
  'name': instance.name,
  'user_dni': instance.userDni,
  'competence_id': instance.competenceId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'sync_status': instance.syncStatus,
  'last_sync_at': instance.lastSyncAt?.toIso8601String(),
  'version': instance.version,
  'device_id': instance.deviceId,
  'is_deleted': instance.isDeleted,
};
