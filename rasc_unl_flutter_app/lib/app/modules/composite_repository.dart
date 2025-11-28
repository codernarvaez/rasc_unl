import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/composite/composite_competence_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/composite/composite_competition_registration_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/composite/composite_competition_time_record_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/infrastructure/repositories/composite/composite_user_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';

class CompositeRepository implements MainRepository {
  final MainRepository local;
  final MainRepository remote;
  final bool isOffline;
  final String? accessToken;

  CompositeRepository({
    required this.local,
    required this.remote,
    required this.isOffline,
    this.accessToken,
  });

  @override
  CompetenceRepository get competenceRepository =>
      CompositeCompetenceRepositoryImpl(
        localRepository: local.competenceRepository,
        remoteRepository: remote.competenceRepository,
        isOffline: isOffline,
      );

  @override
  CompetitionRegistrationRepository get competitionRegistrationRepository =>
      CompositeCompetitionRegistrationRepositoryImpl(
        localRepository: local.competitionRegistrationRepository,
        remoteRepository: remote.competitionRegistrationRepository,
        isOffline: isOffline,
      );

  @override
  CompetitionTimeRecordRepository get competitionTimeRecordRepository =>
      CompositeCompetitionTimeRecordRepositoryImpl(
        localRepository: local.competitionTimeRecordRepository,
        remoteRepository: remote.competitionTimeRecordRepository,
        isOffline: isOffline,
      );

  @override
  UserRepository get userRepository => CompositeUserRepositoryImpl(
    localRepository: local.userRepository,
    remoteRepository: remote.userRepository,
    isOffline: isOffline,
    accessToken: accessToken,
  );

  @override
  AuthRepository get authRepository =>
      isOffline ? local.authRepository : remote.authRepository;

  @override
  Future<String> generateReport() async {
    return 'Reporte generado desde repositorio compuesto.';
  }
}
