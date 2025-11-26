import 'package:json_annotation/json_annotation.dart';

part 'competition_registration_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetitionRegistrationModel {
  final String id;
  final String dorsalNumber;
  final int nParticipants;
  final String name;
  final String userDni;
  final String competenceId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Sync fields
  final String syncStatus;
  final DateTime? lastSyncAt;
  final int version;
  final String? deviceId;
  final bool isDeleted;

  CompetitionRegistrationModel({
    required this.id,
    required this.dorsalNumber,
    required this.nParticipants,
    required this.name,
    required this.userDni,
    required this.competenceId,
    required this.createdAt,
    this.updatedAt,
    this.syncStatus = 'pending',
    this.lastSyncAt,
    this.version = 1,
    this.deviceId,
    this.isDeleted = false,
  });

  CompetitionRegistrationModel copyWith({
    String? id,
    String? dorsalNumber,
    int? nParticipants,
    String? name,
    String? userDni,
    String? competenceId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    DateTime? lastSyncAt,
    int? version,
    String? deviceId,
    bool? isDeleted,
  }) {
    return CompetitionRegistrationModel(
      id: id ?? this.id,
      dorsalNumber: dorsalNumber ?? this.dorsalNumber,
      nParticipants: nParticipants ?? this.nParticipants,
      name: name ?? this.name,
      userDni: userDni ?? this.userDni,
      competenceId: competenceId ?? this.competenceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      version: version ?? this.version,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory CompetitionRegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$CompetitionRegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetitionRegistrationModelToJson(this);
}

class DurationConverter implements JsonConverter<Duration?, int?> {
  const DurationConverter();

  @override
  Duration? fromJson(int? json) =>
      json != null ? Duration(milliseconds: json) : null;

  @override
  int? toJson(Duration? object) => object?.inMilliseconds;
}
