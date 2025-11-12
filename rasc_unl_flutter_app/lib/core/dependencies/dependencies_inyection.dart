import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:rasc_unl_flutter_app/app/modules/local_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/remote_repository.dart';
import 'package:rasc_unl_flutter_app/app/shared/utils/utils.dart';
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

final competitionRepositoryProvider = Provider<MainRepository>((ref) {
  final isOffline = ref.watch(isOfflineModeProvider);
  final localDb = ref.watch(localDatabaseProvider).value;

  if (isOffline) {
    return LocalRepository(localDb!);
  } else {
    return RemoteRepository();
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


void obtenerUbicacion() async {
  try {
    final pos = await determinePrecisePosition();
    print('Lat: ${pos.latitude}, Lng: ${pos.longitude}, Precisión: ${pos.accuracy}m');
  } catch (e) {
    print('Error al obtener ubicación: $e');
  }
}
