import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/remote/remote_auth_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';

class RemoteRepository implements MainRepository {
  @override
  CompetenceRepository get competenceRepository => throw UnimplementedError();

  @override
  CompetitionRegistrationRepository get competitionRegistrationRepository => throw UnimplementedError();

  @override
  UserRepository get userRepository => throw UnimplementedError();

  @override
  AuthRepository get authRepository => RemoteAuthRepositoryImpl();

  @override
  Future<String> generateReport() async {
    // Implementación para generar reportes en modo online
    return 'Reporte generado remotamente.';
  }
}