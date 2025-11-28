import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';
import 'package:uuid/uuid.dart';

class CompetenceDetailsPage extends ConsumerStatefulWidget {
  final String competenceId;

  const CompetenceDetailsPage({super.key, required this.competenceId});

  @override
  ConsumerState<CompetenceDetailsPage> createState() =>
      _CompetenceDetailsPageState();
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
      final competence = await repository.competenceRepository
          .getCompetenceById(widget.competenceId);

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
        final user = await repository.userRepository.getUserByDni(
          registration.userDni,
        );
        if (user != null) {
          participants.add(
            ParticipantData(
              dorsalNumber: registration.dorsalNumber,
              name: registration.name,
              dni: user.dni,
            ),
          );
        }
      }

      // Ordenar por número de dorsal
      participants.sort((a, b) => a.dorsalNumber.compareTo(b.dorsalNumber));

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
                  child: CircularProgressIndicator(color: Color(0xFFD50000)),
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
            _buildInfoItem(
              Icons.people,
              'Participantes',
              '${_participants.length}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationSection() {
    if (_competence == null) return const SizedBox.shrink();

    final currentUser = ref.watch(currentUserProvider);
    final canRegister = _competence!.isActive;

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
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
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
            ..._buildParticipantsList(),
        ],
      ),
    );
  }

  List<Widget> _buildParticipantsList() {
    final widgets = <Widget>[];

    for (var participant in _participants) {
      widgets.add(_buildParticipantCard(participant));
    }

    return widgets;
  }

  Widget _buildParticipantCard(ParticipantData participant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${participant.position ?? "-"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD50000).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${participant.dorsalNumber}',
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
          ],
        ),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    final ecuadorDate = toEcuadorTime(date);
    List<String> months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${ecuadorDate.day} ${months[ecuadorDate.month - 1]} ${ecuadorDate.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '--:--';
    final ecuadorDate = toEcuadorTime(date);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(ecuadorDate.hour)}:${twoDigits(ecuadorDate.minute)}';
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                border: Border.all(
                  color: const Color(0xFFD50000).withOpacity(0.3),
                ),
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
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
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
          .getRegistrationByUserAndCompetence(
            currentUser.dni,
            widget.competenceId,
          );

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

      // Generar número de dorsal
      final allRegistrations = await repository
          .competitionRegistrationRepository
          .getAllRegistrations();
      final existingNumbers = allRegistrations
          .where((r) => r.competenceId == widget.competenceId)
          .map((r) => int.tryParse(r.dorsalNumber) ?? 0)
          .toList();

      int newDorsalNumber = 1;
      while (existingNumbers.contains(newDorsalNumber)) {
        newDorsalNumber++;
      }

      // Crear registro
      final registration = CompetitionRegistrationModel(
        id: const Uuid().v4(),
        dorsalNumber: newDorsalNumber.toString(),
        nParticipants: 1,
        name: '${currentUser.firstName} ${currentUser.lastName}',
        userDni: currentUser.dni,
        competenceId: widget.competenceId,
        createdAt: utcNow(),
      );

      await repository.competitionRegistrationRepository.createRegistration(
        registration,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Registro exitoso! Número de dorsal: $newDorsalNumber',
            ),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCompetenceDetails();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class ParticipantData {
  final String dorsalNumber;
  final String name;
  final String dni;
  final int? position;

  ParticipantData({
    required this.dorsalNumber,
    required this.name,
    required this.dni,
    this.position,
  });

  ParticipantData copyWith({
    String? dorsalNumber,
    String? name,
    String? dni,
    int? position,
  }) {
    return ParticipantData(
      dorsalNumber: dorsalNumber ?? this.dorsalNumber,
      name: name ?? this.name,
      dni: dni ?? this.dni,
      position: position ?? this.position,
    );
  }
}
