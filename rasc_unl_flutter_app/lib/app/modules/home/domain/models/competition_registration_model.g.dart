// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompetitionRegistrationModel _$CompetitionRegistrationModelFromJson(
  Map<String, dynamic> json,
) => CompetitionRegistrationModel(
  id: (json['id'] as num).toInt(),
  externalId: json['external_id'] as String?,
  registrationNumber: json['registration_number'] as String?,
  time: const DurationConverter().fromJson((json['time'] as num?)?.toInt()),
  userDni: json['user_dni'] as String,
  nTurns: (json['n_turns'] as num?)?.toInt(),
  competenceId: (json['competence_id'] as num).toInt(),
);

Map<String, dynamic> _$CompetitionRegistrationModelToJson(
  CompetitionRegistrationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'external_id': instance.externalId,
  'registration_number': instance.registrationNumber,
  'time': const DurationConverter().toJson(instance.time),
  'user_dni': instance.userDni,
  'n_turns': instance.nTurns,
  'competence_id': instance.competenceId,
};
