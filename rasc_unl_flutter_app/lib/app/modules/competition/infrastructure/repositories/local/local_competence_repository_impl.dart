import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetenceRepositoryImpl implements CompetenceRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetenceRepositoryImpl(this._localDatabase);

  @override
  Future<void> createCompetence(CompetenceModel competence) async {
    await _localDatabase.into(_localDatabase.competenceTable).insert(
          CompetenceTableCompanion.insert(
            name: competence.name,
            competitionDate: Value(competence.competitionDate),
            isActive: Value(competence.isActive),
            isFinished: Value(competence.isFinished),
            createdBy: competence.createdBy,
            createdAt: Value(competence.createdAt),
            updatedAt: Value(competence.updatedAt),
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
            name: row.name,
            competitionDate: row.competitionDate,
            isActive: row.isActive,
            isFinished: row.isFinished,
            createdBy: row.createdBy,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
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
        name: queryResult.name,
        competitionDate: queryResult.competitionDate,
        isActive: queryResult.isActive,
        isFinished: queryResult.isFinished,
        createdBy: queryResult.createdBy,
        createdAt: queryResult.createdAt,
        updatedAt: queryResult.updatedAt,
      );
    }
    return null;
  }

  @override
  Future<void> updateCompetence(CompetenceModel competence) async {
    await (_localDatabase.update(_localDatabase.competenceTable)
          ..where((tbl) => tbl.id.equals(competence.id)))
        .write(
          CompetenceTableCompanion(
            name: Value(competence.name),
            competitionDate: Value(competence.competitionDate),
            isActive: Value(competence.isActive),
            isFinished: Value(competence.isFinished),
            updatedAt: Value(competence.updatedAt),
          ),
        );
  }
}
