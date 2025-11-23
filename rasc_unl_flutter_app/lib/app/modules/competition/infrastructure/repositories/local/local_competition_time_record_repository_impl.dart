import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetitionTimeRecordRepositoryImpl implements CompetitionTimeRecordRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetitionTimeRecordRepositoryImpl(this._localDatabase);

  @override
  Future<TimeRecordModel> createTimeRecord({
    required int registrationId,
    required int timeInMilliseconds,
  }) async {
    final now = DateTime.now();
    final id = await _localDatabase.into(_localDatabase.competitionTimeRecordTable).insert(
      CompetitionTimeRecordTableCompanion.insert(
        time: timeInMilliseconds,
        competitionRegistrationId: registrationId,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return TimeRecordModel(
      id: id,
      time: Duration(milliseconds: timeInMilliseconds),
      competitionRegistrationId: registrationId,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<TimeRecordModel?> getTimeRecordById(int id) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (queryResult == null) {
      return null;
    }

    return TimeRecordModel(
      id: queryResult.id,
      time: Duration(milliseconds: queryResult.time),
      competitionRegistrationId: queryResult.competitionRegistrationId,
      createdAt: queryResult.createdAt,
      updatedAt: queryResult.updatedAt,
    );
  }

  @override
  Future<List<TimeRecordModel>> getTimeRecordsByRegistrationId(int registrationId) async {
    final query = _localDatabase.select(_localDatabase.competitionTimeRecordTable)
      ..where((tbl) => tbl.competitionRegistrationId.equals(registrationId))
      ..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc)]);

    final queryResult = await query.get();

    return queryResult
        .map((row) => TimeRecordModel(
              id: row.id,
              time: Duration(milliseconds: row.time),
              competitionRegistrationId: row.competitionRegistrationId,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
            ))
        .toList();
  }

  @override
  Future<TimeRecordModel> updateTimeRecord({
    required int id,
    required int timeInMilliseconds,
  }) async {
    final now = DateTime.now();
    
    await (_localDatabase.update(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      CompetitionTimeRecordTableCompanion(
        time: Value(timeInMilliseconds),
        updatedAt: Value(now),
      ),
    );

    final updated = await getTimeRecordById(id);
    if (updated == null) {
      throw Exception('Registro de tiempo no encontrado después de actualizar');
    }
    return updated;
  }

  @override
  Future<void> deleteTimeRecord(int id) async {
    await (_localDatabase.delete(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
