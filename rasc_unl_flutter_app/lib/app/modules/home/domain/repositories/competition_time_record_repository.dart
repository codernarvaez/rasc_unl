import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_time_record_model.dart';

abstract class CompetitionTimeRecordRepository {
  /// Create a new time record
  Future<CompetitionTimeRecordModel> createTimeRecord({
    required String? registrationNumber,
    required int timeInMilliseconds,
    required int competenceId,
  });

  /// Get all time records with pagination
  Future<List<CompetitionTimeRecordModel>> getAllTimeRecords({
    int skip = 0,
    int limit = 100,
  });

  /// Get time record by ID
  Future<CompetitionTimeRecordModel> getTimeRecordById(int id);

  /// Get time records by competence ID
  Future<List<CompetitionTimeRecordModel>> getTimeRecordsByCompetenceId(
    int competenceId, {
    String? registrationNumber,
  });

  /// Update a time record
  Future<CompetitionTimeRecordModel> updateTimeRecord({
    required int id,
    String? registrationNumber,
    int? timeInMilliseconds,
  });

  /// Delete a time record
  Future<void> deleteTimeRecord(int id);

  /// Count time records by competence and registration number
  Future<int> countTimeRecordsByCompetenceAndRegistration(
    int competenceId,
    String registrationNumber,
  );
}
