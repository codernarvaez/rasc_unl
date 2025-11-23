import 'package:json_annotation/json_annotation.dart';


part 'competence_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetenceModel {
  final int id;
  final String name;
  final DateTime? competitionDate;
  final bool isActive;
  final bool isFinished; // Indica si la competencia finalizó
  final String createdBy; // User DNI of the creator
  final DateTime createdAt;
  final DateTime? updatedAt;
  


  CompetenceModel({
    required this.id,
    required this.name,
    required this.competitionDate,
    required this.isActive,
    required this.isFinished,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });


  factory CompetenceModel.fromJson(Map<String, dynamic> json) =>
      _$CompetenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetenceModelToJson(this);
}
