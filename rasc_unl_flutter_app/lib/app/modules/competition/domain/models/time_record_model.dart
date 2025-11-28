import 'package:json_annotation/json_annotation.dart';

part 'time_record_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TimeRecordModel {
  final String id;
  @DurationMillisecondsConverter()
  final Duration time; // Time in milliseconds
  final String competitionRegistrationId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Sync fields
  final String syncStatus;
  final DateTime? lastSyncAt;
  final int version;
  final String? deviceId;
  final bool isDeleted;

  TimeRecordModel({
    required this.id,
    required this.time,
    required this.competitionRegistrationId,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
    this.lastSyncAt,
    this.version = 1,
    this.deviceId,
    this.isDeleted = false,
  });

  TimeRecordModel copyWith({
    String? id,
    Duration? time,
    String? competitionRegistrationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    DateTime? lastSyncAt,
    int? version,
    String? deviceId,
    bool? isDeleted,
  }) {
    return TimeRecordModel(
      id: id ?? this.id,
      time: time ?? this.time,
      competitionRegistrationId:
          competitionRegistrationId ?? this.competitionRegistrationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      version: version ?? this.version,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  factory TimeRecordModel.fromJson(Map<String, dynamic> json) =>
      _$TimeRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeRecordModelToJson(this);
}

class DurationMillisecondsConverter implements JsonConverter<Duration, int> {
  const DurationMillisecondsConverter();

  @override
  Duration fromJson(int json) => Duration(milliseconds: json);

  @override
  int toJson(Duration object) => object.inMilliseconds;
}
