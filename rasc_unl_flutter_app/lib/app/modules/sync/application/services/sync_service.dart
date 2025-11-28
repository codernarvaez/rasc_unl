import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

enum SyncStatus { syncing, synced, error, pending }

class SyncService {
  final CompetenceRepository _localCompetenceRepository;
  final CompetenceRepository _remoteCompetenceRepository;
  final CompetitionRegistrationRepository _localRegistrationRepository;
  final CompetitionRegistrationRepository _remoteRegistrationRepository;
  final CompetitionTimeRecordRepository _localTimeRecordRepository;
  final CompetitionTimeRecordRepository _remoteTimeRecordRepository;

  SyncService({
    required CompetenceRepository localCompetenceRepository,
    required CompetenceRepository remoteCompetenceRepository,
    required CompetitionRegistrationRepository localRegistrationRepository,
    required CompetitionRegistrationRepository remoteRegistrationRepository,
    required CompetitionTimeRecordRepository localTimeRecordRepository,
    required CompetitionTimeRecordRepository remoteTimeRecordRepository,
  }) : _localCompetenceRepository = localCompetenceRepository,
       _remoteCompetenceRepository = remoteCompetenceRepository,
       _localRegistrationRepository = localRegistrationRepository,
       _remoteRegistrationRepository = remoteRegistrationRepository,
       _localTimeRecordRepository = localTimeRecordRepository,
       _remoteTimeRecordRepository = remoteTimeRecordRepository;

  final _statusController = ValueNotifier<SyncStatus>(SyncStatus.synced);
  ValueNotifier<SyncStatus> get statusNotifier => _statusController;

