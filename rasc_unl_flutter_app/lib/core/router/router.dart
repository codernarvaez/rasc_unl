import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/interfaces/pages/login_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/interfaces/pages/singup_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/rasc_unl_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/home_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/actions_page.dart';

enum AppRouterNames {
  login,
  signup,
  welcome,
  home,
  profileSettings,
  userPreferences,
  userPrivacyAndSecurity,
  forgotPassword,
  actions,
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
    refreshListenable: router,
    redirect: router._redirect,
    routes: router._routes,
  );
});

class RouterNotifier extends ChangeNotifier {
  // Simulated authentication state
  final Ref _ref;

  RouterNotifier(this._ref) {
    // _ref.listen<bool>(authProvider, (_, __) => notifyListeners());
    // inicia
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    // final authState = _ref.read(authProvider);
    // final isAuth = switch (authState) {
    //   AuthStateAuthenticated() => true,
    //   _ => false,
    // };

  //   final currentPath = state.matchedLocation;

    // Si el usuario está autenticado y está en páginas de auth, redirigir a home
    // if (isAuth &&
    //     (currentPath == '/' ||
    //         currentPath == '/login' ||
    //         currentPath == '/signup')) {
    //   return '/home';
    // }

    // // Si el usuario no está autenticado y está en home, redirigir a welcome
    // if (!isAuth && currentPath == '/home') {
    //   return '/';
    // }

    // En todos los demás casos, permitir la navegación
    return null;
  }

  List<RouteBase> get _routes => [
    GoRoute(
      path: '/',
      name: AppRouterNames.welcome.name,
      builder: (context, state) => RascUnlPage(),
    ),
    GoRoute(
      path: '/login',
      name: AppRouterNames.login.name,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: AppRouterNames.signup.name,
      builder: (context, state) => SignupPage(),
    ),
    // GoRoute(
    //   path: '/forgot-password',
    //   name: AppRouterNames.forgotPassword.name,
    //   builder: (context, state) => const ForgotPasswordPage(),
    // ),
    GoRoute(
      path: '/home',
      name: AppRouterNames.home.name,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/actions',
      name: AppRouterNames.actions.name,
      builder: (context, state) => const ActionsPage(),
    ),
  ];
}
