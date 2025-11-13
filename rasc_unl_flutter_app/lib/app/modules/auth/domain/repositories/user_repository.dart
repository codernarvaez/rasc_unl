import "package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart";

abstract class UserRepository {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(int id);
  Future<UserModel?> getUserByDni(String dni);
  Future<void> insertUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}