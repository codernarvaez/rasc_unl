import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A2A2A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: [
                // Header con icono
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFD50000).withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.dashboard_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panel de Control',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'RASC-UNL',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Sección Usuario
                _buildSectionHeader('Mis Acciones', Icons.person_outline),
                SizedBox(height: 12),
                
                _buildActionCard(
                  icon: Icons.emoji_events_outlined,
                  title: 'Mis Marcas en la RASC-UNL',
                  subtitle: 'Ver mis registros de marcas',
                  gradient: [Color(0xFFD50000), Color(0xFF8B0000)],
                  onTap: () {
                    context.go('/create-categories');
                  },
                ),
                
                SizedBox(height: 12),
                
                _buildActionCard(
                  icon: Icons.sports_score_outlined,
                  title: 'Ver Competencias Disponibles',
                  subtitle: 'Registrarme en nuevas competencias',
                  gradient: [Color(0xFFD50000).withOpacity(0.8), Color(0xFF8B0000).withOpacity(0.8)],
                  onTap: () {
                    context.go('/create-brands');
                  },
                ),
                
                SizedBox(height: 32),
                
                // Divisor
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFFD50000).withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Sección Administrador
                _buildSectionHeader('Gestión Administrativa', Icons.admin_panel_settings_outlined),
                SizedBox(height: 12),
                
                _buildActionCard(
                  icon: Icons.manage_accounts_outlined,
                  title: 'Gestionar Usuarios',
                  subtitle: 'Ver y administrar usuarios registrados',
                  gradient: [Color(0xFF424242), Color(0xFF212121)],
                  onTap: () {
                    context.go('/manage-users');
                  },
                ),
                
                SizedBox(height: 12),
                
                _buildActionCard(
                  icon: Icons.event_available_outlined,
                  title: 'Gestionar Competencias',
                  subtitle: 'Ver y administrar competencias disponibles',
                  gradient: [Color(0xFF424242), Color(0xFF212121)],
                  onTap: () {
                    context.go('/manage-competitions');
                  },
                ),
                
                SizedBox(height: 12),
                
                _buildActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'Registrar Nueva Competencia',
                  subtitle: 'Crear y configurar nueva competencia',
                  gradient: [Color(0xFF424242), Color(0xFF212121)],
                  onTap: () {
                    context.go('/manage-data');
                  },
                ),
                
                SizedBox(height: 12),
                
                _buildActionCard(
                  icon: Icons.analytics_outlined,
                  title: 'Generar Reportes',
                  subtitle: 'Crear y descargar reportes de actividades',
                  gradient: [Color(0xFF424242), Color(0xFF212121)],
                  onTap: () {
                    context.go('/generate-reports');
                  },
                ),
                
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD50000), Color(0xFF8B0000)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Icon(
            icon,
            color: Color(0xFFD50000),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Icono
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Flecha
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}