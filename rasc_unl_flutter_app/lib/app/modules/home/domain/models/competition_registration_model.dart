import 'package:json_annotation/json_annotation.dart';


part 'competition_registration_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetitionRegistrationModel {
  final int id;
  final String externalId;
  final int registrationNumber;
  @DurationConverter()
  final Duration time;
  final String userDni;
  final int nTurns;
  final int competenceId;

  CompetitionRegistrationModel({
    required this.id,
    required this.externalId,
    required this.registrationNumber,
    required this.time,
    required this.userDni,
    required this.nTurns,
    required this.competenceId,
  });

  factory CompetitionRegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$CompetitionRegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetitionRegistrationModelToJson(this);
}




class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int json) => Duration(milliseconds: json);

  @override
  int toJson(Duration object) => object.inMilliseconds;
}
