import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class AdminCompetenceDetailsPage extends ConsumerStatefulWidget {
  final int competenceId;

  const AdminCompetenceDetailsPage({
    super.key,
    required this.competenceId,
  });

  @override
  ConsumerState<AdminCompetenceDetailsPage> createState() => _AdminCompetenceDetailsPageState();
}

class _AdminCompetenceDetailsPageState extends ConsumerState<AdminCompetenceDetailsPage> {
  CompetenceModel? _competence;
  List<ParticipantGroup> _participantGroups = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompetenceDetails();
    });
  }

  Future<void> _loadCompetenceDetails() async {
    setState(() => _isLoading = true);
    
    try {
      final repository = ref.read(rascUNLMainProvider);
      
      // Obtener la competencia
      final competence = await repository.competenceRepository
          .getCompetenceById(widget.competenceId);
      
      if (competence == null) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Competencia no encontrada'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Obtener todos los registros de esta competencia
      final registrations = await repository.competitionRegistrationRepository
          .getRegistrationsByCompetenceId(widget.competenceId);
      
      // Agrupar participantes por número de dorsal
      final groupsMap = <String, List<ParticipantData>>{};
      
      for (var registration in registrations) {
        final user = await repository.userRepository.getUserByDni(registration.userDni);
        if (user != null) {
          final dorsalNum = registration.dorsalNumber;
          
          if (!groupsMap.containsKey(dorsalNum)) {
            groupsMap[dorsalNum] = [];
          }
          
          groupsMap[dorsalNum]!.add(ParticipantData(
            registrationId: registration.id,
            dorsalNumber: registration.dorsalNumber,
            name: registration.name,
            dni: user.dni,
            nParticipants: registration.nParticipants,
          ));
        }
      }
      
      // Convertir a lista de grupos
      final groups = groupsMap.entries.map((entry) {
        return ParticipantGroup(
          dorsalNumber: entry.key,
          participants: entry.value,
        );
      }).toList();
      
      // Ordenar grupos por número de dorsal
      groups.sort((a, b) {
        return a.dorsalNumber.compareTo(b.dorsalNumber);
      });
      
      if (mounted) {
        setState(() {
          _competence = competence;
          _participantGroups = groups;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _competence = null;
          _participantGroups = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar detalles: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteParticipant(int registrationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Confirmar eliminación', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este participante?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    try {
      final repository = ref.read(rascUNLMainProvider);
      await repository.competitionRegistrationRepository.deleteRegistration(registrationId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Participante eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCompetenceDetails(); // Recargar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showEditRegistrationNumberDialog(ParticipantGroup group) async {
    final controller = TextEditingController(text: group.dorsalNumber);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: Color(0xFFD50000)),
            SizedBox(width: 12),
            Text('Editar número de registro', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.participants.length > 1
                  ? 'Este número se aplicará a todos los miembros del equipo (${group.participants.length} participantes)'
                  : 'Número de registro del participante',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Número de registro',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'Ej: 101',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD50000)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD50000), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              final newNumber = controller.text.trim();
              if (newNumber.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('El número de registro no puede estar vacío'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              Navigator.of(context).pop(newNumber);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD50000),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    
    if (result == null || result.isEmpty) return;
    
    try {
      final repository = ref.read(rascUNLMainProvider);
      
      // Actualizar todos los participantes del grupo
      for (var participant in group.participants) {
        final registration = CompetitionRegistrationModel(
          id: participant.registrationId,
          dorsalNumber: result,
          nParticipants: participant.nParticipants,
          name: participant.name,
          userDni: participant.dni,
          competenceId: widget.competenceId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await repository.competitionRegistrationRepository
            .updateRegistration(registration);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              group.participants.length > 1
                  ? 'Número actualizado para ${group.participants.length} participantes'
                  : 'Número de registro actualizado',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadCompetenceDetails(); // Recargar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<ParticipantGroup> get _filteredGroups {
    if (_searchQuery.isEmpty) return _participantGroups;
    
    return _participantGroups.where((group) {
      // Buscar en número de registro
      if (group.dorsalNumber.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return true;
      }
      
      // Buscar en nombres y DNIs de participantes
      return group.participants.any((p) =>
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.dni.contains(_searchQuery));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD50000)),
                )
              : _competence == null
                  ? _buildErrorView()
                  : Column(
                      children: [
                        _buildHeader(),
                        _buildCompetenceInfo(),
                        _buildSearchBar(),
                        Expanded(child: _buildParticipantsList()),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.withOpacity(0.5)),
            const SizedBox(height: 24),
            const Text(
              'Competencia no encontrada',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD50000),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.groups, color: Color(0xFFD50000), size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Gestionar Participantes',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadCompetenceDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetenceInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFD50000).withOpacity(0.15),
              const Color(0xFF8B0000).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD50000).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _competence!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.6), size: 16),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(_competence!.competitionDate),
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _competence!.isActive
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _competence!.isActive ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Text(
                    _competence!.isActive ? 'Activa' : 'Inactiva',
                    style: TextStyle(
                      color: _competence!.isActive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip(
                  Icons.groups,
                  '${_participantGroups.fold<int>(0, (sum, g) => sum + g.participants.length)} participantes',
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  Icons.tag,
                  '${_participantGroups.length} ${_participantGroups.length == 1 ? "grupo" : "grupos"}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFD50000), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, DNI o número...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFD50000)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD50000), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    final filteredGroups = _filteredGroups;
    
    if (filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'No hay participantes' : 'No se encontraron resultados',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredGroups.length,
      itemBuilder: (context, index) {
        return _buildGroupCard(filteredGroups[index]);
      },
    );
  }

  Widget _buildGroupCard(ParticipantGroup group) {
    final isTeam = group.participants.length > 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Header del grupo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isTeam ? Icons.groups : Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isTeam ? 'Equipo' : 'Individual',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD50000).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#${group.dorsalNumber}',
                              style: const TextStyle(
                                color: Color(0xFFD50000),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTeam
                            ? '${group.participants.length} miembros'
                            : group.participants.first.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFD50000)),
                  onPressed: () => _showEditRegistrationNumberDialog(group),
                  tooltip: 'Editar número',
                ),
              ],
            ),
          ),
          
          // Lista de participantes
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: group.participants
                  .map((participant) => _buildParticipantRow(participant, isTeam))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(ParticipantData participant, bool isInTeam) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isInTeam ? Icons.person : Icons.account_circle,
            color: Colors.white54,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'DNI: ${participant.dni}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _deleteParticipant(participant.registrationId),
            tooltip: 'Eliminar',
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Sin fecha';
    
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}

class ParticipantGroup {
  final String dorsalNumber;
  final List<ParticipantData> participants;

  ParticipantGroup({
    required this.dorsalNumber,
    required this.participants,
  });
}

class ParticipantData {
  final int registrationId;
  final String dorsalNumber;
  final String name;
  final String dni;
  final int nParticipants;

  ParticipantData({
    required this.registrationId,
    required this.dorsalNumber,
    required this.name,
    required this.dni,
    required this.nParticipants,
  });
}
