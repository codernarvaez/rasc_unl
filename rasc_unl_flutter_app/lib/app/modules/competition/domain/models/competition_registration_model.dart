import 'package:json_annotation/json_annotation.dart';


part 'competition_registration_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetitionRegistrationModel {
  final int id;
  final String dorsalNumber;
  final int nParticipants;
  final String name;
  final String userDni;
  final int competenceId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CompetitionRegistrationModel({
    required this.id,
    required this.dorsalNumber,
    required this.nParticipants,
    required this.name,
    required this.userDni,
    required this.competenceId,
    required this.createdAt,
    this.updatedAt,
  });

  factory CompetitionRegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$CompetitionRegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetitionRegistrationModelToJson(this);
}




class DurationConverter implements JsonConverter<Duration?, int?> {
  const DurationConverter();

  @override
  Duration? fromJson(int? json) => json != null ? Duration(milliseconds: json) : null;

  @override
  int? toJson(Duration? object) => object?.inMilliseconds;
}
