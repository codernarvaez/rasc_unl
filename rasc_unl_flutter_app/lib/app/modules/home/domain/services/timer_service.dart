import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';

/// Service for managing competition timer logic
class TimerService {
  /// Check if timer should start automatically based on competition date
  static bool shouldStartTimer(CompetenceModel competence) {
    if (competence.timerStarted) {
      return false; // Already started
    }

    final DateTime? competitionDate = competence.competitionDate;
    if (competitionDate == null) {
      return false;
    }

    final DateTime now = DateTime.now();
    return now.isAfter(competitionDate) || now.isAtSameMomentAs(competitionDate);
  }

  /// Get elapsed time in milliseconds
  static int? getElapsedTime(CompetenceModel competence) {
    if (!competence.timerStarted || competence.timerStartTime == null) {
      return null;
    }

    final DateTime now = DateTime.now();
    final Duration elapsed = now.difference(competence.timerStartTime!);
    return elapsed.inMilliseconds;
  }

  /// Validate minimum time requirement (2 minutes)
  /// Returns true if valid, false if not enough time passed
  static bool validateMinimumTime({
    required CompetenceModel competence,
    required int elapsedMilliseconds,
  }) {
    // If start and finish are in the same location, no minimum time required
    final startCoords = competence.startCoordinates;
    final finishCoords = competence.finishCoordinates;

    // Extract latitude and longitude
    final startLat = startCoords['latitude'] ?? 0.0;
    final startLon = startCoords['longitude'] ?? 0.0;
    final finishLat = finishCoords['latitude'] ?? 0.0;
    final finishLon = finishCoords['longitude'] ?? 0.0;

    // Check if same location (within 10 meters)
    final distance = _calculateDistance(startLat, startLon, finishLat, finishLon);
    if (distance < 10.0) {
      return true; // No minimum time required
    }

    // Otherwise, require at least 2 minutes (120000 milliseconds)
    return elapsedMilliseconds >= 120000;
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

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = 0.5 - (dLat / 2) + 
        (1 - dLat) * (1 - dLat) * (0.5 - (dLon / 2));

    return earthRadiusKm * 2 * 3.141592653589793 * a * 1000; // meters
  }

  static double _degreesToRadians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }
}
