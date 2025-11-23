import "package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart";

abstract class CompetenceRepository {
  Future<List<CompetenceModel>> getAllCompetences();
  Future<CompetenceModel?> getCompetenceById(int id);
  Future<void> createCompetence(CompetenceModel competence);
  Future<void> updateCompetence(CompetenceModel competence);
  Future<void> deleteCompetence(int id);
}