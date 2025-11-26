import 'package:json_annotation/json_annotation.dart';

part 'competence_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetenceModel {
  final String id;
  final String name;
  final DateTime? competitionDate;
  final bool isActive;
  final bool isFinished; // Indica si la competencia finalizó
  final String createdBy; // User DNI of the creator
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Sync fields
  final String syncStatus;
  final DateTime? lastSyncAt;
  final int version;
  final String? deviceId;
  final bool isDeleted;

  CompetenceModel({
    required this.id,
    required this.name,
    required this.competitionDate,
    required this.isActive,
    required this.isFinished,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = 'pending',
    this.lastSyncAt,
    this.version = 1,
    this.deviceId,
    this.isDeleted = false,
  });

  CompetenceModel copyWith({
    String? id,
    String? name,
    DateTime? competitionDate,
    bool? isActive,
    bool? isFinished,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    DateTime? lastSyncAt,
    int? version,
    String? deviceId,
    bool? isDeleted,
  }) {
    return CompetenceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      competitionDate: competitionDate ?? this.competitionDate,
      isActive: isActive ?? this.isActive,
      isFinished: isFinished ?? this.isFinished,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      version: version ?? this.version,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory CompetenceModel.fromJson(Map<String, dynamic> json) =>
      _$CompetenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetenceModelToJson(this);
}
