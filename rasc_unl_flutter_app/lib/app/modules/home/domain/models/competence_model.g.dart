// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetenceModel _$CompetenceModelFromJson(Map<String, dynamic> json) =>
    CompetenceModel(
      id: (json['id'] as num).toInt(),
      externalId: json['external_id'] as String,
      name: json['name'] as String,
      competitionDate: json['competition_date'] == null
          ? null
          : DateTime.parse(json['competition_date'] as String),
      competitionLimitForRegistrationDate:
          json['competition_limit_for_registration_date'] == null
          ? null
          : DateTime.parse(
              json['competition_limit_for_registration_date'] as String,
            ),
      nTurns: (json['n_turns'] as num).toInt(),
      maxRegistrations: (json['max_registrations'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      isFinished: json['is_finished'] as bool,
      createdBy: json['created_by'] as String,
      startCoordinates:
          (json['start_coordinates'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
            ),
          ) ??
          const {
            "point_x": [0.0, 0.0],
            "point_y": [0.0, 0.0],
          },
      finishCoordinates:
          (json['finish_coordinates'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
            ),
          ) ??
          const {
            "point_x": [0.0, 0.0],
            "point_y": [0.0, 0.0],
          },
    );

Map<String, dynamic> _$CompetenceModelToJson(CompetenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'external_id': instance.externalId,
      'name': instance.name,
      'competition_date': instance.competitionDate?.toIso8601String(),
      'competition_limit_for_registration_date': instance
          .competitionLimitForRegistrationDate
          ?.toIso8601String(),
      'n_turns': instance.nTurns,
      'max_registrations': instance.maxRegistrations,
      'is_active': instance.isActive,
      'is_finished': instance.isFinished,
      'created_by': instance.createdBy,
      'start_coordinates': instance.startCoordinates,
      'finish_coordinates': instance.finishCoordinates,
    };
