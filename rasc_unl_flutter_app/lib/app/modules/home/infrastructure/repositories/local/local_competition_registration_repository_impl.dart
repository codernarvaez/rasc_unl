import 'package:drift/drift.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalCompetitionRegistrationRepositoryImpl implements CompetitionRegistrationRepository {
  final AppLocalDatabase _localDatabase;

  LocalCompetitionRegistrationRepositoryImpl(this._localDatabase);

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(String userDni) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.userDni.equals(userDni)))
        .getSingleOrNull();
    if (queryResult != null) {
      return CompetitionRegistrationModel(
        id: queryResult.id,
        userDni: queryResult.userDni,
        competenceId: queryResult.competenceId,
        registrationNumber: queryResult.registrationNumber,
        externalId: queryResult.externalId,
        nTurns: queryResult.nTurns,
        time: queryResult.time != null ? Duration(milliseconds: queryResult.time!) : null,
      );
    }
    return null;
  }

  @override
  Future<void> updateNTurns(int id, int nTurns) async {
    await (_localDatabase.update(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(CompetitionRegistrationTableCompanion(
          nTurns: Value(nTurns),
        ));
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(int competitionId) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.competenceId.equals(competitionId)))
        .getSingleOrNull();
    if (queryResult != null) {
      return CompetitionRegistrationModel(
        id: queryResult.id,
        userDni: queryResult.userDni,
        competenceId: queryResult.competenceId,
        registrationNumber: queryResult.registrationNumber,
        externalId: queryResult.externalId,
        nTurns: queryResult.nTurns,
        time: queryResult.time != null ? Duration(milliseconds: queryResult.time!) : null,
      );
    }
    return null;
  }

  @override
  Future<void> createRegistration(CompetitionRegistrationModel registration) async {
    await _localDatabase.into(_localDatabase.competitionRegistrationTable).insert(
          CompetitionRegistrationTableCompanion.insert(
            userDni: registration.userDni,
            competenceId: registration.competenceId,
            registrationNumber: Value(registration.registrationNumber),
            externalId: Value(registration.externalId),
            nTurns: Value(registration.nTurns),
            time: Value(registration.time?.inMilliseconds),
          ),
        );
  }

  @override
  Future<void> deleteRegistration(int id) async {
    await (_localDatabase.delete(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByCompetenceId(int competenceId) async {
    final queryResults = await (_localDatabase.select(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.competenceId.equals(competenceId)))
        .get();

    return queryResults.map((result) => CompetitionRegistrationModel(
      id: result.id,
      userDni: result.userDni,
      competenceId: result.competenceId,
      registrationNumber: result.registrationNumber,
      externalId: result.externalId,
      nTurns: result.nTurns,
      time: result.time != null ? Duration(milliseconds: result.time!) : null,
    )).toList();
  }

  @override
  Future<List<CompetitionRegistrationModel>> getAllRegistrations() async {
    final queryResults = await _localDatabase.select(_localDatabase.competitionRegistrationTable).get();

    return queryResults.map((result) => CompetitionRegistrationModel(
      id: result.id,
      userDni: result.userDni,
      competenceId: result.competenceId,
      registrationNumber: result.registrationNumber,
      externalId: result.externalId,
      nTurns: result.nTurns,
      time: result.time != null ? Duration(milliseconds: result.time!) : null,
    )).toList();
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(String userDni, int competenceId) async {
    final queryResult = await (_localDatabase.select(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.userDni.equals(userDni) & tbl.competenceId.equals(competenceId)))
        .getSingleOrNull();
    if (queryResult != null) {
      return CompetitionRegistrationModel(
        id: queryResult.id,
        userDni: queryResult.userDni,
        competenceId: queryResult.competenceId,
        registrationNumber: queryResult.registrationNumber,
        externalId: queryResult.externalId,
        nTurns: queryResult.nTurns,
        time: queryResult.time != null ? Duration(milliseconds: queryResult.time!) : null,
      );
    }
    return null;
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(String userDni) async {
    final queryResults = await (_localDatabase.select(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.userDni.equals(userDni)))
        .get();

    return queryResults.map((result) => CompetitionRegistrationModel(
      id: result.id,
      userDni: result.userDni,
      competenceId: result.competenceId,
      registrationNumber: result.registrationNumber,
      externalId: result.externalId,
      nTurns: result.nTurns,
      time: result.time != null ? Duration(milliseconds: result.time!) : null,
    )).toList();
  }

  @override
  Future<void> updateRegistration(CompetitionRegistrationModel registration) async {
    await (_localDatabase.update(_localDatabase.competitionRegistrationTable)
          ..where((tbl) => tbl.id.equals(registration.id)))
        .write(CompetitionRegistrationTableCompanion(
          externalId: registration.externalId != null 
              ? Value(registration.externalId) 
              : const Value.absent(),
          registrationNumber: registration.registrationNumber != null 
              ? Value(registration.registrationNumber) 
              : const Value.absent(),
          time: registration.time != null 
              ? Value(registration.time!.inMilliseconds) 
              : const Value.absent(),
          nTurns: registration.nTurns != null 
              ? Value(registration.nTurns) 
              : const Value.absent(),
        ));
  }
}
