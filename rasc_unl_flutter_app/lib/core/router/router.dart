import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/interfaces/pages/forgot_password_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/interfaces/pages/login_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/interfaces/pages/singup_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/admin/generate_reports_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/admin/manage_competences_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/admin/manage_users_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/rasc_unl_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/home_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/actions_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/user/available_competences_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/user/components/competence_details_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/user/my_records_page.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

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
  myRecords,
  competenceDetails,
  availableCompetences,
  manageUsers,
  manageCompetences,
  generateReports,
  
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
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Escuchar cambios en el estado de autenticación
    _ref.listen<dynamic>(currentUserProvider, (_, __) => notifyListeners());
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final currentUser = _ref.read(currentUserProvider);
    final isAuthenticated = currentUser != null;
    final currentPath = state.matchedLocation;

    // Rutas que requieren autenticación
    final protectedRoutes = [
      '/home',
      '/actions',
      '/my-records',
      '/user/competence-details',
      '/available-competences',
      '/manage-users',
      '/manage-competences',
      '/generate-reports',
    ];

    // Si el usuario no está autenticado y está intentando acceder a una ruta protegida
    if (!isAuthenticated && protectedRoutes.any((route) => currentPath.startsWith(route))) {
      return '/login';
    }

    // Si el usuario está autenticado y está en login o signup, redirigir a home
    if (isAuthenticated && (currentPath == '/login' || currentPath == '/signup')) {
      return '/home';
    }

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
    GoRoute(
      path: '/forgot-password',
      name: AppRouterNames.forgotPassword.name,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
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
    GoRoute(
      path: '/my-records',
      name: AppRouterNames.myRecords.name,
      builder: (context, state) => MyRecordsPage(),
    ),
    GoRoute(
      path: '/user/competence-details',
      name: AppRouterNames.competenceDetails.name,
      builder: (context, state) {
        final competenceId = state.extra as int?;
        if (competenceId == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ID de competencia no proporcionado'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: Text('Volver al inicio'),
                  ),
                ],
              ),
            ),
          );
        }
        return CompetenceDetailsPage(competenceId: competenceId);
      },
    ),

    GoRoute(
      path: '/available-competences',
      name: AppRouterNames.availableCompetences.name,
      builder: (context, state) => AvailableCompetencesPage(),
    ),
    GoRoute(
      path: '/manage-users',
      name: AppRouterNames.manageUsers.name,
      builder: (context, state) => ManageUsersPage(),
    ),
    GoRoute(
      path: '/manage-competences',
      name: AppRouterNames.manageCompetences.name,
      builder: (context, state) => ManageCompetencesPage(),
    ),
    GoRoute(
      path: '/generate-reports',
      name: AppRouterNames.generateReports.name,
      builder: (context, state) => GenerateReportsPage()
      )
  ];
}
