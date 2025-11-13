import 'package:json_annotation/json_annotation.dart';


part 'competence_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetenceModel {
  final int id;
  final String externalId;
  final String name;
  final DateTime? competitionDate;
  final DateTime? competitionLimitForRegistrationDate;
  final int nTurns;
  final int? maxRegistrations; // Límite de registros de tiempo permitidos
  final bool isActive;
  final bool isFinished; // Indica si la competencia finalizó
  final String createdBy; // User DNI of the creator
  final Map<String, List<double>> startCoordinates;
  final Map<String, List<double>> finishCoordinates;


  CompetenceModel({
    required this.id,
    required this.externalId,
    required this.name,
    required this.competitionDate,
    required this.competitionLimitForRegistrationDate,
    required this.nTurns,
    this.maxRegistrations,
    required this.isActive,
    required this.isFinished,
    required this.createdBy,
    this.startCoordinates = const {
        "point_x": [0.0, 0.0],
        "point_y": [0.0, 0.0],
    },
    this.finishCoordinates = const {
        "point_x": [0.0, 0.0],
        "point_y": [0.0, 0.0],
    },
   
  });


  factory CompetenceModel.fromJson(Map<String, dynamic> json) =>
      _$CompetenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetenceModelToJson(this);
}
