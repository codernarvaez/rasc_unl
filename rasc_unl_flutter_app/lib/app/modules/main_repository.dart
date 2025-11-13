import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';

abstract class MainRepository {
  CompetenceRepository get competenceRepository;
  CompetitionRegistrationRepository get competitionRegistrationRepository;
  UserRepository get userRepository;

  Future<String> generateReport();
}
