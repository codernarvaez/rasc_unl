// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeRecordModel _$TimeRecordModelFromJson(Map<String, dynamic> json) =>
    TimeRecordModel(
      id: (json['id'] as num).toInt(),
      time: Duration(microseconds: (json['time'] as num).toInt()),
      competitionRegistrationId: (json['competition_registration_id'] as num)
          .toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TimeRecordModelToJson(TimeRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time.inMicroseconds,
      'competition_registration_id': instance.competitionRegistrationId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
