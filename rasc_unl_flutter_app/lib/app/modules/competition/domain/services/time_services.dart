import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

/// Service for managing competition timer logic
/// IMPORTANTE: Todos los cálculos de tiempo se hacen en UTC para evitar
/// problemas con relojes locales desincronizados
class TimerService {
  /// Get elapsed time in milliseconds since competition started
  /// Returns null if competitionDate is null
  /// IMPORTANTE: Usa UTC para cálculos precisos independientes del reloj local
  static int? getElapsedTime(CompetenceModel competence) {
    final DateTime? competitionDate = competence.competitionDate;
    if (competitionDate == null) {
      return null;
    }

    // CRÍTICO: Usar UTC para ambas fechas
    final DateTime now = utcNow();
    final DateTime competitionDateUtc = toUtc(competitionDate);
    
    // If competition hasn't started yet, return 0
    if (now.isBefore(competitionDateUtc)) {
      return 0;
    }

    final Duration elapsed = now.difference(competitionDateUtc);
    return elapsed.inMilliseconds;
  }

  /// Format time from milliseconds to MM:SS.mmm
  static String formatTime(int milliseconds) {
    int totalSeconds = (milliseconds / 1000).floor();
    int minutes = (totalSeconds / 60).floor();
    int seconds = totalSeconds % 60;
    int ms = milliseconds % 1000;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String msStr = ms.toString().padLeft(3, '0');

    return "$minutesStr:$secondsStr.$msStr";
  }
}
