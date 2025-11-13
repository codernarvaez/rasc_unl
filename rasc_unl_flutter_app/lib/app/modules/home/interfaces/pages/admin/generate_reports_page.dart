import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class GenerateReportsPage extends ConsumerStatefulWidget {
  const GenerateReportsPage({Key? key}) : super(key: key);
  
  @override
  _GenerateReportsPageState createState() => _GenerateReportsPageState();
}

class _GenerateReportsPageState extends ConsumerState<GenerateReportsPage> {
  bool _isGenerating = false;
  Map<String, dynamic>? _reportData;

  Future<Map<String, dynamic>> _generateReport() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final mainRepo = ref.read(rascUNLMainProvider);
      
      // Obtener datos
      final users = await mainRepo.userRepository.getAllUsers();
      final competences = await mainRepo.competenceRepository.getAllCompetences();
      final allRegistrations = await mainRepo.competitionRegistrationRepository.getAllRegistrations();

      // Calcular estadísticas
      final totalUsers = users.length;
      final activeUsers = users.where((u) => u.isActive).length;
      final adminUsers = users.where((u) => u.rol.toString().contains('ADMINISTRATOR')).length;
      
      final totalCompetences = competences.length;
      final activeCompetences = competences.where((c) => c.isActive).length;
      final inactiveCompetences = totalCompetences - activeCompetences;
      
      final totalRegistrations = allRegistrations.length;
      
      // Registraciones por competencia
      Map<String, int> registrationsByCompetence = {};
      for (var comp in competences) {
        final count = allRegistrations.where((r) => r.competenceId == comp.id).length;
        if (count > 0) {
          registrationsByCompetence[comp.name] = count;
        }
      }

      // Competencia más popular
      String mostPopularCompetence = 'N/A';
      int maxRegistrations = 0;
      registrationsByCompetence.forEach((name, count) {
        if (count > maxRegistrations) {
          maxRegistrations = count;
          mostPopularCompetence = name;
        }
      });

      // Promedio de inscritos por competencia
      double avgRegistrations = totalCompetences > 0 
          ? totalRegistrations / totalCompetences 
          : 0;

      // Próximas competencias
      final now = DateTime.now();
      final upcomingCompetences = competences.where((c) {
        return c.isActive && 
               c.competitionDate != null && 
               c.competitionDate!.isAfter(now);
      }).toList()..sort((a, b) => a.competitionDate!.compareTo(b.competitionDate!));

