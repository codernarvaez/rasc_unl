import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/interfaces/pages/admin/forms/participant_form_dialog.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

class AdminCompetenceDetailsPage extends ConsumerStatefulWidget {
  final String competenceId;

  const AdminCompetenceDetailsPage({super.key, required this.competenceId});

  @override
  ConsumerState<AdminCompetenceDetailsPage> createState() =>
      _AdminCompetenceDetailsPageState();
}

class _AdminCompetenceDetailsPageState
    extends ConsumerState<AdminCompetenceDetailsPage> {
  CompetenceModel? _competence;
  List<ParticipantRegistration> _participants = [];
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

      // Crear lista de participantes con sus moderadores
      final participants = <ParticipantRegistration>[];

      for (var registration in registrations) {
        final moderator = await repository.userRepository.getUserByDni(
          registration.userDni,
        );
        if (moderator != null) {
          participants.add(
            ParticipantRegistration(
              registrationId: registration.id,
              dorsalNumber: registration.dorsalNumber,
              teamName: registration.name,
              moderatorName: '${moderator.firstName} ${moderator.lastName}',
              moderatorDni: moderator.dni,
              nParticipants: registration.nParticipants,
            ),
          );
        }
      }

      // Ordenar por número de dorsal
      participants.sort((a, b) => a.dorsalNumber.compareTo(b.dorsalNumber));

      if (mounted) {
        setState(() {
          _competence = competence;
          _participants = participants;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _competence = null;
          _participants = [];
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

  Future<void> _showAddParticipantDialog() async {
    if (!mounted) return;

    final result = await showDialog<CompetitionRegistrationModel>(
      context: context,
      builder: (context) =>
          ParticipantFormDialog(competenceId: widget.competenceId),
    );

    if (result == null) return;

    try {
      final repository = ref.read(rascUNLMainProvider);
      await repository.competitionRegistrationRepository.createRegistration(
        result,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Participante registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCompetenceDetails(); // Recargar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showEditParticipantDialog(
    ParticipantRegistration participant,
  ) async {
    // Obtener el registro completo
    final repository = ref.read(rascUNLMainProvider);
    final registrations = await repository.competitionRegistrationRepository
        .getRegistrationsByCompetenceId(widget.competenceId);

    final currentRegistration = registrations.firstWhere(
      (r) => r.id == participant.registrationId,
    );

    if (!mounted) return;

    final result = await showDialog<CompetitionRegistrationModel>(
      context: context,
      builder: (context) => ParticipantFormDialog(
        competenceId: widget.competenceId,
        participantToEdit: currentRegistration,
      ),
    );

    if (result == null) return;

    try {
      await repository.competitionRegistrationRepository.updateRegistration(
        result,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Participante actualizado exitosamente'),
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

  Future<void> _deleteParticipant(String registrationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text(
              'Confirmar eliminación',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este equipo/participante?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
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
      await repository.competitionRegistrationRepository.deleteRegistration(
        registrationId,
      );

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

  List<ParticipantRegistration> get _filteredParticipants {
    if (_searchQuery.isEmpty) return _participants;

    return _participants.where((participant) {
      final searchLower = _searchQuery.toLowerCase();
      return participant.dorsalNumber.toLowerCase().contains(searchLower) ||
          participant.teamName.toLowerCase().contains(searchLower) ||
          participant.moderatorName.toLowerCase().contains(searchLower) ||
          participant.moderatorDni.contains(_searchQuery);
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
      floatingActionButton: _competence != null && !_isLoading
          ? FloatingActionButton.extended(
              onPressed: _showAddParticipantDialog,
              backgroundColor: const Color(0xFFD50000),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Registrar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Competencia no encontrada',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withOpacity(0.6),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(_competence!.competitionDate),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                  '${_participants.length} ${_participants.length == 1 ? "equipo" : "equipos"}',
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  Icons.people,
                  '${_participants.fold<int>(0, (sum, p) => sum + p.nParticipants)} participantes',
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
    final filteredParticipants = _filteredParticipants;

    if (filteredParticipants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No hay participantes registrados'
                  : 'No se encontraron resultados',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredParticipants.length,
      itemBuilder: (context, index) {
        return _buildParticipantCard(filteredParticipants[index]);
      },
    );
  }

  Widget _buildParticipantCard(ParticipantRegistration participant) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono e info del dorsal
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.tag, color: Colors.white, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    participant.dorsalNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Información del equipo y moderador
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.groups,
                        color: Color(0xFFD50000),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          participant.teamName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.person_pin,
                        color: Colors.white.withOpacity(0.5),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          participant.moderatorName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.white.withOpacity(0.5),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${participant.nParticipants} ${participant.nParticipants == 1 ? "participante" : "participantes"}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Botones de acción
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFFD50000),
                    size: 22,
                  ),
                  onPressed: () => _showEditParticipantDialog(participant),
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 22),
                  onPressed: () =>
                      _deleteParticipant(participant.registrationId),
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Sin fecha';

    final ecuadorDate = toEcuadorTime(dateTime);
    final day = ecuadorDate.day.toString().padLeft(2, '0');
    final month = ecuadorDate.month.toString().padLeft(2, '0');
    final year = ecuadorDate.year;
    final hour = ecuadorDate.hour.toString().padLeft(2, '0');
    final minute = ecuadorDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}

class ParticipantRegistration {
  final String registrationId;
  final String dorsalNumber;
  final String teamName;
  final String moderatorName;
  final String moderatorDni;
  final int nParticipants;

  ParticipantRegistration({
    required this.registrationId,
    required this.dorsalNumber,
    required this.teamName,
    required this.moderatorName,
    required this.moderatorDni,
    required this.nParticipants,
  });
}
