import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class CompositeCompetitionTimeRecordRepositoryImpl
    implements CompetitionTimeRecordRepository {
  final CompetitionTimeRecordRepository localRepository;
  final CompetitionTimeRecordRepository remoteRepository;
  final bool isOffline;

  CompositeCompetitionTimeRecordRepositoryImpl({
    required this.localRepository,
    required this.remoteRepository,
    required this.isOffline,
  });

  @override
  Future<TimeRecordModel?> getTimeRecordById(String id) async {
    return localRepository.getTimeRecordById(id);
  }

  @override
  Future<List<TimeRecordModel>> getTimeRecordsByRegistrationId(
    String registrationId,
  ) async {
    return localRepository.getTimeRecordsByRegistrationId(registrationId);
  }

  @override
  Future<TimeRecordModel> createTimeRecord(TimeRecordModel timeRecord) async {
    final pendingRecord = timeRecord.copyWith(syncStatus: 'pending');
    // Local repo should return the created model
    final createdLocal = await localRepository.createTimeRecord(pendingRecord);

    if (!isOffline) {
      try {
        await remoteRepository.createTimeRecord(timeRecord);
        final syncedRecord = timeRecord.copyWith(syncStatus: 'synced');
        await localRepository.updateTimeRecord(syncedRecord);
        return syncedRecord;
      } catch (e) {
        logging.e('Failed to push time record to remote: $e');
        // Return local version (pending) if remote fails
        return createdLocal;
      }
    }
    return createdLocal;
  }

  @override
  Future<TimeRecordModel> updateTimeRecord(TimeRecordModel timeRecord) async {
    final pendingRecord = timeRecord.copyWith(syncStatus: 'pending');
    final updatedLocal = await localRepository.updateTimeRecord(pendingRecord);

    if (!isOffline) {
      try {
        await remoteRepository.updateTimeRecord(timeRecord);
        final syncedRecord = timeRecord.copyWith(syncStatus: 'synced');
        await localRepository.updateTimeRecord(syncedRecord);
        return syncedRecord;
      } catch (e) {
        logging.e('Failed to push time record update to remote: $e');
        return updatedLocal;
      }
    }
    return updatedLocal;
  }

  @override
  Future<void> deleteTimeRecord(String id) async {
    // Since we don't have getAllTimeRecords, we rely on getTimeRecordById
    final record = await localRepository.getTimeRecordById(id);

    if (record != null) {
      final deletedRecord = record.copyWith(
        isDeleted: true,
        syncStatus: 'pending',
      );
      await localRepository.updateTimeRecord(deletedRecord);

      if (!isOffline) {
        try {
          await remoteRepository.deleteTimeRecord(id);
          final syncedDeleted = deletedRecord.copyWith(syncStatus: 'synced');
          await localRepository.updateTimeRecord(syncedDeleted);
        } catch (e) {
          logging.e('Failed to push time record delete to remote: $e');
        }
      }
    }
  }
}
