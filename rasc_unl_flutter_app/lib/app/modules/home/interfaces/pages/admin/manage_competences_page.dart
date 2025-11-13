import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/admin/forms/competence_form_dialog.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:uuid/uuid.dart';

class ManageCompetencesPage extends ConsumerStatefulWidget {
  const ManageCompetencesPage({Key? key}) : super(key: key);


  @override
  ManageCompetencesPageState createState() => ManageCompetencesPageState();
}

class ManageCompetencesPageState extends ConsumerState<ManageCompetencesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<CompetenceModel>> _getFilteredCompetences(bool isActive) async {
    try {
      final repository = ref.read(rascUNLMainProvider).competenceRepository;
      final allCompetences = await repository.getAllCompetences();
      
      return allCompetences.where((comp) {
        bool matchesActive = comp.isActive == isActive;
        bool matchesSearch = _searchQuery.isEmpty ||
            comp.name.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesActive && matchesSearch;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> _getTotalRegistrations(int competenceId) async {
    try {
      final repository = ref.read(rascUNLMainProvider).competitionRegistrationRepository;
      final registrations = await repository.getRegistrationsByCompetenceId(competenceId);
      return registrations.length;
    } catch (e) {
      return 0;
    }
  }

  void _showCreateEditDialog({CompetenceModel? competence}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CompetenceFormDialog(
        competence: competence,
        onSave: (formData) async {
          try {
            final repository = ref.read(rascUNLMainProvider).competenceRepository;
            final userRepository = ref.read(rascUNLMainProvider).userRepository;
            
            // Get current user (admin)
            final users = await userRepository.getAllUsers();
            final admin = users.firstWhere(
              (u) => u.rol.toString().contains('ADMINISTRATOR'),
              orElse: () => users.first,
            );

            if (competence == null) {
              // Crear nueva competencia
              final newCompetence = CompetenceModel(
                id: DateTime.now().millisecondsSinceEpoch,
                externalId: Uuid().v4(),
                name: formData.name,
                competitionDate: formData.competitionDate,
                competitionLimitForRegistrationDate: formData.competitionLimitForRegistrationDate,
                nTurns: formData.nTurns,
                isActive: formData.isActive,
                createdBy: admin.dni,
                startCoordinates: formData.startCoordinates,
                finishCoordinates: formData.finishCoordinates,
              );
              await repository.createCompetence(newCompetence);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Competencia creada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              // Actualizar competencia existente
              final updatedCompetence = CompetenceModel(
                id: competence.id,
                externalId: competence.externalId,
                name: formData.name,
                competitionDate: formData.competitionDate,
                competitionLimitForRegistrationDate: formData.competitionLimitForRegistrationDate,
                nTurns: formData.nTurns,
                isActive: formData.isActive,
                createdBy: competence.createdBy,
                startCoordinates: formData.startCoordinates,
                finishCoordinates: formData.finishCoordinates,
              );
              await repository.updateCompetence(updatedCompetence);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Competencia actualizada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
            
            setState(() {}); // Refrescar la lista
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
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
              _buildSearchBar(isMobile),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCompetencesList(true, isMobile),
                    _buildCompetencesList(false, isMobile),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEditDialog(),
        backgroundColor: Color(0xFFD50000),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Nueva Competencia',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              'Gestionar Competencias',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar competencia...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.5)),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

Widget _buildTabBar() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: TabBar(
      controller: _tabController,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD50000), Color(0xFF8B0000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD50000).withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      indicatorPadding: EdgeInsets.all(4),
      dividerColor: Colors.transparent,
      tabs: [
        Tab(
          icon: Icon(Icons.check_circle_rounded, size: 24),
          text: 'Activas',
          height: 60,
        ),
        Tab(
          icon: Icon(Icons.cancel_rounded, size: 24),
          text: 'Inactivas',
          height: 60,
        ),
      ],
    ),
  );
}

  Widget _buildCompetencesList(bool isActive, bool isMobile) {
    return FutureBuilder<List<CompetenceModel>>(
      future: _getFilteredCompetences(isActive),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFD50000)),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error al cargar competencias',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActive ? Icons.event_busy : Icons.archive,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
                SizedBox(height: 16),
                Text(
                  isActive ? 'No hay competencias activas' : 'No hay competencias inactivas',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        }

        final competences = snapshot.data!;
        return ListView.builder(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          itemCount: competences.length,
          itemBuilder: (context, index) {
            return _buildCompetenceCard(competences[index], isMobile);
          },
        );
      },
    );
  }

  Widget _buildCompetenceCard(CompetenceModel competence, bool isMobile) {
    return FutureBuilder<int>(
      future: _getTotalRegistrations(competence.id),
      builder: (context, snapshot) {
        final registrations = snapshot.data ?? 0;

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
              color: competence.isActive
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: isMobile ? 45 : 50,
                      height: isMobile ? 45 : 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.emoji_events, color: Colors.white, size: isMobile ? 24 : 28),
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
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ID: ${competence.externalId}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: isMobile ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (competence.isActive ? Colors.green : Colors.red).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: competence.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Text(
                        competence.isActive ? 'Activa' : 'Inactiva',
                        style: TextStyle(
                          color: competence.isActive ? Colors.green : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.5), size: 16),
                    SizedBox(width: 8),
                    Text(
                      competence.competitionDate != null
                          ? '${competence.competitionDate!.day.toString().padLeft(2, '0')}/${competence.competitionDate!.month.toString().padLeft(2, '0')}/${competence.competitionDate!.year}'
                          : 'Sin fecha',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    ),
                    Spacer(),
                    Icon(Icons.loop, color: Colors.white.withOpacity(0.5), size: 16),
                    SizedBox(width: 8),
                    Text(
                      '${competence.nTurns} vueltas',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.white.withOpacity(0.5), size: 16),
                    SizedBox(width: 8),
                    Text(
                      '$registrations inscritos',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildActionButton(
                            label: 'Editar',
                            icon: Icons.edit,
                            onPressed: () => _showCreateEditDialog(competence: competence),
                          ),
                          SizedBox(height: 8),
                          _buildActionButton(
                            label: competence.isActive ? 'Desactivar' : 'Activar',
                            icon: competence.isActive ? Icons.block : Icons.check_circle,
                            color: competence.isActive ? Colors.red : Colors.green,
                            onPressed: () => _toggleCompetenceStatus(competence),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              label: 'Editar',
                              icon: Icons.edit,
                              onPressed: () => _showCreateEditDialog(competence: competence),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              label: competence.isActive ? 'Desactivar' : 'Activar',
                              icon: competence.isActive ? Icons.block : Icons.check_circle,
                              color: competence.isActive ? Colors.red : Colors.green,
                              onPressed: () => _toggleCompetenceStatus(competence),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Color(0xFFD50000),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _toggleCompetenceStatus(CompetenceModel competence) async {
    try {
      final updatedCompetence = CompetenceModel(
        id: competence.id,
        externalId: competence.externalId,
        name: competence.name,
        competitionDate: competence.competitionDate,
        competitionLimitForRegistrationDate: competence.competitionLimitForRegistrationDate,
        nTurns: competence.nTurns,
        isActive: !competence.isActive,
        createdBy: competence.createdBy,
        startCoordinates: competence.startCoordinates,
        finishCoordinates: competence.finishCoordinates,
      );

      await ref.read(rascUNLMainProvider).competenceRepository.updateCompetence(updatedCompetence);

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updatedCompetence.isActive ? 'Competencia activada' : 'Competencia desactivada',
          ),
          backgroundColor: updatedCompetence.isActive ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
