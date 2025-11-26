import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';

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

  Future<void> syncAll() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint('No internet connection. Skipping sync.');
      return;
    }

    try {
      await _syncCompetences();
      await _syncRegistrations();
      await _syncTimeRecords();
      debugPrint('Sync completed successfully.');
    } catch (e) {
      debugPrint('Error during sync: $e');
    }
  }

  Future<void> _syncCompetences() async {
    // 1. Push local changes
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
          lastSyncAt: DateTime.now(),
        );
        await _localCompetenceRepository.updateCompetence(syncedCompetence);
      } catch (e) {
        debugPrint('Error syncing competence ${competence.id}: $e');
      }
    }

    // 2. Pull remote changes
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

  Future<void> _syncRegistrations() async {
    // Push
    final localRegistrations = await _localRegistrationRepository
        .getAllRegistrations();
    final pendingRegistrations = localRegistrations
        .where((r) => r.syncStatus == 'pending')
        .toList();

    for (var reg in pendingRegistrations) {
      try {
        await _remoteRegistrationRepository.createRegistration(reg);

        final syncedReg = reg.copyWith(
          syncStatus: 'synced',
          lastSyncAt: DateTime.now(),
        );
        await _localRegistrationRepository.updateRegistration(syncedReg);
      } catch (e) {
        debugPrint('Error syncing registration ${reg.id}: $e');
      }
    }

    // Pull
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

  Future<void> _syncTimeRecords() async {
    // Push
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
                lastSyncAt: DateTime.now(),
              );
              await _localTimeRecordRepository.updateTimeRecord(syncedRecord);
            } catch (e) {
              debugPrint('Error syncing time record ${record.id}: $e');
            }
          }

          // Pull
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
