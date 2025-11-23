// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetitionRegistrationModel _$CompetitionRegistrationModelFromJson(
  Map<String, dynamic> json,
) => CompetitionRegistrationModel(
  id: (json['id'] as num).toInt(),
  dorsalNumber: json['dorsal_number'] as String,
  nParticipants: (json['n_participants'] as num).toInt(),
  name: json['name'] as String,
  userDni: json['user_dni'] as String,
  competenceId: (json['competence_id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
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
};
