import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<Position> determinePrecisePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 🔹 Verifica si el servicio está habilitado
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Los servicios de ubicación están deshabilitados.');
  }

  // 🔹 Verifica permisos
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos de ubicación fueron denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Los permisos de ubicación fueron denegados permanentemente.');
  }

  // 🔹 En web la precisión es menor, pero el código sigue siendo válido
  final accuracy = kIsWeb
      ? LocationAccuracy.low // web solo puede usar IP/Wi-Fi
      : LocationAccuracy.bestForNavigation; // móvil usa GPS real

  // 🔹 Obtiene la ubicación actual
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: accuracy,
    timeLimit: const Duration(seconds: 15),
  );

  return position;
}
