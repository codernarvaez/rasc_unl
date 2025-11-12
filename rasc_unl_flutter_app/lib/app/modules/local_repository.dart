import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';

import 'package:rasc_unl_flutter_app/app/modules/home/infrastructure/repositories/local/competence_repository_impl.dart';

import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalRepository implements MainRepository {
  final AppLocalDatabase db;

  LocalRepository(this.db);

  @override
  CompetenceRepository get competenceRepository => CompetenceRepositoryImpl(db);

  @override
  CompetitionRegistrationRepository get competitionRegistrationRepository => throw UnimplementedError();


}
