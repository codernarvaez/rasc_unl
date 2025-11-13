import "package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart";



abstract class CompetitionRegistrationRepository {
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(String userDni);
  Future<void> updateNTurns(int id, int nTurns);
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(int competitionId);
  Future<void> createRegistration(CompetitionRegistrationModel registration);
  Future<void> deleteRegistration(int id);
  Future<List<CompetitionRegistrationModel>> getRegistrationsByCompetenceId(int competenceId);
  Future<List<CompetitionRegistrationModel>> getAllRegistrations();
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(String userDni, int competenceId);
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(String userDni);
  Future<void> updateRegistration(CompetitionRegistrationModel registration);
}