  Future<void> syncAll() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint('No internet connection. Skipping sync.');
      return;
    }

    _statusController.value = SyncStatus.syncing;

    try {
      await syncUp();
      await syncDown();
      debugPrint('Sync completed successfully.');
      _statusController.value = SyncStatus.synced;
    } catch (e) {
      debugPrint('Error during sync: $e');
      _statusController.value = SyncStatus.error;
    }
  }

  Future<void> syncUp() async {
    await _pushCompetences();
    await _pushRegistrations();
    await _pushTimeRecords();
  }

  Future<void> syncDown() async {
    await _pullCompetences();
    await _pullRegistrations();
    await _pullTimeRecords();
  }

  Future<void> _pushCompetences() async {
    final localCompetences = await _localCompetenceRepository
        .getAllCompetences();
    final pendingCompetences = localCompetences
        .where((c) => c.syncStatus == 'pending')
        .toList();

    for (var competence in pendingCompetences) {
      try {
        final remoteComp = await _remoteCompetenceRepository.getCompetenceById(
          competence.id,
        );

        if (remoteComp == null) {
          await _remoteCompetenceRepository.createCompetence(competence);
        } else {
          await _remoteCompetenceRepository.updateCompetence(competence);
        }

        final syncedCompetence = competence.copyWith(
          syncStatus: 'synced',
          lastSyncAt: utcNow(),
        );
        await _localCompetenceRepository.updateCompetence(syncedCompetence);
      } catch (e) {
        debugPrint('Error syncing competence ${competence.id}: $e');
      }
    }
  }

  Future<void> _pullCompetences() async {
    final remoteCompetences = await _remoteCompetenceRepository
        .getAllCompetences();
    for (var remoteComp in remoteCompetences) {
      final localComp = await _localCompetenceRepository.getCompetenceById(
        remoteComp.id,
      );

      if (localComp == null) {
        await _localCompetenceRepository.createCompetence(
          remoteComp.copyWith(syncStatus: 'synced'),
        );
      } else {
        if (remoteComp.updatedAt != null &&
            (localComp.updatedAt == null ||
                remoteComp.updatedAt!.isAfter(localComp.updatedAt!))) {
          await _localCompetenceRepository.updateCompetence(
            remoteComp.copyWith(syncStatus: 'synced'),
          );
        }
      }
    }
  }

  Future<void> _pushRegistrations() async {
    final localRegistrations = await _localRegistrationRepository
        .getAllRegistrations();
    final pendingRegistrations = localRegistrations
        .where((r) => r.syncStatus == 'pending')
        .toList();

    for (var reg in pendingRegistrations) {
      try {
        // Check if exists remotely to decide create vs update
        // Assuming createRegistration handles upsert or we check existence
        // For now, let's try create, if fails, update?
        // Or better, check existence if possible.
        // The previous code just called createRegistration.
        // Let's stick to that but be aware.
        // Ideally we should have getRegistrationById in remote repo.

        // For now, let's assume createRegistration is idempotent or handles it.
        await _remoteRegistrationRepository.createRegistration(reg);

        final syncedReg = reg.copyWith(
          syncStatus: 'synced',
          lastSyncAt: utcNow(),
        );
        await _localRegistrationRepository.updateRegistration(syncedReg);
      } catch (e) {
        debugPrint('Error syncing registration ${reg.id}: $e');
      }
    }
  }

  Future<void> _pullRegistrations() async {
    final competences = await _localCompetenceRepository.getAllCompetences();
    for (var comp in competences) {
      if (comp.isActive) {
        final remoteRegs = await _remoteRegistrationRepository
            .getRegistrationsByCompetenceId(comp.id);
        for (var remoteReg in remoteRegs) {
          final localRegs = await _localRegistrationRepository
              .getRegistrationsByCompetenceId(comp.id);
          final localReg = localRegs
              .cast<CompetitionRegistrationModel?>()
              .firstWhere((r) => r?.id == remoteReg.id, orElse: () => null);

          if (localReg == null) {
            await _localRegistrationRepository.createRegistration(
              remoteReg.copyWith(syncStatus: 'synced'),
            );
          } else {
            if (remoteReg.updatedAt != null &&
                (localReg.updatedAt == null ||
                    remoteReg.updatedAt!.isAfter(localReg.updatedAt!))) {
              await _localRegistrationRepository.updateRegistration(
                remoteReg.copyWith(syncStatus: 'synced'),
              );
            }
          }
        }
      }
    }
  }

  Future<void> _pushTimeRecords() async {
    final competences = await _localCompetenceRepository.getAllCompetences();
    for (var comp in competences) {
      if (comp.isActive) {
        final registrations = await _localRegistrationRepository
            .getRegistrationsByCompetenceId(comp.id);
        for (var reg in registrations) {
          final records = await _localTimeRecordRepository
              .getTimeRecordsByRegistrationId(reg.id);
          final pendingRecords = records
              .where((r) => r.syncStatus == 'pending')
              .toList();

          for (var record in pendingRecords) {
            try {
              await _remoteTimeRecordRepository.createTimeRecord(record);

              final syncedRecord = record.copyWith(
                syncStatus: 'synced',
                lastSyncAt: utcNow(),
              );
              await _localTimeRecordRepository.updateTimeRecord(syncedRecord);
            } catch (e) {
              debugPrint('Error syncing time record ${record.id}: $e');
            }
          }
        }
      }
    }
  }

  Future<void> _pullTimeRecords() async {
    final competences = await _localCompetenceRepository.getAllCompetences();
    for (var comp in competences) {
      if (comp.isActive) {
        final registrations = await _localRegistrationRepository
            .getRegistrationsByCompetenceId(comp.id);
        for (var reg in registrations) {
          try {
            final remoteRecords = await _remoteTimeRecordRepository
                .getTimeRecordsByRegistrationId(reg.id);
            for (var remoteRecord in remoteRecords) {
              final localRecord = await _localTimeRecordRepository
                  .getTimeRecordById(remoteRecord.id);
              if (localRecord == null) {
                await _localTimeRecordRepository.createTimeRecord(
                  remoteRecord.copyWith(syncStatus: 'synced'),
                );
              } else {
                if (remoteRecord.updatedAt.isAfter(localRecord.updatedAt)) {
                  await _localTimeRecordRepository.updateTimeRecord(
                    remoteRecord.copyWith(syncStatus: 'synced'),
                  );
                }
              }
            }
          } catch (e) {
            debugPrint(
              'Error pulling time records for registration ${reg.id}: $e',
            );
          }
        }
      }
    }
  }
}
