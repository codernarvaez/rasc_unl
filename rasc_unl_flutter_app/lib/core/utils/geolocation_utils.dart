import 'dart:math';

/// Utilities for geolocation calculations
class GeolocationUtils {
  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371.0;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distanceKm = earthRadiusKm * c;

    // Convert to meters
    return distanceKm * 1000;
  }

  /// Check if current location is near target location
  static bool isNearLocation({
    required double currentLat,
    required double currentLon,
    required double targetLat,
    required double targetLon,
    required double radiusMeters,
  }) {
    double distance = calculateDistance(
      lat1: currentLat,
      lon1: currentLon,
      lat2: targetLat,
      lon2: targetLon,
    );

    return distance <= radiusMeters;
  }

  /// Check if two coordinates are in the same location (within 10 meters)
  static bool areSameLocation({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    double distance = calculateDistance(
      lat1: lat1,
      lon1: lon1,
      lat2: lat2,
      lon2: lon2,
    );

    return distance < 10.0; // Less than 10 meters
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
