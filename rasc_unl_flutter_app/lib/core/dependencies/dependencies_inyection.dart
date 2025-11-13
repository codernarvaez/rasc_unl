import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/local_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/remote_repository.dart';
import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';




final logging = Logger(
  level: kReleaseMode ? Level.nothing : Level.debug,
  printer: PrettyPrinter(), // opcional, puedes cambiarlo por SimplePrinter()
);



final connectionStatusProvider =
    StreamProvider<InternetConnectionStatus>((ref) async* {
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

// Provider para el access token de la sesión actual
final accessTokenProvider = FutureProvider<String?>((ref) async {
  final localDbAsync = ref.watch(localDatabaseProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  if (currentUser == null) return null;
  
  return localDbAsync.when(
    data: (localDb) async {
      try {
        // Obtener la última sesión activa del usuario actual
        final session = await (localDb.select(localDb.sessionTable)
              ..where((tbl) => tbl.dni.equals(currentUser.dni))
              ..where((tbl) => tbl.isActive.equals(true))
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.lastLoginAt)])
              ..limit(1))
            .getSingleOrNull();
        
        return session?.accessToken;
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (error, stack) => null,
  );
});

final rascUNLMainProvider = Provider<MainRepository>((ref) {
  final isOffline = ref.watch(isOfflineModeProvider);
  final localDbAsync = ref.watch(localDatabaseProvider);
  final accessTokenAsync = ref.watch(accessTokenProvider);

  // Si la base de datos aún no está lista, lanzamos un error que será manejado por AsyncValue
  return localDbAsync.when(
    data: (localDb) {
      if (isOffline) {
        return LocalRepository(localDb);
      } else {
        // Obtenemos el accessToken si está disponible
        final accessToken = accessTokenAsync.value;
        return RemoteRepository(accessToken: accessToken);
      }
    },
    loading: () => throw Exception('Database is loading...'),
    error: (error, stack) => throw error,
  );
});


final localDatabaseProvider = FutureProvider<AppLocalDatabase>((ref) async {
  final database = AppLocalDatabase();
  // Cerrar la base de datos cuando el provider se destruya
  ref.onDispose(() {
    database.close();
  });
  return database;
});


