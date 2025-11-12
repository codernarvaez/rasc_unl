import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetenceRepositoryImpl implements CompetenceRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetenceRepositoryImpl(this._localDatabase);

  @override
  Future<void> createCompetence(CompetenceModel competence) async {
    await _localDatabase.into(_localDatabase.competenceTable).insert(
          CompetenceTableCompanion.insert(
            externalId: competence.externalId,
            name: competence.name,
            competitionDate: Value(competence.competitionDate),
            nTurns: Value(competence.nTurns),
            isActive: Value(competence.isActive),
            createdBy: competence.createdBy,
            startCoordinates: competence.startCoordinates ,
            finishCoordinates: competence.finishCoordinates,
          ),
        );
  }

  @override
  Future<void> deleteCompetence(int id) async {
    await (_localDatabase.delete(_localDatabase.competenceTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<List<CompetenceModel>> getAllCompetences() async {
    final queryResult = await _localDatabase.select(_localDatabase.competenceTable).get();
    return queryResult
        .map(
          (row) => CompetenceModel(
            id: row.id,
            externalId: row.externalId,
            name: row.name,
            competitionDate: row.competitionDate,
            nTurns: row.nTurns,
            isActive: row.isActive,
            createdBy: row.createdBy,
            startCoordinates: row.startCoordinates,
            finishCoordinates: row.finishCoordinates,
          ),
        )
        .toList();
  }

  @override
  Future<CompetenceModel?> getCompetenceById(int id) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competenceTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (queryResult != null) {
      return CompetenceModel(
        id: queryResult.id,
        externalId: queryResult.externalId,
        name: queryResult.name,
        competitionDate: queryResult.competitionDate,
        nTurns: queryResult.nTurns,
        isActive: queryResult.isActive,
        createdBy: queryResult.createdBy,
        startCoordinates: queryResult.startCoordinates,
        finishCoordinates: queryResult.finishCoordinates,
      );
    }
    return null;
  }
}