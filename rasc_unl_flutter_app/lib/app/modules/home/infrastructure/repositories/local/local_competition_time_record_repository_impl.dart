import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetitionTimeRecordRepositoryImpl implements CompetitionTimeRecordRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetitionTimeRecordRepositoryImpl(this._localDatabase);

  @override
  Future<CompetitionTimeRecordModel> createTimeRecord({
    required String? registrationNumber,
    required int timeInMilliseconds,
    required int competenceId,
    required String recordedByDni,
    int? position,
    bool isEarly = false,
    bool isReference = false,
  }) async {
    final now = DateTime.now();
    final id = await _localDatabase.into(_localDatabase.competitionTimeRecordTable).insert(
      CompetitionTimeRecordTableCompanion.insert(
        registrationNumber: Value(registrationNumber),
        time: timeInMilliseconds,
        position: Value(position),
        recordedByDni: recordedByDni,
        isEarly: Value(isEarly),
        isReference: Value(isReference),
        competenceId: competenceId,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return CompetitionTimeRecordModel(
      id: id,
      registrationNumber: registrationNumber,
      time: timeInMilliseconds,
      position: position,
      recordedByDni: recordedByDni,
      isEarly: isEarly,
      isReference: isReference,
      competenceId: competenceId,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<List<CompetitionTimeRecordModel>> getAllTimeRecords({
    int skip = 0,
    int limit = 100,
  }) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competitionTimeRecordTable)
          ..limit(limit, offset: skip))
        .get();

    return queryResult
        .map((row) => CompetitionTimeRecordModel(
              id: row.id,
              registrationNumber: row.registrationNumber,
              time: row.time,
              position: row.position,
              recordedByDni: row.recordedByDni,
              isEarly: row.isEarly,
              isReference: row.isReference,
              competenceId: row.competenceId,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
            ))
        .toList();
  }

  @override
  Future<CompetitionTimeRecordModel> getTimeRecordById(int id) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (queryResult == null) {
      throw Exception('Registro de tiempo no encontrado');
    }

    return CompetitionTimeRecordModel(
      id: queryResult.id,
      registrationNumber: queryResult.registrationNumber,
      time: queryResult.time,
      position: queryResult.position,
      recordedByDni: queryResult.recordedByDni,
      isEarly: queryResult.isEarly,
      isReference: queryResult.isReference,
      competenceId: queryResult.competenceId,
      createdAt: queryResult.createdAt,
      updatedAt: queryResult.updatedAt,
    );
  }

  @override
  Future<List<CompetitionTimeRecordModel>> getTimeRecordsByCompetenceId(
    int competenceId, {
    String? registrationNumber,
  }) async {
    var query = _localDatabase.select(_localDatabase.competitionTimeRecordTable)
      ..where((tbl) => tbl.competenceId.equals(competenceId));

    if (registrationNumber != null && registrationNumber.isNotEmpty) {
      query = query..where((tbl) => tbl.registrationNumber.equals(registrationNumber));
    }

    // Order by time ascending (fastest first)
    query = query..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc)]);

    final queryResult = await query.get();

    return queryResult
        .map((row) => CompetitionTimeRecordModel(
              id: row.id,
              registrationNumber: row.registrationNumber,
              time: row.time,
              position: row.position,
              recordedByDni: row.recordedByDni,
              isEarly: row.isEarly,
              isReference: row.isReference,
              competenceId: row.competenceId,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
            ))
        .toList();
  }

  @override
  Future<CompetitionTimeRecordModel> updateTimeRecord({
    required int id,
    String? registrationNumber,
    int? timeInMilliseconds,
    int? position,
    bool? isEarly,
    bool? isReference,
  }) async {
    final now = DateTime.now();
    
    await (_localDatabase.update(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      CompetitionTimeRecordTableCompanion(
        registrationNumber: registrationNumber != null ? Value(registrationNumber) : const Value.absent(),
        time: timeInMilliseconds != null ? Value(timeInMilliseconds) : const Value.absent(),
        position: position != null ? Value(position) : const Value.absent(),
        isEarly: isEarly != null ? Value(isEarly) : const Value.absent(),
        isReference: isReference != null ? Value(isReference) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );

    return await getTimeRecordById(id);
  }

  @override
  Future<void> deleteTimeRecord(int id) async {
    await (_localDatabase.delete(_localDatabase.competitionTimeRecordTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<int> countTimeRecordsByCompetenceAndRegistration(
    int competenceId,
    String registrationNumber,
  ) async {
    final records = await getTimeRecordsByCompetenceId(
      competenceId,
      registrationNumber: registrationNumber,
    );
    return records.length;
  }
}
