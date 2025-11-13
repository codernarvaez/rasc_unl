import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/auth_remote_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/local_user_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/local/session_local_repository.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/repositories/remote/auth_remote_repository_impl.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/services/auth_service.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/infrastructure/services/sync_service.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

/// Provider para el repositorio remoto de autenticación
final authRemoteRepositoryProvider = Provider<AuthRemoteRepository>((ref) {
  return AuthRemoteRepositoryImpl();
});

/// Provider para el repositorio local de usuarios
final userLocalRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(localDatabaseProvider).value;
  if (db == null) throw Exception('Database not ready');
  return LocalUserRepositoryImpl(db);
});

/// Provider para el repositorio de sesiones locales
final sessionLocalRepositoryProvider = Provider<SessionLocalRepository>((ref) {
  final db = ref.watch(localDatabaseProvider).value;
  if (db == null) throw Exception('Database not ready');
  return SessionLocalRepository(db);
});

/// Provider para el servicio de autenticación híbrido
final authServiceProvider = Provider<AuthService>((ref) {
  final remoteRepo = ref.watch(authRemoteRepositoryProvider);
  final localUserRepo = ref.watch(userLocalRepositoryProvider);
  final sessionRepo = ref.watch(sessionLocalRepositoryProvider);
  final isOffline = ref.watch(isOfflineModeProvider);

  return AuthService(
    remoteRepo: remoteRepo,
    localUserRepo: localUserRepo,
    sessionRepo: sessionRepo,
    isOffline: isOffline,
  );
});

/// State para el estado de autenticación
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? accessToken;
  final String? refreshToken;
  final bool isOffline;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.accessToken,
    this.refreshToken,
    this.isOffline = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? accessToken,
    String? refreshToken,
    bool? isOffline,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Notifier para gestionar el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref) : super(const AuthState()) {
    _checkSession();
  }

  /// Verifica si hay una sesión activa al iniciar
  Future<void> _checkSession() async {
    state = state.copyWith(isLoading: true);
    
    final result = await _authService.getActiveSession();
    
    if (result.success && result.user != null) {
      state = AuthState(
        user: result.user,
        isAuthenticated: true,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        isOffline: result.isOffline,
        isLoading: false,
      );
      
      // Actualizar el currentUserProvider
      _ref.read(currentUserProvider.notifier).setUser(result.user!);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Registra un nuevo usuario
  Future<void> register({
    required String email,
    required String firstName,
    required String lastName,
    required String dni,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _authService.register(
      email: email,
      firstName: firstName,
      lastName: lastName,
      dni: dni,
      password: password,
    );

    if (result.success) {
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Inicia sesión
  Future<void> login({
    required String email,
    required String dni,
    String? password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _authService.login(
      email: email,
      dni: dni,
      password: password,
    );

    if (result.success && result.user != null) {
      state = AuthState(
        user: result.user,
        isAuthenticated: true,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        isOffline: result.isOffline,
        isLoading: false,
      );
      
      // Actualizar el currentUserProvider
      _ref.read(currentUserProvider.notifier).setUser(result.user!);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Cierra sesión
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    await _authService.logout(refreshToken: state.refreshToken);

    state = const AuthState();
    
    // Limpiar el currentUserProvider
    _ref.read(currentUserProvider.notifier).clearUser();
  }

  /// Refresca el token de acceso
  Future<void> refreshAccessToken() async {
    if (state.refreshToken == null) return;

    final result = await _authService.refreshAccessToken(state.refreshToken!);

    if (result.success) {
      state = state.copyWith(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
    } else {
      // Si no se puede refrescar, cerrar sesión
      await logout();
    }
  }

  /// Limpia el error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider para el servicio de sincronización
final syncServiceProvider = Provider<SyncService>((ref) {
  final remoteRepo = ref.watch(authRemoteRepositoryProvider);
  final localUserRepo = ref.watch(userLocalRepositoryProvider);
  final sessionRepo = ref.watch(sessionLocalRepositoryProvider);

  return SyncService(
    remoteRepo: remoteRepo,
    localUserRepo: localUserRepo,
    sessionRepo: sessionRepo,
  );
});

/// Provider para el notifier de autenticación
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});

/// Provider conveniente para verificar si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

/// Provider conveniente para obtener el usuario actual
final currentAuthUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authNotifierProvider).user;
});
