import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AvailableCompetencesPage extends StatefulWidget {
  @override
  _AvailableCompetencesPageState createState() => _AvailableCompetencesPageState();
}

class _AvailableCompetencesPageState extends State<AvailableCompetencesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Simulación de datos
  List<CompetenceItem> availableCompetences = [
    CompetenceItem(
      name: 'Gran Premio 2024',
      date: DateTime(2024, 12, 15, 14, 0),
      nTurns: 10,
      isActive: true,
      registeredCount: 15,
      maxParticipants: 30,
    ),
    CompetenceItem(
      name: 'Carrera Nocturna',
      date: DateTime(2024, 12, 20, 18, 0),
      nTurns: 8,
      isActive: true,
      registeredCount: 8,
      maxParticipants: 20,
    ),
  ];

  List<CompetenceItem> unavailableCompetences = [
    CompetenceItem(
      name: 'Desafío Extremo',
      date: DateTime(2024, 11, 5, 16, 0),
      nTurns: 12,
      isActive: false,
      registeredCount: 25,
      maxParticipants: 25,
    ),
    CompetenceItem(
      name: 'Copa Sprint',
      date: DateTime(2024, 10, 28, 15, 0),
      nTurns: 6,
      isActive: false,
      registeredCount: 18,
      maxParticipants: 20,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCompetencesList(availableCompetences, isAvailable: true),
                    _buildCompetencesList(unavailableCompetences, isAvailable: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
              context.go('/home')

            }
          ),
          SizedBox(width: 8),
          Text(
            'Competencias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD50000), Color(0xFF8B0000)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: [
          Tab(text: 'Disponibles (${availableCompetences.length})'),
          Tab(text: 'No Disponibles (${unavailableCompetences.length})'),
        ],
      ),
    );
  }

  Widget _buildCompetencesList(List<CompetenceItem> competences, {required bool isAvailable}) {
    if (competences.isEmpty) {
      return _buildEmptyState(isAvailable);
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: competences.length,
      itemBuilder: (context, index) {
        return _buildCompetenceCard(competences[index], isAvailable);
      },
    );
  }

  Widget _buildCompetenceCard(CompetenceItem competence, bool isAvailable) {
    double progress = competence.registeredCount / competence.maxParticipants;
    bool isFull = competence.registeredCount >= competence.maxParticipants;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAvailable
              ? Color(0xFFD50000).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navegar a detalles
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: isAvailable
                            ? LinearGradient(colors: [Color(0xFFD50000), Color(0xFF8B0000)])
                            : null,
                        color: isAvailable ? null : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            competence.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(width: 4),
                              Text(
                                _formatDate(competence.date),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isAvailable)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          'Cerrada',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.loop, color: Colors.white.withOpacity(0.6), size: 18),
                    SizedBox(width: 8),
                    Text(
                      '${competence.nTurns} vueltas',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.access_time, color: Colors.white.withOpacity(0.6), size: 18),
                    SizedBox(width: 8),
                    Text(
                      _formatTime(competence.date),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (isAvailable) ...[
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Participantes',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${competence.registeredCount}/${competence.maxParticipants}',
                            style: TextStyle(
                              color: isFull ? Colors.red : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isFull ? Colors.red : Color(0xFFD50000),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isFull ? null : () {
                        _showRegistrationDialog(competence);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFull
                            ? Colors.grey.withOpacity(0.3)
                            : Color(0xFFD50000),
                        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isFull ? 'Cupos Llenos' : 'Inscribirse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isAvailable) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAvailable ? Icons.event_available : Icons.event_busy,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            isAvailable
                ? 'No hay competencias disponibles'
                : 'No hay competencias cerradas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            isAvailable
                ? 'Las nuevas competencias aparecerán aquí'
                : 'Las competencias finalizadas aparecerán aquí',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showRegistrationDialog(CompetenceItem competence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirmar Inscripción',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Deseas inscribirte en "${competence.name}"?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Lógica de inscripción
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('¡Inscripción exitosa!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD50000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}

class CompetenceItem {
  final String name;
  final DateTime date;
  final int nTurns;
  final bool isActive;
  final int registeredCount;
  final int maxParticipants;

  CompetenceItem({
    required this.name,
    required this.date,
    required this.nTurns,
    required this.isActive,
    required this.registeredCount,
    required this.maxParticipants,
  });
}