import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetitionTimeRecordRepositoryImpl
    implements CompetitionTimeRecordRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetitionTimeRecordRepositoryImpl(this._localDatabase);

  @override
  Future<TimeRecordModel> createTimeRecord(TimeRecordModel timeRecord) async {
    await _localDatabase
        .into(_localDatabase.competitionTimeRecordTable)
        .insert(
          CompetitionTimeRecordTableCompanion.insert(
            id: timeRecord.id,
            time: timeRecord.time.inMilliseconds,
            competitionRegistrationId: timeRecord.competitionRegistrationId,
            createdAt: timeRecord.createdAt,
            updatedAt: timeRecord.updatedAt,
            syncStatus: Value(timeRecord.syncStatus),
            lastSyncAt: Value(timeRecord.lastSyncAt),
            version: Value(timeRecord.version),
            deviceId: Value(timeRecord.deviceId),
            isDeleted: Value(timeRecord.isDeleted),
          ),
        );

    return timeRecord;
  }

  @override
  Future<TimeRecordModel?> getTimeRecordById(String id) async {
    final queryResult = await (_localDatabase.select(
      _localDatabase.competitionTimeRecordTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (queryResult == null) {
      return null;
    }

    return TimeRecordModel(
      id: queryResult.id,
      time: Duration(milliseconds: queryResult.time),
      competitionRegistrationId: queryResult.competitionRegistrationId,
      createdAt: queryResult.createdAt,
      updatedAt: queryResult.updatedAt,
      syncStatus: queryResult.syncStatus,
      lastSyncAt: queryResult.lastSyncAt,
      version: queryResult.version,
      deviceId: queryResult.deviceId,
      isDeleted: queryResult.isDeleted,
    );
  }

  @override
  Future<List<TimeRecordModel>> getTimeRecordsByRegistrationId(
    String registrationId,
  ) async {
    final query =
        _localDatabase.select(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.competitionRegistrationId.equals(registrationId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc),
          ]);

    final queryResult = await query.get();

    return queryResult
        .map(
          (row) => TimeRecordModel(
            id: row.id,
            time: Duration(milliseconds: row.time),
            competitionRegistrationId: row.competitionRegistrationId,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
            syncStatus: row.syncStatus,
            lastSyncAt: row.lastSyncAt,
            version: row.version,
            deviceId: row.deviceId,
            isDeleted: row.isDeleted,
          ),
        )
        .toList();
  }

  @override
  Future<TimeRecordModel> updateTimeRecord(TimeRecordModel timeRecord) async {
    final now = DateTime.now();

    await (_localDatabase.update(
      _localDatabase.competitionTimeRecordTable,
    )..where((tbl) => tbl.id.equals(timeRecord.id))).write(
      CompetitionTimeRecordTableCompanion(
        time: Value(timeRecord.time.inMilliseconds),
        updatedAt: Value(now),
        syncStatus: Value(timeRecord.syncStatus),
        lastSyncAt: Value(timeRecord.lastSyncAt),
        version: Value(timeRecord.version),
        deviceId: Value(timeRecord.deviceId),
        isDeleted: Value(timeRecord.isDeleted),
      ),
    );

    final updated = await getTimeRecordById(timeRecord.id);
    if (updated == null) {
      throw Exception('Registro de tiempo no encontrado después de actualizar');
    }
    return updated;
  }

  @override
  Future<void> deleteTimeRecord(String id) async {
    await (_localDatabase.delete(
      _localDatabase.competitionTimeRecordTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
