// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
// import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/local_user_repository_impl.dart';
// import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

// final defaultUsers = [
//   UserModel(
//     id: 1,
//     dni: '1111111111',
//     rol: UserRoleType.ADMINISTRATOR,
//     name: 'esteban',
//     lastName: 'User',
//     email: 'admin@example.com',
//     isActive: true,
//     birthDate: DateTime(1990, 1, 1),
//   ),
//   UserModel(
//     id: 2,
//     dni: '2222222222',
//     rol: UserRoleType.COMPETITOR,
//     name: 'esteban',
//     lastName: 'User',
//     email: 'competitor@example.com',
//     isActive: true,
//     birthDate: DateTime(1995, 5, 15),
//   ),
// ];


// final localUserRepositoryProvider = FutureProvider<LocalUserRepositoryImpl>((ref) async {
//   final localDatabase = await ref.watch(localDatabaseProvider.future);
//   return LocalUserRepositoryImpl(localDatabase);
// });

// Future<void> main() async {
//   // Configurar el contenedor de Riverpod
//   final container = ProviderContainer();

//   // Obtener el repositorio de usuarios desde el proveedor
//   final userRepository = await container.read(localUserRepositoryProvider.future);

//   // Insertar usuarios por defecto
//   for (var user in defaultUsers) {
//     final existingUser = await userRepository.getUserByDni(user.dni);
//     if (existingUser == null) {
//       await userRepository.insertUser(user);
//       print('Usuario ${user.name} ${user.lastName} creado.');
//     } else {
//       print('Usuario ${user.name} ${user.lastName} ya existe.');
//     }
//   }

//   print('Proceso completado.');
// }