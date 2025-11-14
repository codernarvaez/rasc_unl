// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_time_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetitionTimeRecordModel _$CompetitionTimeRecordModelFromJson(
  Map<String, dynamic> json,
) => CompetitionTimeRecordModel(
  id: (json['id'] as num).toInt(),
  registrationNumber: json['registration_number'] as String?,
  time: (json['time'] as num).toInt(),
  position: (json['position'] as num?)?.toInt(),
  recordedByDni: json['recorded_by_dni'] as String,
  isEarly: json['is_early'] as bool? ?? false,
  isReference: json['is_reference'] as bool? ?? false,
  competenceId: (json['competence_id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CompetitionTimeRecordModelToJson(
  CompetitionTimeRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'registration_number': instance.registrationNumber,
  'time': instance.time,
  'position': instance.position,
  'recorded_by_dni': instance.recordedByDni,
  'is_early': instance.isEarly,
  'is_reference': instance.isReference,
  'competence_id': instance.competenceId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
