import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetitionRegistrationRepositoryImpl
    implements CompetitionRegistrationRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetitionRegistrationRepositoryImpl(this._localDatabase);

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(
    String userDni,
  ) async {
    final queryResult = await (_localDatabase.select(
      _localDatabase.competitionRegistrationTable,
    )..where((tbl) => tbl.userDni.equals(userDni))).getSingleOrNull();
    if (queryResult != null) {
      return CompetitionRegistrationModel(
        id: queryResult.id,
        dorsalNumber: queryResult.dorsalNumber,
        nParticipants: queryResult.nParticipants,
        name: queryResult.name,
        userDni: queryResult.userDni,
        competenceId: queryResult.competenceId,
        createdAt: queryResult.createdAt,
        updatedAt: queryResult.updatedAt,
        syncStatus: queryResult.syncStatus,
        lastSyncAt: queryResult.lastSyncAt,
        version: queryResult.version,
        deviceId: queryResult.deviceId,
        isDeleted: queryResult.isDeleted,
      );
    }
    return null;
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(
    String competitionId,
  ) async {
    final queryResult =
        await (_localDatabase.select(
              _localDatabase.competitionRegistrationTable,
            )..where((tbl) => tbl.competenceId.equals(competitionId)))
            .getSingleOrNull();
    if (queryResult != null) {
      return CompetitionRegistrationModel(
        id: queryResult.id,
        dorsalNumber: queryResult.dorsalNumber,
        nParticipants: queryResult.nParticipants,
        name: queryResult.name,
        userDni: queryResult.userDni,
        competenceId: queryResult.competenceId,
        createdAt: queryResult.createdAt,
        updatedAt: queryResult.updatedAt,
        syncStatus: queryResult.syncStatus,
        lastSyncAt: queryResult.lastSyncAt,
        version: queryResult.version,
        deviceId: queryResult.deviceId,
        isDeleted: queryResult.isDeleted,
      );
    }
    return null;
  }

  @override
  Future<void> createRegistration(
    CompetitionRegistrationModel registration,
  ) async {
    await _localDatabase
        .into(_localDatabase.competitionRegistrationTable)
        .insert(
          CompetitionRegistrationTableCompanion.insert(
            id: registration.id,
            dorsalNumber: registration.dorsalNumber,
            nParticipants: registration.nParticipants,
            name: registration.name,
            userDni: registration.userDni,
            competenceId: registration.competenceId,
            createdAt: registration.createdAt,
            updatedAt: Value(registration.updatedAt),
            syncStatus: Value(registration.syncStatus),
            lastSyncAt: Value(registration.lastSyncAt),
            version: Value(registration.version),
            deviceId: Value(registration.deviceId),
            isDeleted: Value(registration.isDeleted),
          ),
        );
  }

  @override
  Future<void> deleteRegistration(String id) async {
    await (_localDatabase.delete(
      _localDatabase.competitionRegistrationTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByCompetenceId(
    String competenceId,
  ) async {
    final queryResults = await (_localDatabase.select(
      _localDatabase.competitionRegistrationTable,
    )..where((tbl) => tbl.competenceId.equals(competenceId))).get();

    return queryResults
        .map(
          (result) => CompetitionRegistrationModel(
            id: result.id,
            dorsalNumber: result.dorsalNumber,
            nParticipants: result.nParticipants,
            name: result.name,
            userDni: result.userDni,
            competenceId: result.competenceId,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt,
            syncStatus: result.syncStatus,
            lastSyncAt: result.lastSyncAt,
            version: result.version,
            deviceId: result.deviceId,
            isDeleted: result.isDeleted,
          ),
        )
        .toList();
  }

  @override
  Future<List<CompetitionRegistrationModel>> getAllRegistrations() async {
    final queryResults = await _localDatabase
        .select(_localDatabase.competitionRegistrationTable)
        .get();

    return queryResults
        .map(
          (result) => CompetitionRegistrationModel(
            id: result.id,
            dorsalNumber: result.dorsalNumber,
            nParticipants: result.nParticipants,
            name: result.name,
            userDni: result.userDni,
            competenceId: result.competenceId,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt,
            syncStatus: result.syncStatus,
            lastSyncAt: result.lastSyncAt,
            version: result.version,
            deviceId: result.deviceId,
            isDeleted: result.isDeleted,
          ),
        )
        .toList();
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(
    String userDni,
    String competenceId,
  ) async {
    final queryResult =
        await (_localDatabase.select(
              _localDatabase.competitionRegistrationTable,
            )..where(
              (tbl) =>
                  tbl.userDni.equals(userDni) &
                  tbl.competenceId.equals(competenceId),
            ))
            .getSingleOrNull();
    if (queryResult != null) {
      return CompetitionRegistrationModel(
        id: queryResult.id,
        dorsalNumber: queryResult.dorsalNumber,
        nParticipants: queryResult.nParticipants,
        name: queryResult.name,
        userDni: queryResult.userDni,
        competenceId: queryResult.competenceId,
        createdAt: queryResult.createdAt,
        updatedAt: queryResult.updatedAt,
        syncStatus: queryResult.syncStatus,
        lastSyncAt: queryResult.lastSyncAt,
        version: queryResult.version,
        deviceId: queryResult.deviceId,
        isDeleted: queryResult.isDeleted,
      );
    }
    return null;
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(
    String userDni,
  ) async {
    final queryResults = await (_localDatabase.select(
      _localDatabase.competitionRegistrationTable,
    )..where((tbl) => tbl.userDni.equals(userDni))).get();

    return queryResults
        .map(
          (result) => CompetitionRegistrationModel(
            id: result.id,
            dorsalNumber: result.dorsalNumber,
            nParticipants: result.nParticipants,
            name: result.name,
            userDni: result.userDni,
            competenceId: result.competenceId,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt,
            syncStatus: result.syncStatus,
            lastSyncAt: result.lastSyncAt,
            version: result.version,
            deviceId: result.deviceId,
            isDeleted: result.isDeleted,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateRegistration(
    CompetitionRegistrationModel registration,
  ) async {
    await (_localDatabase.update(
      _localDatabase.competitionRegistrationTable,
    )..where((tbl) => tbl.id.equals(registration.id))).write(
      CompetitionRegistrationTableCompanion(
        dorsalNumber: Value(registration.dorsalNumber),
        nParticipants: Value(registration.nParticipants),
        name: Value(registration.name),
        updatedAt: Value(registration.updatedAt),
        syncStatus: Value(registration.syncStatus),
        lastSyncAt: Value(registration.lastSyncAt),
        version: Value(registration.version),
        deviceId: Value(registration.deviceId),
        isDeleted: Value(registration.isDeleted),
      ),
    );
  }
}
