import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';

/// Service for managing competition timer logic
class TimerService {
  /// Get elapsed time in milliseconds since competition started
  /// Returns null if competitionDate is null
  static int? getElapsedTime(CompetenceModel competence) {
    final DateTime? competitionDate = competence.competitionDate;
    if (competitionDate == null) {
      return null;
    }

    final DateTime now = DateTime.now();
    
    // If competition hasn't started yet, return 0
    if (now.isBefore(competitionDate)) {
      return 0;
    }

    final Duration elapsed = now.difference(competitionDate);
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
