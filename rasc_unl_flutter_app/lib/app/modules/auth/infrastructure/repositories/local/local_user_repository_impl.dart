import "package:drift/drift.dart";
import "package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart";
import "package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart";
import "package:rasc_unl_flutter_app/database/local_database/app_local_database.dart";

class LocalUserRepositoryImpl implements UserRepository {
  final AppLocalDatabase _localDatabase;

  LocalUserRepositoryImpl(this._localDatabase);

  @override
  Future<List<UserModel>> getAllUsers() async {
    final queryResult = await _localDatabase.select(_localDatabase.userTable).get();
    return queryResult
        .map(
          (row) => UserModel(
            id: row.id,
            dni: row.dni,
            firstName: row.firstName,
            lastName: row.lastName,
            email: row.email,
            role: row.role,
            isActive: row.isActive,
            birthDate: row.birthDate,
          ),
        )
        .toList();
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    final queryResult = await (_localDatabase.select(_localDatabase.userTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (queryResult != null) {
      return UserModel(
        id: queryResult.id,
        dni: queryResult.dni,
        firstName: queryResult.firstName,
        lastName: queryResult.lastName,
        email: queryResult.email,
        role: queryResult.role,
        isActive: queryResult.isActive,
        birthDate: queryResult.birthDate,
      );
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByDni(String dni) async {
    final queryResult = await (_localDatabase.select(_localDatabase.userTable)
          ..where((tbl) => tbl.dni.equals(dni)))
        .getSingleOrNull();
    if (queryResult != null) {
      return UserModel(
        id: queryResult.id,
        dni: queryResult.dni,
        firstName: queryResult.firstName,
        lastName: queryResult.lastName,
        email: queryResult.email,
        role: queryResult.role,
        isActive: queryResult.isActive,
        birthDate: queryResult.birthDate,
      );
    }
    return null;
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await _localDatabase.into(_localDatabase.userTable).insert(
          UserTableCompanion.insert(
            dni: user.dni,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            role: Value(user.role),
            isActive: Value(user.isActive),
            birthDate: Value(user.birthDate),
          ),
        );
  }

  @override
  Future<void> deleteUser(int id) async {
    await (_localDatabase.delete(_localDatabase.userTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await (_localDatabase.update(_localDatabase.userTable)
          ..where((tbl) => tbl.id.equals(user.id)))
        .write(
          UserTableCompanion(
            dni: Value(user.dni),
            firstName: Value(user.firstName),
            lastName: Value(user.lastName),
            email: Value(user.email),
            role: Value(user.role),
            isActive: Value(user.isActive),
            birthDate: Value(user.birthDate),
          ),
        );
  }

  
}