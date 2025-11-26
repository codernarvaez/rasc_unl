import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/local_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/remote_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/application/services/sync_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final logging = Logger(
  level: kReleaseMode ? Level.nothing : Level.debug,
  printer: PrettyPrinter(), // opcional, puedes cambiarlo por SimplePrinter()
);

final connectionStatusProvider = StreamProvider<InternetConnectionStatus>((
  ref,
) async* {
  final checker = InternetConnectionChecker.createInstance();
  yield* checker.onStatusChange;
});

final isOfflineModeProvider = Provider<bool>((ref) {
  final connection = ref.watch(connectionStatusProvider).value;
  return connection == InternetConnectionStatus.disconnected;
});

// Provider para el usuario actual logueado
class CurrentUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserModel?>(
  () => CurrentUserNotifier(),
);

// Notifier for access token management
class AccessTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setToken(String? token) {
    state = token;
  }

  void clearToken() {
    state = null;
  }

  Future<void> loadTokenForUser(String dni, AppLocalDatabase localDb) async {
    try {
      final session =
          await (localDb.select(localDb.sessionTable)
                ..where((tbl) => tbl.dni.equals(dni))
                ..where((tbl) => tbl.isActive.equals(true))
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.lastLoginAt)])
                ..limit(1))
              .getSingleOrNull();

      state = session?.accessToken;
    } catch (e) {
      state = null;
    }
  }
}

// Provider para el access token de la sesión actual
final accessTokenProvider = NotifierProvider<AccessTokenNotifier, String?>(
  () => AccessTokenNotifier(),
);

// Provider para el refresh token
final refreshTokenProvider = FutureProvider<String?>((ref) async {
  final localDbAsync = ref.watch(localDatabaseProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return null;

  return localDbAsync.when(
    data: (localDb) async {
      try {
        final session =
            await (localDb.select(localDb.sessionTable)
                  ..where((tbl) => tbl.dni.equals(currentUser.dni))
                  ..where((tbl) => tbl.isActive.equals(true))
                  ..orderBy([(tbl) => OrderingTerm.desc(tbl.lastLoginAt)])
                  ..limit(1))
                .getSingleOrNull();

        return session?.refreshToken;
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (error, stack) => null,
  );
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final localDbAsync = ref.watch(localDatabaseProvider);
  final accessToken = ref.watch(accessTokenProvider);

  final localDb = localDbAsync.value;
  if (localDb == null) {
    throw Exception('Database not ready for SyncService');
  }

  final localRepo = LocalRepository(localDb);
  final remoteRepo = RemoteRepository(accessToken: accessToken);

  return SyncService(
    localCompetenceRepository: localRepo.competenceRepository,
    remoteCompetenceRepository: remoteRepo.competenceRepository,
    localRegistrationRepository: localRepo.competitionRegistrationRepository,
    remoteRegistrationRepository: remoteRepo.competitionRegistrationRepository,
    localTimeRecordRepository: localRepo.competitionTimeRecordRepository,
    remoteTimeRecordRepository: remoteRepo.competitionTimeRecordRepository,
  );
});

final rascUNLMainProvider = Provider<MainRepository>((ref) {
  final isOffline = ref.watch(isOfflineModeProvider);
  final localDbAsync = ref.watch(localDatabaseProvider);

  final accessToken = ref.watch(accessTokenProvider);

  logging.i(
    '🏗️ Creating MainRepository - Mode: ${isOffline ? "Offline" : "Online"}',
  );
  if (isOffline) {
    // Trigger sync if online and DB is ready AND we have a token
    if (!isOffline && localDbAsync.hasValue && accessToken != null) {
      try {
        final syncService = ref.read(syncServiceProvider);
        syncService.syncAll();
      } catch (e) {
        logging.e('Error triggering sync: $e');
      }
    }
    return localDbAsync.when(
      data: (localDb) => LocalRepository(localDb),
      loading: () => throw Exception('Database is loading...'),
      error: (error, stack) => throw error,
    );
  }
  else {
    return RemoteRepository(accessToken: accessToken);
  }
});

final localDatabaseProvider = FutureProvider<AppLocalDatabase>((ref) async {
  final database = AppLocalDatabase();
  // Cerrar la base de datos cuando el provider se destruya
  ref.onDispose(() {
    database.close();
  });
  return database;
});
