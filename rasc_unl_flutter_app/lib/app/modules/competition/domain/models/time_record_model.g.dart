// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeRecordModel _$TimeRecordModelFromJson(Map<String, dynamic> json) =>
    TimeRecordModel(
      id: json['id'] as String,
      time: Duration(microseconds: (json['time'] as num).toInt()),
      competitionRegistrationId: json['competition_registration_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      syncStatus: json['sync_status'] as String? ?? 'pending',
      lastSyncAt: json['last_sync_at'] == null
          ? null
          : DateTime.parse(json['last_sync_at'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
      deviceId: json['device_id'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TimeRecordModelToJson(TimeRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time.inMicroseconds,
      'competition_registration_id': instance.competitionRegistrationId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'sync_status': instance.syncStatus,
      'last_sync_at': instance.lastSyncAt?.toIso8601String(),
      'version': instance.version,
      'device_id': instance.deviceId,
      'is_deleted': instance.isDeleted,
    };
