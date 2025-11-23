import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/drift_models/user_drift_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/drift_models/session_drift_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/drift_models/competence_drift_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/drift_models/competition_registration_drift_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/drift_models/time_record_drift_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'connection/connection.dart';

part 'app_local_database.g.dart';

@DriftDatabase(
  tables: [UserTable, SessionTable, CompetenceTable, CompetitionRegistrationTable, CompetitionTimeRecordTable],
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

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Migración de versión 1 a 2: agregar tabla de sesiones y campos de sincronización
        if (from < 2) {
          // Drift manejará automáticamente la creación de nuevas columnas y tablas
          // Al regenerar el código con build_runner
        }
      },
      beforeOpen: (details) async {
        // Habilitar claves foráneas
        await customStatement('PRAGMA foreign_keys = ON');
        
        // Verificar que la migración fue exitosa
        if (details.hadUpgrade) {
          logging.i('Base de datos migrada desde ${details.versionBefore} a ${details.versionNow}');
        }
        
        if (details.wasCreated) {
          logging.i('Base de datos creada por primera vez');
        }
      },
    );
  }
}
