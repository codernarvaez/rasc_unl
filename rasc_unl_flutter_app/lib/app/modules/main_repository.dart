import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';

abstract class MainRepository {
  CompetenceRepository get competenceRepository;
  CompetitionRegistrationRepository get competitionRegistrationRepository;
  CompetitionTimeRecordRepository get competitionTimeRecordRepository;
  UserRepository get userRepository;
  AuthRepository get authRepository;
  
  Future<String> generateReport();
}
