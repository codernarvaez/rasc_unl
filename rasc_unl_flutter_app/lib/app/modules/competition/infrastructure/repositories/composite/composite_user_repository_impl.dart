import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class CompositeUserRepositoryImpl implements UserRepository {
  final UserRepository localRepository;
  final UserRepository remoteRepository;
  final bool isOffline;
  final String? accessToken;

  CompositeUserRepositoryImpl({
    required this.localRepository,
    required this.remoteRepository,
    required this.isOffline,
    this.accessToken,
  });

  @override
  Future<List<UserModel>> getAllUsers() async {
    // 1. Try local first
    final localUsers = await localRepository.getAllUsers();

    // 2. If local is empty and we are online, fetch from remote to populate cache
    if (localUsers.isEmpty && !isOffline && accessToken != null) {
      try {
        final remoteUsers = await remoteRepository.getAllUsers();

        // Save to local
        for (final user in remoteUsers) {
          final exists = await localRepository.getUserByDni(user.dni);
          if (exists == null) {
            await localRepository.insertUser(user);
          } else {
            await localRepository.updateUser(user.copyWith(id: exists.id));
          }
        }

        return remoteUsers;
      } catch (e) {
        logging.e('Failed to fetch users from remote in composite: $e');
        return localUsers;
      }
    }

    return localUsers;
  }

  @override
  Future<UserModel?> getUserByDni(String dni) async {
    final localUser = await localRepository.getUserByDni(dni);

    if (localUser == null && !isOffline && accessToken != null) {
      try {
        final remoteUser = await remoteRepository.getUserByDni(dni);
        if (remoteUser != null) {
          await localRepository.insertUser(remoteUser);
          return remoteUser;
        }
      } catch (e) {
        logging.e('Failed to fetch user by DNI from remote: $e');
      }
    }
    return localUser;
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    return localRepository.getUserById(id);
  }

  @override
  Future<List<UserModel>> getPendingSyncUsers() async {
    return localRepository.getPendingSyncUsers();
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await localRepository.insertUser(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await localRepository.updateUser(user);
    if (!isOffline && accessToken != null) {
      try {
        await remoteRepository.updateUser(user);
      } catch (e) {
        logging.e('Failed to update user remote: $e');
      }
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    await localRepository.deleteUser(id);
  }
}
