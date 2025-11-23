import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';

abstract class CompetitionTimeRecordRepository {
  /// Create a new time record for a registration
  Future<TimeRecordModel> createTimeRecord({
    required int registrationId,
    required int timeInMilliseconds,
  });

  /// Get time record by ID
  Future<TimeRecordModel?> getTimeRecordById(int id);

  /// Get time records by registration ID
  Future<List<TimeRecordModel>> getTimeRecordsByRegistrationId(int registrationId);

  /// Update a time record
  Future<TimeRecordModel> updateTimeRecord({
    required int id,
    required int timeInMilliseconds,
  });

  /// Delete a time record
  Future<void> deleteTimeRecord(int id);
}
