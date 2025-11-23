import 'package:json_annotation/json_annotation.dart';

part 'time_record_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TimeRecordModel {
  final int id;
  @DurationConverter()
  final Duration time; // Time in milliseconds
  final int competitionRegistrationId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeRecordModel({
    required this.id,
    required this.time,
    required this.competitionRegistrationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeRecordModel.fromJson(Map<String, dynamic> json) =>
      _$TimeRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeRecordModelToJson(this);

}



class DurationConverter implements JsonConverter<Duration?, int?> {
  const DurationConverter();

  @override
  Duration? fromJson(int? json) => json != null ? Duration(milliseconds: json) : null;

  @override
  int? toJson(Duration? object) => object?.inMilliseconds;
}