import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_remote_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/session_local_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

/// Resultado de sincronización
class SyncResult {
  final bool success;
  final String? message;
  final int usersDownloaded;
  final int usersUploaded;
  final List<String> errors;

  SyncResult({
    required this.success,
    this.message,
    this.usersDownloaded = 0,
    this.usersUploaded = 0,
    this.errors = const [],
  });
}

/// Servicio para sincronización bidireccional de datos
class UserSyncService {
  final AuthRemoteRepository _remoteRepo;
  final UserRepository _localUserRepo;
  final SessionLocalRepository _sessionRepo;

  UserSyncService({
    required AuthRemoteRepository remoteRepo,
    required UserRepository localUserRepo,
    required SessionLocalRepository sessionRepo,
  }) : _remoteRepo = remoteRepo,
       _localUserRepo = localUserRepo,
       _sessionRepo = sessionRepo;

  /// Sincroniza todos los datos cuando se recupera conexión
  Future<SyncResult> syncAll({required String accessToken}) async {
    logging.i('Iniciando sincronización completa...');

    final errors = <String>[];
    int usersDownloaded = 0;
    int usersUploaded = 0;

    try {
      // 1. Sincronizar datos del usuario actual
      final currentUserResult = await _syncCurrentUser(accessToken);
      if (!currentUserResult.success) {
        errors.add(
          currentUserResult.message ?? 'Error al sincronizar usuario actual',
        );
      }

      // 2. Para administradores: sincronizar todos los usuarios
      final session = await _sessionRepo.getActiveSession();
      if (session != null) {
        final localUser = await _localUserRepo.getUserById(
          session.userId.toString(),
        );
        if (localUser != null && localUser.role == 'ADMINISTRATOR') {
          final allUsersResult = await _syncAllUsers(accessToken);
          usersDownloaded = allUsersResult.usersDownloaded;
          usersUploaded = allUsersResult.usersUploaded;
          errors.addAll(allUsersResult.errors);
        }
      }

      // 3. TODO: Sincronizar competencias
      // 4. TODO: Sincronizar registros

      logging.i(
        'Sincronización completada: $usersDownloaded descargados, $usersUploaded subidos',
      );

      return SyncResult(
        success: errors.isEmpty,
        message: errors.isEmpty
            ? 'Sincronización exitosa'
            : 'Sincronización con errores',
        usersDownloaded: usersDownloaded,
        usersUploaded: usersUploaded,
        errors: errors,
      );
    } catch (e) {
      logging.e('Error en sincronización: $e');
      return SyncResult(
        success: false,
        message: 'Error general de sincronización',
        errors: [e.toString()],
      );
    }
  }

  /// Sincroniza el usuario actual
  Future<SyncResult> _syncCurrentUser(String accessToken) async {
    try {
      // Obtener datos actualizados del servidor
      final userApiResponse = await _remoteRepo.getCurrentUser(accessToken);

      // Mapear a UserModel
      final user = UserModel(
        id: userApiResponse.id,
        dni: userApiResponse.dni,
        role: userApiResponse.role,
        firstName: userApiResponse.firstName,
        lastName: userApiResponse.lastName,
        email: userApiResponse.email,
        isActive: userApiResponse.isActive,
        birthDate: userApiResponse.dateOfBirth != null
            ? DateTime.tryParse(userApiResponse.dateOfBirth!)
            : null,
      );

      // Buscar usuario local por DNI
      final localUser = await _localUserRepo.getUserByDni(user.dni);

      if (localUser == null) {
        // Usuario no existe localmente, insertarlo
        await _localUserRepo.insertUser(user);
        logging.i('Usuario actual sincronizado (nuevo): ${user.email}');
      } else {
        // Usuario existe, actualizarlo manteniendo el ID local
        await _localUserRepo.updateUser(user.copyWith(id: localUser.id));
        logging.i('Usuario actual sincronizado (actualizado): ${user.email}');
      }

      return SyncResult(success: true, message: 'Usuario actual sincronizado');
    } catch (e) {
      logging.e('Error al sincronizar usuario actual: $e');
      return SyncResult(
        success: false,
        message: 'Error al sincronizar usuario actual',
        errors: [e.toString()],
      );
    }
  }

