import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _dniController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final isOffline = ref.read(isOfflineModeProvider);
    final email = _emailController.text.trim();
    final dni = _dniController.text.trim();
    final password = _passwordController.text;

    // Validaciones según modo online/offline
    if (email.isEmpty) {
      _showError('Por favor, ingrese su email');
      return;
    }

    if (isOffline) {
      // Modo offline: requiere DNI y email
      if (dni.isEmpty) {
        _showError('El DNI es requerido para iniciar sesión sin conexión');
        return;
      }
    } else {
      // Modo online: requiere email y contraseña (sin DNI)
      if (password.isEmpty) {
        _showError('La contraseña es requerida cuando hay conexión a Internet');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(rascUNLMainProvider);
      final result = await repository.authRepository.login(
        email: email,
        dni: isOffline ? dni : null,
        password: isOffline ? null : password,
      );

      setState(() {
        _isLoading = false;
      });

      if (result.success && result.user != null) {
        // Actualizar el usuario actual
        ref.read(currentUserProvider.notifier).setUser(result.user!);
        
        // Establecer el token directamente desde el resultado del login
        if (!isOffline && result.accessToken != null) {
          logging.i('📝 Login successful - Access token received: ${result.accessToken}');
          logging.i('📝 Token length: ${result.accessToken!.length} chars');
          
          // Establecer el token directamente en el provider (sin leer de DB)
          ref.read(accessTokenProvider.notifier).setToken(result.accessToken);
          
          // Verify token was set
          final loadedToken = ref.read(accessTokenProvider);
          logging.i('✅ Token set in provider: ${loadedToken != null ? "YES (${loadedToken.length} chars)" : "NO"}');
        }
        
        if (mounted) {
          context.go('/home');
        }
      } else {
        _showError(result.message);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error inesperado: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.fixed,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = ref.watch(isOfflineModeProvider);

    // Si cambia a online/offline, mostrar información
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),

                  // Botón de regreso
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        context.go('/');
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // Logo
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD50000).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover, // o contain, depende del logo
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Título
                  Text(
                    'Bienvenido de nuevo',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 48),

                  // Indicador de modo offline
                  if (isOffline)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Modo Offline: Solo DNI y Email requeridos',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Campo de email
                  _buildTextField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    hint: 'tu@email.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 20),

                  // Campo de DNI (solo en modo offline)
                  if (isOffline)
                    Column(
                      children: [
                        _buildTextField(
                          controller: _dniController,
                          label: 'DNI / Cédula',
                          hint: '1234567890',
                          icon: Icons.badge_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),

                  // Campo de contraseña (solo si hay conexión)
                  if (!isOffline)
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                  if (!isOffline) SizedBox(height: 16),

                  // Olvidaste contraseña
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/forgot-password'),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: Color(0xFFD50000),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Botón de login
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD50000).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Divisor
                  // Row(
                  //   children: [
                  //     Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'o continúa con',
                  //         style: TextStyle(
                  //           color: Colors.white.withOpacity(0.6),
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                  //   ],
                  // ),

                  // SizedBox(height: 24),

                  // // Botones sociales
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _buildSocialButton(
                  //         icon: Icons.g_mobiledata,
                  //         label: 'Google',
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     SizedBox(width: 16),
                  //     Expanded(
                  //       child: _buildSocialButton(
                  //         icon: Icons.apple,
                  //         label: 'Apple',
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 32),

                  // Registrarse
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/signup');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Color(0xFFD50000),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.5)),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
