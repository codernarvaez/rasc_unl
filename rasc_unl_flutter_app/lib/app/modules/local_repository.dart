import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/local_auth_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/local_user_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/local/local_competition_registration_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/local/local_competition_time_record_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/local/local_competence_repository_impl.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';

class LocalRepository implements MainRepository {
  final AppLocalDatabase db;

  LocalRepository(this.db);

  @override
  CompetenceRepository get competenceRepository => LocalCompetenceRepositoryImpl(db);

  @override
  CompetitionRegistrationRepository get competitionRegistrationRepository => LocalCompetitionRegistrationRepositoryImpl(db);

  @override
  CompetitionTimeRecordRepository get competitionTimeRecordRepository => LocalCompetitionTimeRecordRepositoryImpl(db);

  @override
  UserRepository get userRepository => LocalUserRepositoryImpl(db);

  @override
  AuthRepository get authRepository => LocalAuthRepositoryImpl(db);

  @override
  Future<String> generateReport() async {
    // Implementación para generar reportes en modo offline
    return 'Reporte generado localmente.';
  }

}
