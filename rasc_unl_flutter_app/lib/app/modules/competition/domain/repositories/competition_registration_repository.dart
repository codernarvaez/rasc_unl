import "package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart";

abstract class CompetitionRegistrationRepository {
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(
    String userDni,
  );
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(
    String competitionId,
  );
  Future<void> createRegistration(CompetitionRegistrationModel registration);
  Future<void> deleteRegistration(String id);
  Future<List<CompetitionRegistrationModel>> getRegistrationsByCompetenceId(
    String competenceId,
  );
  Future<List<CompetitionRegistrationModel>> getAllRegistrations();
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(
    String userDni,
    String competenceId,
  );
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(
    String userDni,
  );
  Future<void> updateRegistration(CompetitionRegistrationModel registration);
}
