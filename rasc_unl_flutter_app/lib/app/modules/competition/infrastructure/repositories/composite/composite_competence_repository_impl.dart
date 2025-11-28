import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class CompositeCompetenceRepositoryImpl implements CompetenceRepository {
  final CompetenceRepository localRepository;
  final CompetenceRepository remoteRepository;
  final bool isOffline;

  CompositeCompetenceRepositoryImpl({
    required this.localRepository,
    required this.remoteRepository,
    required this.isOffline,
  });

  @override
  Future<List<CompetenceModel>> getAllCompetences() async {
    // Always read from local
    return localRepository.getAllCompetences();
  }

  @override
  Future<CompetenceModel?> getCompetenceById(String id) async {
    // Always read from local
    return localRepository.getCompetenceById(id);
  }

  @override
  Future<void> createCompetence(CompetenceModel competence) async {
    // 1. Save to local (marked as pending sync by default or explicitly handled here)
    // Assuming the model passed in has syncStatus = 'pending' or we set it.
    // Ideally, the UI/Business logic sets it to 'pending'.

    // Ensure syncStatus is pending
    final pendingCompetence = competence.copyWith(syncStatus: 'pending');
    await localRepository.createCompetence(pendingCompetence);

    // 2. If online, try to push to remote immediately
    if (!isOffline) {
      try {
        await remoteRepository.createCompetence(competence);
        // If successful, update local to synced
        final syncedCompetence = competence.copyWith(syncStatus: 'synced');
        await localRepository.updateCompetence(syncedCompetence);
      } catch (e) {
        logging.e('Failed to push competence to remote: $e');
        // Ignore error, SyncService will handle it later
      }
    }
  }

  @override
  Future<void> updateCompetence(CompetenceModel competence) async {
    // 1. Update local (mark as pending)
    final pendingCompetence = competence.copyWith(syncStatus: 'pending');
    await localRepository.updateCompetence(pendingCompetence);

    // 2. If online, try to push to remote
    if (!isOffline) {
      try {
        await remoteRepository.updateCompetence(competence);
        // If successful, update local to synced
        final syncedCompetence = competence.copyWith(syncStatus: 'synced');
        await localRepository.updateCompetence(syncedCompetence);
      } catch (e) {
        logging.e('Failed to push update to remote: $e');
      }
    }
  }

  @override
  Future<void> deleteCompetence(String id) async {
    // 1. Mark as deleted in local (soft delete usually, but repository interface says delete)
    // If it's a hard delete in local, we might lose the info needed to delete in remote.
    // Typically we use soft deletes (isDeleted = true).
    // Let's assume the repository handles soft delete logic or we need to fetch, update isDeleted, and save.

    // Fetch first to check existence
    final competence = await localRepository.getCompetenceById(id);
    if (competence == null) return;

    // Soft delete locally
    final deletedCompetence = competence.copyWith(
      isDeleted: true,
      syncStatus: 'pending',
    );
    await localRepository.updateCompetence(deletedCompetence);

    // 2. If online, try to push delete to remote
    if (!isOffline) {
      try {
        await remoteRepository.deleteCompetence(id);
        // If successful, we can either keep it as soft deleted synced, or hard delete locally if that's the policy.
        // Usually we keep it soft deleted.
        final syncedDeleted = deletedCompetence.copyWith(syncStatus: 'synced');
        await localRepository.updateCompetence(syncedDeleted);
      } catch (e) {
        logging.e('Failed to push delete to remote: $e');
      }
    }
  }
}
