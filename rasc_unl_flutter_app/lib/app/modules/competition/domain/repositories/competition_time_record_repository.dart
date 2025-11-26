import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';

abstract class CompetitionTimeRecordRepository {
  /// Create a new time record
  Future<TimeRecordModel> createTimeRecord(TimeRecordModel timeRecord);

  /// Get time record by ID
  Future<TimeRecordModel?> getTimeRecordById(String id);

  /// Get time records by registration ID
  Future<List<TimeRecordModel>> getTimeRecordsByRegistrationId(
    String registrationId,
  );

  /// Update a time record
  Future<TimeRecordModel> updateTimeRecord(TimeRecordModel timeRecord);

  /// Delete a time record
  Future<void> deleteTimeRecord(String id);
}