  /// Sincroniza todos los usuarios (solo para administradores)
  Future<SyncResult> _syncAllUsers(String accessToken) async {
    int downloaded = 0;
    int uploaded = 0;
    final errors = <String>[];

    try {
      // 1. Descargar todos los usuarios del servidor
      logging.i('Descargando usuarios del servidor...');
      final remoteUsers = await _remoteRepo.getAllUsers(
        accessToken,
        limit: 1000,
      );

      for (final userApiResponse in remoteUsers) {
        try {
          final user = UserModel(
            id: userApiResponse.id,
            dni: userApiResponse.dni,
            role: userApiResponse.role,
            firstName: userApiResponse.firstName,
            lastName: userApiResponse.lastName,
            email: userApiResponse.email,
            isActive: userApiResponse.isActive,
            birthDate: userApiResponse.dateOfBirth != null
                ? DateTime.tryParse(userApiResponse.dateOfBirth!)
                : null,
          );

          final localUser = await _localUserRepo.getUserByDni(user.dni);

          if (localUser == null) {
            await _localUserRepo.insertUser(user);
            downloaded++;
          } else {
            await _localUserRepo.updateUser(user.copyWith(id: localUser.id));
            downloaded++;
          }
        } catch (e) {
          errors.add(
            'Error al sincronizar usuario ${userApiResponse.email}: $e',
          );
          logging.w('Error al sincronizar usuario: $e');
        }
      }

      // 2. Subir cambios locales al servidor
      logging.i('Subiendo cambios locales de usuarios...');
      logging.i('Subiendo cambios locales de usuarios...');
      final pendingUsers = await _localUserRepo.getPendingSyncUsers();

      for (final user in pendingUsers) {
        try {
          // Intentar actualizar en el servidor
          // Nota: La API actual solo permite actualizar, no crear usuarios offline (por ahora)
          // Si el usuario fue creado offline, deberíamos usar un endpoint de registro o create_user_by_admin
          // Asumimos por ahora que son actualizaciones de usuarios existentes

          await _remoteRepo.updateUser(accessToken, user.id, {
            'first_name': user.firstName,
            'last_name': user.lastName,
            'role': user.role,
            'is_active': user.isActive,
            'date_of_birth': user.birthDate?.toIso8601String(),
          });

          // Marcar como sincronizado
          await _localUserRepo.updateUser(
            user.copyWith(syncStatus: 'synced', lastSyncAt: utcNow()),
          );
          uploaded++;
        } catch (e) {
          errors.add('Error al subir usuario ${user.email}: $e');
          logging.w('Error al subir usuario: $e');
        }
      }

      logging.i(
        'Usuarios sincronizados: $downloaded descargados, $uploaded subidos',
      );

      return SyncResult(
        success: errors.isEmpty,
        message: 'Usuarios sincronizados',
        usersDownloaded: downloaded,
        usersUploaded: uploaded,
        errors: errors,
      );
    } catch (e) {
      logging.e('Error al sincronizar todos los usuarios: $e');
      return SyncResult(
        success: false,
        message: 'Error al sincronizar usuarios',
        errors: [e.toString(), ...errors],
      );
    }
  }

  /// Marca un usuario como pendiente de sincronización
  Future<void> markUserForSync(String userId) async {
    final user = await _localUserRepo.getUserById(userId);
    if (user != null) {
      await _localUserRepo.updateUser(
        user.copyWith(syncStatus: 'pending', version: user.version + 1),
      );
      logging.i('Usuario $userId marcado para sincronización');
    }
  }

  /// Verifica si hay datos pendientes de sincronizar
  Future<bool> hasPendingSync() async {
    final pendingUsers = await _localUserRepo.getPendingSyncUsers();
    return pendingUsers.isNotEmpty;
  }

  /// Sincronización automática en segundo plano
  Future<void> autoSync(String accessToken) async {
    logging.i('Ejecutando sincronización automática...');

    try {
      final hasPending = await hasPendingSync();

      if (hasPending) {
        await syncAll(accessToken: accessToken);
      } else {
        logging.i('No hay datos pendientes de sincronización');
      }
    } catch (e) {
      logging.w('Error en sincronización automática: $e');
    }
  }
}
