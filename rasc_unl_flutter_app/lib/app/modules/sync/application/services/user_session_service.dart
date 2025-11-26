import 'package:rasc_unl_flutter_app/database/local_database/app_local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/application/services/sync_service.dart';
import 'package:flutter/foundation.dart';

/// Service to handle user session isolation
/// Ensures that when a different user logs in, the local database is cleared
class UserSessionService {
  static const String _lastUserDniKey = 'last_logged_in_user_dni';
  final AppLocalDatabase _db;
  final SyncService? _syncService;

  UserSessionService(this._db, [this._syncService]);

  /// Check if the logging-in user is different from the last user
  /// If different, sync pending data (if online) and clear local database
  Future<void> handleUserLogin({
    required String dni,
    required bool isOnline,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final lastUserDni = prefs.getString(_lastUserDniKey);

    if (lastUserDni != null && lastUserDni != dni) {
      debugPrint('🔄 Different user detected. Last: $lastUserDni, New: $dni');

      // Sync pending data if online
      if (isOnline && _syncService != null) {
        try {
          debugPrint('⬆️ Syncing pending data from previous user...');
          await _syncService?.syncAll();
          debugPrint('✅ Sync completed');
        } catch (e) {
          debugPrint('⚠️ Warning: Could not sync previous user data: $e');
        }
      }

      // Clear local database
      debugPrint('🗑️ Clearing local database for user switch...');
      await _clearLocalDatabase();
      debugPrint('✅ Database cleared');
    } else if (lastUserDni == null) {
      debugPrint('👤 First time login on this device');
    } else {
      debugPrint('👤 Same user logging in: $dni');
    }

    // Update last logged-in user
    await prefs.setString(_lastUserDniKey, dni);
  }

  /// Clear all local data
  Future<void> _clearLocalDatabase() async {
    try {
      // Delete all competences
      await _db.delete(_db.competenceTable).go();

      // Delete all registrations
      await _db.delete(_db.competitionRegistrationTable).go();

      // Delete all time records
      await _db.delete(_db.competitionTimeRecordTable).go();

      debugPrint('✅ All local data cleared');
    } catch (e) {
      debugPrint('❌ Error clearing database: $e');
      rethrow;
    }
  }

  /// Get the DNI of the last logged-in user
  Future<String?> getLastUserDni() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastUserDniKey);
  }

  /// Clear the last user DNI (for logout)
  Future<void> clearLastUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastUserDniKey);
  }
}
