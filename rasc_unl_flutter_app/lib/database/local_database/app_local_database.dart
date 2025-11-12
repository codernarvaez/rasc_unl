import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/drift_models/user_drift_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/drift_models/competence_drift_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/drift_models/competition_registration_drift_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'connection/connection.dart';

part 'app_local_database.g.dart';

@DriftDatabase(
  tables: [UserTable, CompetenceTable, CompetitionRegistrationTable],
  include: {
    'queries/functions.drift',
    'queries/indexs.drift',
    'queries/triggers.drift',
  },
)
class AppLocalDatabase extends _$AppLocalDatabase {
  AppLocalDatabase([QueryExecutor? e])
      : super(
          e ??
              driftDatabase(
                name: 'local_database',
                native: DriftNativeOptions(
                  databaseDirectory: () async =>
                      await getApplicationSupportDirectory(), // 👈 aquí está el fix
                ),
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                  onResult: (result) {
                    if (result.missingFeatures.isNotEmpty) {
                      logging.i('Fallback por features faltantes');
                    }
                  },
                ),
              ),
        );

  AppLocalDatabase.forTesting(DatabaseConnection super.connection);

  @override
  int get schemaVersion => 1;
}
