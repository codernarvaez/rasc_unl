/// Utilidades para manejo de zona horaria UTC
/// Todas las fechas en el sistema se manejan en UTC para consistencia
/// independientemente del reloj local del dispositivo

/// Retorna la fecha y hora actual en UTC
/// Usar esta función en lugar de DateTime.now() para consistencia
DateTime utcNow() {
  return DateTime.now().toUtc();
}

/// Convierte un DateTime a UTC
/// Si ya está en UTC, lo retorna sin cambios
DateTime toUtc(DateTime dt) {
  return dt.toUtc();
}

/// Convierte un DateTime UTC a hora local del dispositivo
/// SOLO usar para display en UI, nunca para almacenamiento o cálculos
DateTime toLocal(DateTime utcDateTime) {
  return utcDateTime.toLocal();
}

/// Parsea un string ISO 8601 a DateTime en UTC
/// El servidor siempre envía fechas en formato ISO 8601 UTC
DateTime parseUtcDateTime(String isoString) {
  final dt = DateTime.parse(isoString);
  return dt.toUtc();
}

/// Formatea un DateTime UTC a string ISO 8601
/// Para enviar al servidor
String formatUtcDateTime(DateTime dt) {
  return dt.toUtc().toIso8601String();
}

/// Obtiene la diferencia en milisegundos entre dos DateTime en UTC
/// Útil para cálculos de tiempo precisos
int getMillisecondsDifference(DateTime start, DateTime end) {
  return end.toUtc().difference(start.toUtc()).inMilliseconds;
}

/// Obtiene el timestamp en milisegundos UTC
/// Útil para almacenar tiempos de competencias
int getUtcTimestampMillis() {
  return DateTime.now().toUtc().millisecondsSinceEpoch;
}

/// Convierte milisegundos desde epoch a DateTime UTC
DateTime fromMilliseconds(int milliseconds) {
  return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
}

/// Ecuador Time Zone: UTC-5 (sin horario de verano)
/// Usar solo para display, no para cálculos
const int ecuadorUtcOffsetHours = -5;

/// Convierte DateTime UTC a hora de Ecuador para display
/// IMPORTANTE: Solo para mostrar al usuario, no almacenar
/// Ejemplo: 20:30 UTC → 15:30 Ecuador (20:30 + (-5) = 15:30)
DateTime toEcuadorTime(DateTime utcDateTime) {
  return utcDateTime.toUtc().add(Duration(hours: ecuadorUtcOffsetHours));
}

/// Convierte hora de Ecuador a UTC
/// Útil si el usuario ingresa una hora local y necesitamos convertirla a UTC
/// Ejemplo: 15:30 Ecuador → 20:30 UTC (15:30 - (-5) = 20:30)
DateTime fromEcuadorTimeToUtc(DateTime ecuadorTime) {
  // Ecuador está 5 horas ATRÁS de UTC (UTC-5)
  // Para convertir a UTC, necesitamos SUMAR 5 horas
  return DateTime.utc(
    ecuadorTime.year,
    ecuadorTime.month,
    ecuadorTime.day,
    ecuadorTime.hour,
    ecuadorTime.minute,
    ecuadorTime.second,
    ecuadorTime.millisecond,
  ).subtract(Duration(hours: ecuadorUtcOffsetHours)); // subtract(-5) = add(5)
}
