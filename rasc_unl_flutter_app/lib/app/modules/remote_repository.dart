import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/remote/remote_auth_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/remote/remote_user_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/infrastructure/repositories/remote/remote_competence_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/infrastructure/repositories/remote/remote_competition_registration_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';

class RemoteRepository implements MainRepository {
  final String? accessToken;

  RemoteRepository({this.accessToken});

  @override
  CompetenceRepository get competenceRepository =>
      RemoteCompetenceRepositoryImpl(accessToken: accessToken);

  @override
  CompetitionRegistrationRepository get competitionRegistrationRepository =>
      RemoteCompetitionRegistrationRepositoryImpl(accessToken: accessToken);

  @override
  UserRepository get userRepository =>
      RemoteUserRepositoryImpl(accessToken: accessToken);

  @override
  AuthRepository get authRepository => RemoteAuthRepositoryImpl();

  @override
  Future<String> generateReport() async {
    // Implementación para generar reportes en modo online
    return 'Reporte generado remotamente.';
  }
}