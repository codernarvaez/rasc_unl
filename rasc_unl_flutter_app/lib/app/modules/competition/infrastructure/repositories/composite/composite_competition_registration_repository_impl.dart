import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class CompositeCompetitionRegistrationRepositoryImpl
    implements CompetitionRegistrationRepository {
  final CompetitionRegistrationRepository localRepository;
  final CompetitionRegistrationRepository remoteRepository;
  final bool isOffline;

  CompositeCompetitionRegistrationRepositoryImpl({
    required this.localRepository,
    required this.remoteRepository,
    required this.isOffline,
  });

  @override
  Future<List<CompetitionRegistrationModel>> getAllRegistrations() async {
    return localRepository.getAllRegistrations();
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(
    String userDni,
  ) async {
    return localRepository.getRegistrationByUserDni(userDni);
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(
    String competitionId,
  ) async {
    return localRepository.getRegistrationByCompetitionId(competitionId);
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(
    String userDni,
  ) async {
    return localRepository.getRegistrationsByUserDni(userDni);
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByCompetenceId(
    String competenceId,
  ) async {
    return localRepository.getRegistrationsByCompetenceId(competenceId);
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(
    String userDni,
    String competenceId,
  ) async {
    return localRepository.getRegistrationByUserAndCompetence(
      userDni,
      competenceId,
    );
  }

  @override
  Future<void> createRegistration(
    CompetitionRegistrationModel registration,
  ) async {
    final pendingRegistration = registration.copyWith(syncStatus: 'pending');
    await localRepository.createRegistration(pendingRegistration);

    if (!isOffline) {
      try {
        await remoteRepository.createRegistration(registration);
        final syncedRegistration = registration.copyWith(syncStatus: 'synced');
        await localRepository.updateRegistration(syncedRegistration);
      } catch (e) {
        logging.e('Failed to push registration to remote: $e');
      }
    }
  }

  @override
  Future<void> updateRegistration(
    CompetitionRegistrationModel registration,
  ) async {
    final pendingRegistration = registration.copyWith(syncStatus: 'pending');
    await localRepository.updateRegistration(pendingRegistration);

    if (!isOffline) {
      try {
        await remoteRepository.updateRegistration(registration);
        final syncedRegistration = registration.copyWith(syncStatus: 'synced');
        await localRepository.updateRegistration(syncedRegistration);
      } catch (e) {
        logging.e('Failed to push registration update to remote: $e');
      }
    }
  }

  @override
  Future<void> deleteRegistration(String id) async {
    // Fetch first to check existence and get data for soft delete
    // Note: getRegistrationById is not in the interface I saw earlier, checking interface again...
    // The interface has: getAll, getByCompetence, getByUserAndCompetence, create, update, delete.
    // It seems missing getById. I will assume I can't easily get it by ID unless I iterate.
    // However, delete usually takes ID.
    // For soft delete, we need to update. If we can't get by ID, we might need to rely on the fact that
    // the caller might have the object, or we implement getById in local repo if needed.
    // Let's check if getById exists in the interface.
    // If not, I'll use a workaround or assume hard delete in local + remote delete call.
    // BUT, offline-first requires soft delete to sync the deletion.

    // Let's assume for now we do a hard delete in local if we can't update it easily,
    // OR we fetch all and find it.

    final all = await localRepository.getAllRegistrations();
    final registration = all.where((r) => r.id == id).firstOrNull;

    if (registration != null) {
      final deletedRegistration = registration.copyWith(
        isDeleted: true,
        syncStatus: 'pending',
      );
      await localRepository.updateRegistration(deletedRegistration);

      if (!isOffline) {
        try {
          await remoteRepository.deleteRegistration(id);
          final syncedDeleted = deletedRegistration.copyWith(
            syncStatus: 'synced',
          );
          await localRepository.updateRegistration(syncedDeleted);
        } catch (e) {
          logging.e('Failed to push registration delete to remote: $e');
        }
      }
    }
  }
}
