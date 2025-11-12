import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';

class RemoteRepository implements MainRepository {
  @override
  CompetenceRepository get competenceRepository => throw UnimplementedError();

  @override
  CompetitionRegistrationRepository get competitionRegistrationRepository => throw UnimplementedError();
}