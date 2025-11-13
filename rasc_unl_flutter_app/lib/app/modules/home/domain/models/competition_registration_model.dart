import 'package:json_annotation/json_annotation.dart';


part 'competition_registration_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetitionRegistrationModel {
  final int id;
  final String? externalId;
  final String? registrationNumber;
  @DurationConverter()
  final Duration? time;
  final String userDni;
  final int? nTurns;
  final int competenceId;

  CompetitionRegistrationModel({
    required this.id,
    this.externalId,
    this.registrationNumber,
    this.time,
    required this.userDni,
    this.nTurns,
    required this.competenceId,
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