      return {
        'generated_at': DateTime.now(),
        'users': {
          'total': totalUsers,
          'active': activeUsers,
          'inactive': totalUsers - activeUsers,
          'admins': adminUsers,
          'competitors': totalUsers - adminUsers,
        },
        'competences': {
          'total': totalCompetences,
          'active': activeCompetences,
          'inactive': inactiveCompetences,
        },
        'registrations': {
          'total': totalRegistrations,
          'by_competence': registrationsByCompetence,
          'most_popular': mostPopularCompetence,
          'max_registrations': maxRegistrations,
          'average_per_competence': avgRegistrations,
        },
        'upcoming_competences': upcomingCompetences.take(5).map((c) => {
          'name': c.name,
          'date': c.competitionDate,
          'turns': c.nTurns,
        }).toList(),
      };
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si el repositorio está disponible
    try {
      ref.watch(rascUNLMainProvider);
    } catch (e) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFFD50000)),
                SizedBox(height: 20),
                Text(
                  'Cargando base de datos...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isMobile),
              Expanded(
                child: _reportData == null
                    ? _buildInitialState(isMobile)
                    : _buildReportView(isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.go('/home'),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Generar Reportes',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_reportData != null)
            IconButton(
              icon: Icon(Icons.refresh, color: Color(0xFFD50000)),
              onPressed: () async {
                final data = await _generateReport();
                setState(() {
                  _reportData = data;
                });
              },
              tooltip: 'Actualizar reporte',
            ),
        ],
      ),
    );
  }

  Widget _buildInitialState(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 100 : 120,
            height: isMobile ? 100 : 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD50000), Color(0xFF8B0000)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics,
              size: isMobile ? 50 : 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Reporte del Sistema',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Genera un resumen automático con todas las estadísticas del sistema',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: isMobile ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _isGenerating
                ? null
                : () async {
                    final data = await _generateReport();
                    setState(() {
                      _reportData = data;
                    });
                  },
            icon: _isGenerating
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.assessment),
            label: Text(
              _isGenerating ? 'Generando...' : 'Generar Reporte',
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD50000),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32,
                vertical: isMobile ? 12 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportView(bool isMobile) {
    if (_reportData == null) return SizedBox();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fecha de generación
          _buildInfoCard(
            icon: Icons.access_time,
            title: 'Generado',
            value: _formatDateTime(_reportData!['generated_at']),
            color: Color(0xFFD50000),
            isMobile: isMobile,
          ),
          SizedBox(height: 20),

          // Título: Usuarios
          _buildSectionTitle('Usuarios', Icons.people, isMobile),
          SizedBox(height: 12),
          
          isMobile
              ? Column(
                  children: [
                    _buildStatCard(
                      icon: Icons.people,
                      title: 'Total de Usuarios',
                      value: '${_reportData!['users']['total']}',
                      color: Color(0xFFD50000),
                      isMobile: isMobile,
                    ),
                    SizedBox(height: 12),
                    _buildStatCard(
                      icon: Icons.check_circle,
                      title: 'Usuarios Activos',
                      value: '${_reportData!['users']['active']}',
                      color: Colors.green,
                      isMobile: isMobile,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.admin_panel_settings,
                            title: 'Admins',
                            value: '${_reportData!['users']['admins']}',
                            color: Colors.orange,
                            isMobile: isMobile,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.sports,
                            title: 'Competidores',
                            value: '${_reportData!['users']['competitors']}',
                            color: Colors.blue,
                            isMobile: isMobile,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people,
                        title: 'Total',
                        value: '${_reportData!['users']['total']}',
                        color: Color(0xFFD50000),
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        title: 'Activos',
                        value: '${_reportData!['users']['active']}',
                        color: Colors.green,
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.admin_panel_settings,
                        title: 'Admins',
                        value: '${_reportData!['users']['admins']}',
                        color: Colors.orange,
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.sports,
                        title: 'Competidores',
                        value: '${_reportData!['users']['competitors']}',
                        color: Colors.blue,
                        isMobile: isMobile,
                      ),
                    ),
                  ],
                ),

          SizedBox(height: 24),

          // Título: Competencias
          _buildSectionTitle('Competencias', Icons.emoji_events, isMobile),
          SizedBox(height: 12),
          
          isMobile
              ? Column(
                  children: [
                    _buildStatCard(
                      icon: Icons.emoji_events,
                      title: 'Total',
                      value: '${_reportData!['competences']['total']}',
                      color: Color(0xFFD50000),
                      isMobile: isMobile,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.check_circle,
                            title: 'Activas',
                            value: '${_reportData!['competences']['active']}',
                            color: Colors.green,
                            isMobile: isMobile,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.cancel,
                            title: 'Inactivas',
                            value: '${_reportData!['competences']['inactive']}',
                            color: Colors.red,
                            isMobile: isMobile,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.emoji_events,
                        title: 'Total',
                        value: '${_reportData!['competences']['total']}',
                        color: Color(0xFFD50000),
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        title: 'Activas',
                        value: '${_reportData!['competences']['active']}',
                        color: Colors.green,
                        isMobile: isMobile,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.cancel,
                        title: 'Inactivas',
                        value: '${_reportData!['competences']['inactive']}',
                        color: Colors.red,
                        isMobile: isMobile,
                      ),
                    ),
                  ],
                ),

          SizedBox(height: 24),

          // Título: Inscripciones
          _buildSectionTitle('Inscripciones', Icons.app_registration, isMobile),
          SizedBox(height: 12),
          
          _buildStatCard(
            icon: Icons.how_to_reg,
            title: 'Total de Inscripciones',
            value: '${_reportData!['registrations']['total']}',
            color: Color(0xFFD50000),
            isMobile: isMobile,
          ),
          SizedBox(height: 12),
          
          _buildStatCard(
            icon: Icons.star,
            title: 'Competencia Más Popular',
            value: _reportData!['registrations']['most_popular'],
            subtitle: '${_reportData!['registrations']['max_registrations']} inscritos',
            color: Colors.amber,
            isMobile: isMobile,
          ),
          SizedBox(height: 12),
          
          _buildStatCard(
            icon: Icons.analytics,
            title: 'Promedio por Competencia',
            value: '${_reportData!['registrations']['average_per_competence'].toStringAsFixed(1)}',
            color: Colors.purple,
            isMobile: isMobile,
          ),

          SizedBox(height: 24),

          // Próximas competencias
          if (_reportData!['upcoming_competences'].isNotEmpty) ...[
            _buildSectionTitle('Próximas Competencias', Icons.calendar_today, isMobile),
            SizedBox(height: 12),
            ...(_reportData!['upcoming_competences'] as List).map((comp) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event, color: Color(0xFFD50000)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comp['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 14 : 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${_formatDate(comp['date'])} • ${comp['turns']} vueltas',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: isMobile ? 12 : 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],

          SizedBox(height: 24),

          // Distribución de inscritos por competencia
          if (_reportData!['registrations']['by_competence'].isNotEmpty) ...[
            _buildSectionTitle('Distribución de Inscritos', Icons.pie_chart, isMobile),
            SizedBox(height: 12),
            ...(_reportData!['registrations']['by_competence'] as Map<String, dynamic>)
                .entries
                .map((entry) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFD50000).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFD50000)),
                      ),
                      child: Text(
                        '${entry.value}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isMobile) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFD50000), size: isMobile ? 20 : 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: isMobile ? 28 : 32),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isMobile ? 32 : 40),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: isMobile ? 12 : 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: isMobile ? 11 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }
}
