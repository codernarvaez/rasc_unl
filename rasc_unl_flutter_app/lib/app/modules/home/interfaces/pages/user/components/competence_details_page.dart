import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class CompetenceDetailsPage extends ConsumerStatefulWidget {
  final int competenceId;

  const CompetenceDetailsPage({super.key, required this.competenceId});

  @override
  ConsumerState<CompetenceDetailsPage> createState() => _CompetenceDetailsPageState();
}

class _CompetenceDetailsPageState extends ConsumerState<CompetenceDetailsPage> {
  CompetenceModel? _competence;
  List<ParticipantData> _participants = [];
  bool _isLoading = true;
  bool _isRegistered = false;

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
      final currentUser = ref.read(currentUserProvider);
      
      // Obtener la competencia por ID
      final competence = await repository.competenceRepository.getCompetenceById(widget.competenceId);
      
      if (competence == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Competencia no encontrada'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
        }
        return;
      }
      
      // Obtener todos los registros de esta competencia
      final registrations = await repository.competitionRegistrationRepository
          .getRegistrationsByCompetenceId(widget.competenceId);
      
      // Obtener información de usuarios
      final participants = <ParticipantData>[];
      
      for (var registration in registrations) {
        final user = await repository.userRepository.getUserByDni(registration.userDni);
        if (user != null) {
          participants.add(ParticipantData(
            registrationNumber: registration.registrationNumber,
            name: '${user.name} ${user.lastName}',
            dni: user.dni,
            time: registration.time,
            nTurns: registration.nTurns,
          ));
        }
      }
      
      // Ordenar por tiempo (menor tiempo primero), los que no tienen tiempo al final
      participants.sort((a, b) {
        if ((a.time == null || a.time == Duration.zero) && (b.time == null || b.time == Duration.zero)) {
          return 0;
        } else if (a.time == null || a.time == Duration.zero) {
          return 1;
        } else if (b.time == null || b.time == Duration.zero) {
          return -1;
        }
        return a.time!.compareTo(b.time!);
      });
      
      // Asignar posiciones
      for (int i = 0; i < participants.length; i++) {
        participants[i] = participants[i].copyWith(position: i + 1);
      }
      
      // Verificar si el usuario actual está registrado
      if (currentUser != null) {
        _isRegistered = registrations.any((r) => r.userDni == currentUser.dni);
      }
      
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
                  child: CircularProgressIndicator(
                    color: Color(0xFFD50000),
                  ),
                )
              : _competence == null
                  ? _buildErrorView()
                  : Column(
                      children: [
                        _buildHeader(context),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildCompetenceInfo(),
                                _buildRegistrationSection(),
                                _buildLeaderboard(),
                              ],
                            ),
                          ),
                        ),
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

  Widget _buildHeader(BuildContext context) {
    if (_competence == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _competence!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
    );
  }

  Widget _buildCompetenceInfo() {
    if (_competence == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFD50000).withOpacity(0.15),
              const Color(0xFF8B0000).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD50000).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  Icons.calendar_today,
                  'Fecha',
                  _formatDate(_competence!.competitionDate),
                ),
                _buildInfoItem(
                  Icons.access_time,
                  'Hora',
                  _formatTime(_competence!.competitionDate),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  Icons.loop,
                  'Vueltas',
                  '${_competence!.nTurns}',
                ),
                _buildInfoItem(
                  Icons.people,
                  'Participantes',
                  '${_participants.length}',
                ),
              ],
            ),
            if (_competence!.competitionLimitForRegistrationDate != null) ...[
              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 20),
              _buildInfoItem(
                Icons.timer_off,
                'Límite de Registro',
                _formatDateTime(_competence!.competitionLimitForRegistrationDate),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationSection() {
    if (_competence == null) return const SizedBox.shrink();
    
    final currentUser = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final canRegister = _competence!.competitionLimitForRegistrationDate != null &&
        now.isBefore(_competence!.competitionLimitForRegistrationDate!) &&
        _competence!.isActive;

    if (_isRegistered) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.5)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Ya estás registrado!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Podrás ver tu posición una vez finalice la competencia',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (canRegister && currentUser != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          onPressed: _showRegistrationDialog,
          icon: const Icon(Icons.how_to_reg),
          label: const Text('Registrarme en esta competencia'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD50000),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD50000), size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 28),
              SizedBox(width: 12),
              Text(
                'Clasificación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_participants.isEmpty)
            _buildEmptyLeaderboard()
          else
            ..._buildGroupedParticipants(),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedParticipants() {
    // Agrupar participantes por número de registro (equipo)
    final groups = <String?, List<ParticipantData>>{};
    for (var participant in _participants) {
      if (!groups.containsKey(participant.registrationNumber)) {
        groups[participant.registrationNumber] = [];
      }
      groups[participant.registrationNumber]!.add(participant);
    }

    // Ordenar grupos por el mejor tiempo del equipo
    final sortedGroups = groups.entries.toList()
      ..sort((a, b) {
        final aBestTime = a.value
            .where((p) => p.time != null && p.time != Duration.zero)
            .map((p) => p.time!)
            .fold<Duration?>(null, (prev, curr) => prev == null || curr < prev ? curr : prev);
        final bBestTime = b.value
            .where((p) => p.time != null && p.time != Duration.zero)
            .map((p) => p.time!)
            .fold<Duration?>(null, (prev, curr) => prev == null || curr < prev ? curr : prev);
        
        if (aBestTime == null && bBestTime == null) return 0;
        if (aBestTime == null) return 1;
        if (bBestTime == null) return -1;
        return aBestTime.compareTo(bBestTime);
      });

    final widgets = <Widget>[];
    int position = 1;
    
    for (var group in sortedGroups) {
      final teamNumber = group.key;
      final members = group.value;
      
      // Verificar si algún miembro tiene tiempo registrado
      final hasTime = members.any((m) => m.time != null && m.time != Duration.zero);
      
      if (members.length == 1) {
        // Participante individual
        widgets.add(_buildParticipantCard(members.first, position, hasTime));
        if (hasTime) position++;
      } else {
        // Equipo
        widgets.add(_buildTeamCard(teamNumber, members, position, hasTime));
        if (hasTime) position++;
      }
    }

    return widgets;
  }

  Widget _buildParticipantCard(ParticipantData participant, int position, bool hasTime) {
    Color positionColor = _getPositionColor(position);
    bool isPodium = position <= 3 && hasTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPodium
            ? positionColor.withOpacity(0.08)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPodium
              ? positionColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: isPodium ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: isPodium
                    ? LinearGradient(colors: [positionColor, positionColor.withOpacity(0.7)])
                    : null,
                color: isPodium ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  hasTime ? (isPodium ? _getPositionEmoji(position) : '$position') : '-',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPodium ? 24 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD50000).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${participant.registrationNumber ?? "--"}',
                          style: const TextStyle(
                            color: Color(0xFFD50000),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          participant.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer, color: Color(0xFFD50000), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      hasTime && participant.time != null ? _formatDuration(participant.time!) : '--:--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(String? teamNumber, List<ParticipantData> members, int position, bool hasTime) {
    Color positionColor = _getPositionColor(position);
    bool isPodium = position <= 3 && hasTime;
    final bestTime = members
        .where((m) => m.time != null && m.time != Duration.zero)
        .map((m) => m.time!)
        .fold<Duration?>(null, (prev, curr) => prev == null || curr < prev ? curr : prev);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPodium
            ? positionColor.withOpacity(0.08)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPodium
              ? positionColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: isPodium ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: isPodium
                        ? LinearGradient(colors: [positionColor, positionColor.withOpacity(0.7)])
                        : null,
                    color: isPodium ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      hasTime ? (isPodium ? _getPositionEmoji(position) : '$position') : '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isPodium ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD50000).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#$teamNumber',
                              style: const TextStyle(
                                color: Color(0xFFD50000),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'EQUIPO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${members.length} miembros',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Color(0xFFD50000), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          bestTime != null ? _formatDuration(bestTime) : '--:--',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mejor tiempo',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: members.map((member) => _buildTeamMember(member)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(ParticipantData member) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'DNI: ${member.dni}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (member.time != null && member.time != Duration.zero)
            Text(
              _formatDuration(member.time!),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyLeaderboard() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin resultados aún',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1: return const Color(0xFFFFD700);
      case 2: return const Color(0xFFC0C0C0);
      case 3: return const Color(0xFFCD7F32);
      default: return const Color(0xFFD50000);
    }
  }

  String _getPositionEmoji(int position) {
    switch (position) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '$position';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    List<String> months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '--:--';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
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

  void _showRegistrationDialog() {
    if (_competence == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
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
              '¿Deseas registrarte en esta competencia?',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD50000).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _competence!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(_competence!.competitionDate),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
              _registerToCompetence();
            },
            icon: const Icon(Icons.check),
            label: const Text('Confirmar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD50000),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerToCompetence() async {
    if (_competence == null) return;
    
    try {
      final repository = ref.read(rascUNLMainProvider);
      final currentUser = ref.read(currentUserProvider);
      
      if (currentUser == null) return;
      
      // Verificar si ya está registrado
      final existing = await repository.competitionRegistrationRepository
          .getRegistrationByUserAndCompetence(currentUser.dni, widget.competenceId);
      
      if (existing != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ya estás registrado en esta competencia'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      
      // Generar número de registro
      final allRegistrations = await repository.competitionRegistrationRepository.getAllRegistrations();
      final existingNumbers = allRegistrations
          .where((r) => r.competenceId == widget.competenceId)
          .map((r) => r.registrationNumber)
          .toList();
      
      int newRegistrationNumber = 1;
      while (existingNumbers.contains(newRegistrationNumber)) {
        newRegistrationNumber++;
      }
      
      // Crear registro
      final registration = CompetitionRegistrationModel(
        id: 0,
        externalId: '${DateTime.now().millisecondsSinceEpoch}',
        registrationNumber: newRegistrationNumber.toString(),
        time: Duration.zero,
        userDni: currentUser.dni,
        nTurns: 0,
        competenceId: widget.competenceId,
      );
      
      await repository.competitionRegistrationRepository.createRegistration(registration);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Registro exitoso! Número de dorsal: $newRegistrationNumber'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCompetenceDetails();
      }
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
  }
}

class ParticipantData {
  final String? registrationNumber;
  final String name;
  final String dni;
  final Duration? time;
  final int? nTurns;
  final int? position;

  ParticipantData({
    this.registrationNumber,
    required this.name,
    required this.dni,
    this.time,
    this.nTurns,
    this.position,
  });

  ParticipantData copyWith({
    String? registrationNumber,
    String? name,
    String? dni,
    Duration? time,
    int? nTurns,
    int? position,
  }) {
    return ParticipantData(
      registrationNumber: registrationNumber ?? this.registrationNumber,
      name: name ?? this.name,
      dni: dni ?? this.dni,
      time: time ?? this.time,
      nTurns: nTurns ?? this.nTurns,
      position: position ?? this.position,
    );
  }
}
