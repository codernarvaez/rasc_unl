import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _obscurePassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  final _dniController = TextEditingController();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    _dniController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validaciones
    if (_dniController.text.trim().isEmpty) {
      _showError('Por favor, ingrese su DNI');
      return;
    }
    
    if (_nombresController.text.trim().isEmpty) {
      _showError('Por favor, ingrese sus nombres');
      return;
    }
    
    if (_apellidosController.text.trim().isEmpty) {
      _showError('Por favor, ingrese sus apellidos');
      return;
    }
    
    if (_emailController.text.trim().isEmpty) {
      _showError('Por favor, ingrese su email');
      return;
    }
    
    if (_passwordController.text.isEmpty) {
      _showError('Por favor, ingrese su contraseña');
      return;
    }
    
    if (_passwordController.text.length < 8) {
      _showError('La contraseña debe tener al menos 8 caracteres');
      return;
    }
    
    if (!_acceptTerms) {
      _showError('Debe aceptar los términos y condiciones');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(rascUNLMainProvider);
      final result = await repository.authRepository.register(
        email: _emailController.text.trim(),
        firstName: _nombresController.text.trim(),
        lastName: _apellidosController.text.trim(),
        dni: _dniController.text.trim(),
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Redirigir al login después del registro exitoso
          context.go('/login');
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
                  SizedBox(height: 20),

                  // Botón de regreso
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => {context.go('/')},
                    ),
                  ),

                  SizedBox(height: 10),

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

                  SizedBox(height: 30),

                  // Título
                  Text(
                    'Crea tu cuenta',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Completa tus datos para comenzar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 36),

                  // Campo DNI
                  _buildTextField(
                    controller: _dniController,
                    label: 'DNI',
                    hint: '1234567890',
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 16),

                  // Campo Nombres
                  _buildTextField(
                    controller: _nombresController,
                    label: 'Nombres',
                    hint: 'Ingresa tus nombres',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 16),

                  // Campo Apellidos
                  _buildTextField(
                    controller: _apellidosController,
                    label: 'Apellidos',
                    hint: 'Ingresa tus apellidos',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 16),

                  // Campo Email
                  _buildTextField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    hint: 'tu@email.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 16),

                  // Campo Contraseña
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

                  SizedBox(height: 8),

                  // Indicador de fortaleza de contraseña
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withOpacity(0.5),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Mínimo 8 caracteres',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Checkbox de términos
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return Color(0xFFD50000);
                            }
                            return Colors.white.withOpacity(0.1);
                          }),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              'Acepto los ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Términos y Condiciones',
                                style: TextStyle(
                                  color: Color(0xFFD50000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Botón de registro
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: (_acceptTerms && !_isLoading)
                          ? LinearGradient(
                              colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                            )
                          : null,
                      color: (_acceptTerms && !_isLoading)
                          ? null
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: (_acceptTerms && !_isLoading)
                          ? [
                              BoxShadow(
                                color: Color(0xFFD50000).withOpacity(0.4),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: (_acceptTerms && !_isLoading)
                          ? _handleRegister
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _acceptTerms
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // // Divisor
                  // Row(
                  //   children: [
                  //     Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'o regístrate con',
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

                  // Ya tienes cuenta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes una cuenta? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Inicia sesión',
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

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
