import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/infrastructure/repositories/remote/remote_sync_repository_impl.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

enum SyncStatus { syncing, synced, error, pending }

class SyncService {
  final CompetenceRepository _localCompetenceRepository;
  final CompetitionRegistrationRepository _localRegistrationRepository;
  final CompetitionTimeRecordRepository _localTimeRecordRepository;
  final RemoteSyncRepository _remoteSyncRepository;

  SyncService({
    required CompetenceRepository localCompetenceRepository,
    required CompetitionRegistrationRepository localRegistrationRepository,
    required CompetitionTimeRecordRepository localTimeRecordRepository,
    required RemoteSyncRepository remoteSyncRepository,
  }) : _localCompetenceRepository = localCompetenceRepository,
       _localRegistrationRepository = localRegistrationRepository,
       _localTimeRecordRepository = localTimeRecordRepository,
       _remoteSyncRepository = remoteSyncRepository;

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
    try {
      // 1. Collect pending items
      final competences = await _localCompetenceRepository.getAllCompetences();
      final pendingCompetences = competences
          .where((c) => c.syncStatus == 'pending')
          .toList();

      final registrations = await _localRegistrationRepository
          .getAllRegistrations();
      final pendingRegistrations = registrations
          .where((r) => r.syncStatus == 'pending')
          .toList();

      // For time records, we need to iterate through registrations to find them
      final allTimeRecords = <TimeRecordModel>[];
      for (var comp in competences) {
        final regs = await _localRegistrationRepository
            .getRegistrationsByCompetenceId(comp.id);
        for (var reg in regs) {
          final records = await _localTimeRecordRepository
              .getTimeRecordsByRegistrationId(reg.id);
          allTimeRecords.addAll(
            records.where((r) => r.syncStatus == 'pending'),
          );
        }
      }

      if (pendingCompetences.isEmpty &&
          pendingRegistrations.isEmpty &&
          allTimeRecords.isEmpty) {
        debugPrint('Nothing to push.');
        return;
      }

      // 2. Create Push Request
      final pushRequest = SyncPushRequest(
        competences: pendingCompetences,
        registrations: pendingRegistrations,
        timeRecords: allTimeRecords,
      );

      // 3. Send to Server
      await _remoteSyncRepository.pushSyncData(pushRequest);

      // 4. Update local status to synced
      for (var c in pendingCompetences) {
        await _localCompetenceRepository.updateCompetence(
          c.copyWith(syncStatus: 'synced', lastSyncAt: utcNow()),
        );
      }

      for (var r in pendingRegistrations) {
        await _localRegistrationRepository.updateRegistration(
          r.copyWith(syncStatus: 'synced', lastSyncAt: utcNow()),
        );
      }

      for (var t in allTimeRecords) {
        await _localTimeRecordRepository.updateTimeRecord(
          t.copyWith(syncStatus: 'synced', lastSyncAt: utcNow()),
        );
      }

      debugPrint('Push completed successfully.');
    } catch (e) {
      debugPrint('Error during syncUp: $e');
      rethrow;
    }
  }

  Future<void> syncDown() async {
    try {
      // 1. Pull data from server
      final response = await _remoteSyncRepository.pullSyncData();

      // 2. Process Competences
      for (var remoteComp in response.competences) {
        final localComp = await _localCompetenceRepository.getCompetenceById(
          remoteComp.id,
        );
        if (localComp == null) {
          await _localCompetenceRepository.createCompetence(
            remoteComp.copyWith(syncStatus: 'synced'),
          );
        } else {
          // HIGHEST VERSION WINS
          if (remoteComp.version > localComp.version) {
            await _localCompetenceRepository.updateCompetence(
              remoteComp.copyWith(syncStatus: 'synced'),
            );
          }
        }
      }

      // 3. Process Registrations
      for (var remoteReg in response.registrations) {
        final localRegs = await _localRegistrationRepository
            .getRegistrationsByCompetenceId(remoteReg.competenceId);
        final localReg = localRegs
            .cast<CompetitionRegistrationModel?>()
            .firstWhere((r) => r?.id == remoteReg.id, orElse: () => null);

        if (localReg == null) {
          await _localRegistrationRepository.createRegistration(
            remoteReg.copyWith(syncStatus: 'synced'),
          );
        } else {
          if (remoteReg.version > localReg.version) {
            await _localRegistrationRepository.updateRegistration(
              remoteReg.copyWith(syncStatus: 'synced'),
            );
          }
        }
      }

      // 4. Process Time Records
      for (var remoteTR in response.timeRecords) {
        final localTR = await _localTimeRecordRepository.getTimeRecordById(
          remoteTR.id,
        );
        if (localTR == null) {
          await _localTimeRecordRepository.createTimeRecord(
            remoteTR.copyWith(syncStatus: 'synced'),
          );
        } else {
          if (remoteTR.version > localTR.version) {
            await _localTimeRecordRepository.updateTimeRecord(
              remoteTR.copyWith(syncStatus: 'synced'),
            );
          }
        }
      }

      debugPrint('Pull completed successfully.');
    } catch (e) {
      debugPrint('Error during syncDown: $e');
      rethrow;
    }
  }
}
