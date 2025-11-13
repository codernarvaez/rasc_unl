import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class AvailableCompetencesPage extends ConsumerStatefulWidget {
  @override
  _AvailableCompetencesPageState createState() => _AvailableCompetencesPageState();
}

class _AvailableCompetencesPageState extends ConsumerState<AvailableCompetencesPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CompetenceModel>? _activeCompetences;
  List<CompetenceModel>? _pastCompetences;
  Map<int, bool> _userRegistrations = {};
  Map<int, int> _registrationCounts = {};
  bool _isLoading = true;
  String? _currentUserDni;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompetences();
    });
  }

  Future<void> _loadCompetences() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider);
      
      // Obtener todas las competencias activas
      final allCompetences = await repository.competenceRepository.getAllCompetences();
      final now = DateTime.now();
      
      // Filtrar competencias activas (futuras o de hoy)
      final active = allCompetences.where((comp) {
        if (comp.competitionDate == null) return false;
        return comp.isActive && comp.competitionDate!.isAfter(now.subtract(Duration(days: 1)));
      }).toList();
      
      // Ordenar por fecha más cercana primero
      active.sort((a, b) => a.competitionDate!.compareTo(b.competitionDate!));
      
      // Competencias pasadas (pueden estar activas o no)
      final past = allCompetences.where((comp) {
        if (comp.competitionDate == null) return false;
        return comp.competitionDate!.isBefore(now.subtract(Duration(days: 1)));
      }).toList();
      
      // Ordenar por fecha más reciente primero
      past.sort((a, b) => b.competitionDate!.compareTo(a.competitionDate!));
      
      // Obtener todos los registros
      final allRegistrations = await repository.competitionRegistrationRepository.getAllRegistrations();
      
      // TODO: Obtener el DNI del usuario actual (por ahora usamos uno de prueba)
      // En producción, deberías obtenerlo del usuario logueado
      _currentUserDni = "1234567890"; // Reemplazar con el DNI real del usuario logueado
      
      // Contar registros por competencia y verificar si el usuario está registrado
      for (var comp in allCompetences) {
        final compRegistrations = allRegistrations.where((r) => r.competenceId == comp.id).toList();
        _registrationCounts[comp.id] = compRegistrations.length;
        _userRegistrations[comp.id] = compRegistrations.any((r) => r.userDni == _currentUserDni);
      }
      
      if (mounted) {
        setState(() {
          _activeCompetences = active;
          _pastCompetences = past;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _activeCompetences = [];
          _pastCompetences = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar competencias: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD50000),
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildCompetencesList(_activeCompetences ?? [], isActive: true),
                          _buildCompetencesList(_pastCompetences ?? [], isActive: false),
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Competencias Disponibles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Selecciona una competencia para ver detalles',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadCompetences,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFFD50000),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: 'Próximas (${_activeCompetences?.length ?? 0})'),
          Tab(text: 'Pasadas (${_pastCompetences?.length ?? 0})'),
        ],
      ),
    );
  }

  Widget _buildCompetencesList(List<CompetenceModel> competences, {required bool isActive}) {
    if (competences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              isActive ? 'No hay competencias próximas' : 'No hay competencias pasadas',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCompetences,
      color: Color(0xFFD50000),
      child: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: competences.length,
        itemBuilder: (context, index) {
          return _buildCompetenceCard(competences[index], isActive);
        },
      ),
    );
  }

  Widget _buildCompetenceCard(CompetenceModel competence, bool isActive) {
    final isRegistered = _userRegistrations[competence.id] ?? false;
    final registrationCount = _registrationCounts[competence.id] ?? 0;
    final now = DateTime.now();
    final canRegister = competence.competitionLimitForRegistrationDate != null &&
        now.isBefore(competence.competitionLimitForRegistrationDate!);

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
          color: isRegistered
              ? Color(0xFFD50000).withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: isRegistered ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showCompetenceDetails(competence),
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
                        gradient: LinearGradient(
                          colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
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
                              Icon(Icons.calendar_today, size: 14, color: Colors.white.withOpacity(0.6)),
                              SizedBox(width: 4),
                              Text(
                                _formatDateTime(competence.competitionDate),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isRegistered)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFFD50000),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Registrado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.loop,
                      '${competence.nTurns} vueltas',
                      Colors.blue,
                    ),
                    SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.people,
                      '$registrationCount inscritos',
                      Colors.green,
                    ),
                  ],
                ),
                if (isActive && competence.competitionLimitForRegistrationDate != null) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        canRegister ? Icons.access_time : Icons.timer_off,
                        size: 14,
                        color: canRegister ? Colors.orange : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        canRegister
                            ? 'Registro hasta: ${_formatDateTime(competence.competitionLimitForRegistrationDate)}'
                            : 'Registro cerrado',
                        style: TextStyle(
                          color: canRegister ? Colors.orange : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                if (isActive && !isRegistered && canRegister) ...[
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showRegistrationDialog(competence),
                    icon: Icon(Icons.how_to_reg, size: 18),
                    label: Text('Registrarme'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD50000),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Fecha no definida';
    
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute';
  }

  void _showCompetenceDetails(CompetenceModel competence) {
    // TODO: Navegar a la página de detalles
    context.push('/user/competence-details', extra: competence);
  }

  void _showRegistrationDialog(CompetenceModel competence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.how_to_reg, color: Color(0xFFD50000)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Confirmar Registro',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Deseas registrarte en la siguiente competencia?',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFD50000).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competence.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white.withOpacity(0.6)),
                      SizedBox(width: 4),
                      Text(
                        _formatDateTime(competence.competitionDate),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.loop, size: 14, color: Colors.white.withOpacity(0.6)),
                      SizedBox(width: 4),
                      Text(
                        '${competence.nTurns} vueltas',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              '⚠️ Una vez registrado, no podrás cancelar tu inscripción.',
              style: TextStyle(
                color: Colors.orange.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _registerToCompetence(competence);
            },
            icon: Icon(Icons.check),
            label: Text('Confirmar Registro'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD50000),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerToCompetence(CompetenceModel competence) async {
    try {
      final repository = ref.read(rascUNLMainProvider);
      
      // Generar número de registro único (en un escenario real, esto sería generado por el backend)
      final allRegistrations = await repository.competitionRegistrationRepository.getAllRegistrations();
      final existingNumbers = allRegistrations
          .where((r) => r.competenceId == competence.id)
          .map((r) => r.registrationNumber)
          .toList();
      
      int newRegistrationNumber = 1;
      while (existingNumbers.contains(newRegistrationNumber)) {
        newRegistrationNumber++;
      }
      
      // Crear nuevo registro
      final registration = CompetitionRegistrationModel(
        id: 0, // Se generará automáticamente
        externalId: '${DateTime.now().millisecondsSinceEpoch}',
        registrationNumber: newRegistrationNumber,
        time: Duration.zero, // Sin tiempo aún
        userDni: _currentUserDni!,
        nTurns: 0, // Sin vueltas completadas aún
        competenceId: competence.id,
      );
      
      await repository.competitionRegistrationRepository.createRegistration(registration);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Registro exitoso! Número de dorsal: $newRegistrationNumber'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCompetences(); // Recargar lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrarse: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
