import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_remote_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/local_user_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/local_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/remote_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/services/user_sync_service.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/session_local_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/services/auth_service.dart';

import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/remote/auth_remote_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/application/services/sync_service.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/infrastructure/repositories/remote/remote_sync_repository_impl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rasc_unl_flutter_app/app/modules/composite_repository.dart';

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

final localDatabaseProvider = FutureProvider<AppLocalDatabase>((ref) async {
  final database = AppLocalDatabase();
  // Cerrar la base de datos cuando el provider se destruya
  ref.onDispose(() {
    database.close();
  });
  return database;
});

// Repositories
final sessionLocalRepositoryProvider = Provider<SessionLocalRepository>((ref) {
  final localDbAsync = ref.watch(localDatabaseProvider);
  final localDb = localDbAsync.value;
  if (localDb == null) throw Exception('Database not ready');
  return SessionLocalRepository(localDb);
});

final authRemoteRepositoryProvider = Provider<AuthRemoteRepository>((ref) {
  return AuthRemoteRepositoryImpl();
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

// Services
final authServiceProvider = Provider<AuthService>((ref) {
  final remoteRepo = ref.watch(authRemoteRepositoryProvider);
  final sessionRepo = ref.watch(sessionLocalRepositoryProvider);
  final localDbAsync = ref.watch(localDatabaseProvider);
  final localDb = localDbAsync.value;
  if (localDb == null) throw Exception('Database not ready');
  final localUserRepo = LocalUserRepositoryImpl(localDb);
  final isOffline = ref.watch(isOfflineModeProvider);

  return AuthService(
    remoteRepo: remoteRepo,
    localUserRepo: localUserRepo,
    sessionRepo: sessionRepo,
    isOffline: isOffline,
  );
});

final authInitializationProvider = FutureProvider<void>((ref) async {
  // Ensure DB is ready
  await ref.watch(localDatabaseProvider.future);

  try {
    final authService = ref.read(authServiceProvider);
    final result = await authService.tryAutoLogin();

    if (result.success && result.user != null) {
      ref.read(currentUserProvider.notifier).setUser(result.user!);
      ref.read(accessTokenProvider.notifier).setToken(result.accessToken);
      logging.i('Auto-login successful for ${result.user!.email}');
    } else {
      logging.i('Auto-login failed or no session: ${result.message}');
    }
  } catch (e) {
    logging.e('Error during auth initialization: $e');
  }
});

final remoteSyncRepositoryProvider = Provider<RemoteSyncRepository>((ref) {
  final accessToken = ref.watch(accessTokenProvider);
  return RemoteSyncRepositoryImpl(accessToken: accessToken);
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final localDbAsync = ref.watch(localDatabaseProvider);

  final localDb = localDbAsync.value;
  if (localDb == null) {
    throw Exception('Database not ready for SyncService');
  }

  final localRepo = LocalRepository(localDb);
  final remoteSyncRepo = ref.watch(remoteSyncRepositoryProvider);

  return SyncService(
    localCompetenceRepository: localRepo.competenceRepository,
    localRegistrationRepository: localRepo.competitionRegistrationRepository,
    localTimeRecordRepository: localRepo.competitionTimeRecordRepository,
    remoteSyncRepository: remoteSyncRepo,
  );
});

final userSyncServiceProvider = Provider<UserSyncService>((ref) {
  final remoteRepo = ref.watch(authRemoteRepositoryProvider);
  final sessionRepo = ref.watch(sessionLocalRepositoryProvider);
  final localDbAsync = ref.watch(localDatabaseProvider);
  final localDb = localDbAsync.value;
  if (localDb == null) throw Exception('Database not ready');
  final localUserRepo = LocalUserRepositoryImpl(localDb);

  return UserSyncService(
    remoteRepo: remoteRepo,
    localUserRepo: localUserRepo,
    sessionRepo: sessionRepo,
  );
});

final rascUNLMainProvider = Provider<MainRepository>((ref) {
  final isOffline = ref.watch(isOfflineModeProvider);
  final localDbAsync = ref.watch(localDatabaseProvider);
  final accessToken = ref.watch(accessTokenProvider);

  logging.i(
    '🏗️ Creating MainRepository - Mode: ${isOffline ? "Offline" : "Online"}',
  );

  // Trigger sync if online and DB is ready AND we have a token
  if (!isOffline && localDbAsync.hasValue && accessToken != null) {
    try {
      // Trigger Data Sync
      final syncService = ref.read(syncServiceProvider);
      syncService.syncAll();

      // Trigger User Sync
      final userSyncService = ref.read(userSyncServiceProvider);
      userSyncService.autoSync(accessToken);
    } catch (e) {
      logging.e('Error triggering sync: $e');
    }
  }

  // Always create both repositories
  final localRepo = localDbAsync.when(
    data: (localDb) => LocalRepository(localDb),
    loading: () => throw Exception('Database is loading...'),
    error: (error, stack) => throw error,
  );

  final remoteRepo = RemoteRepository(accessToken: accessToken);

  return CompositeRepository(
    local: localRepo,
    remote: remoteRepo,
    isOffline: isOffline,
  );
});
