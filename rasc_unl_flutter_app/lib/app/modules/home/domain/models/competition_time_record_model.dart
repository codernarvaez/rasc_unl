import 'package:json_annotation/json_annotation.dart';

part 'competition_time_record_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CompetitionTimeRecordModel {
  final int id;
  final String? registrationNumber;
  final int time; // Time in milliseconds
  final int? position; // Position/rank of the arrival (1st, 2nd, 3rd, etc.)
  final String recordedByDni; // DNI of moderator/admin who recorded
  final bool isEarly; // If time was recorded before first moderator record
  final bool isReference; // If this is the first/reference time record
  final int competenceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompetitionTimeRecordModel({
    required this.id,
    this.registrationNumber,
    required this.time,
    this.position,
    required this.recordedByDni,
    this.isEarly = false,
    this.isReference = false,
    required this.competenceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompetitionTimeRecordModel.fromJson(Map<String, dynamic> json) =>
      _$CompetitionTimeRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompetitionTimeRecordModelToJson(this);

  // Helper to convert time to Duration
  Duration get duration => Duration(milliseconds: time);

  // Helper to format time as MM:SS.mmm
  String get formattedTime {
    int totalMilliseconds = time;
    int seconds = (totalMilliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;
    int milliseconds = totalMilliseconds % 1000;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String millisecondsStr = milliseconds.toString().padLeft(3, '0');

    return "$minutesStr:$secondsStr.$millisecondsStr";
  }

  CompetitionTimeRecordModel copyWith({
    int? id,
    String? registrationNumber,
    int? time,
    int? position,
    String? recordedByDni,
    bool? isEarly,
    bool? isReference,
    int? competenceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompetitionTimeRecordModel(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      time: time ?? this.time,
      position: position ?? this.position,
      recordedByDni: recordedByDni ?? this.recordedByDni,
      isEarly: isEarly ?? this.isEarly,
      isReference: isReference ?? this.isReference,
      competenceId: competenceId ?? this.competenceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
