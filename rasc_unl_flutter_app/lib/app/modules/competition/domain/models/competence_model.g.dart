// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetenceModel _$CompetenceModelFromJson(Map<String, dynamic> json) =>
    CompetenceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      competitionDate: json['competition_date'] == null
          ? null
          : DateTime.parse(json['competition_date'] as String),
      isActive: json['is_active'] as bool,
      isFinished: json['is_finished'] as bool,
      createdBy: json['created_by'] as String,
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

Map<String, dynamic> _$CompetenceModelToJson(CompetenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'competition_date': instance.competitionDate?.toIso8601String(),
      'is_active': instance.isActive,
      'is_finished': instance.isFinished,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'sync_status': instance.syncStatus,
      'last_sync_at': instance.lastSyncAt?.toIso8601String(),
      'version': instance.version,
      'device_id': instance.deviceId,
      'is_deleted': instance.isDeleted,
    };
