import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class MyRecordsPage extends ConsumerStatefulWidget {
  const MyRecordsPage({super.key});

  @override
  ConsumerState<MyRecordsPage> createState() => _MyRecordsPageState();
}

class _MyRecordsPageState extends ConsumerState<MyRecordsPage> {
  List<RecordData> records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserRecords();
    });
  }

  Future<void> _loadUserRecords() async {
    setState(() => _isLoading = true);
    
    try {
      final repository = ref.read(rascUNLMainProvider);
      final currentUser = ref.read(currentUserProvider);
      
      if (currentUser == null) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario no autenticado'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Obtener todos los registros del usuario
      final userRegistrations = await repository.competitionRegistrationRepository
          .getRegistrationsByUserDni(currentUser.dni);
      
      // Obtener todas las competencias
      final allCompetences = await repository.competenceRepository.getAllCompetences();
      
      // Filtrar solo las competencias pasadas en las que participó
      final today = DateTime.now();
      final recordsList = <RecordData>[];
      
      for (var registration in userRegistrations) {
        // Solo incluir si tiene tiempo registrado (ha participado)
        if (registration.time == Duration.zero) continue;
        
        final competence = allCompetences.firstWhere(
          (c) => c.id == registration.competenceId,
          orElse: () => CompetenceModel(
            id: 0,
            externalId: '',
            name: 'Competencia no encontrada',
            competitionDate: null,
            competitionLimitForRegistrationDate: null,
            nTurns: 0,
            isActive: false,
            createdBy: '',
          ),
        );
        
        // Solo incluir competencias pasadas
        if (competence.competitionDate == null ||
            competence.competitionDate!.isAfter(today)) {
          continue;
        }
        
        // Obtener todos los registros de esta competencia para calcular posición
        final competenceRegistrations = await repository.competitionRegistrationRepository
            .getRegistrationsByCompetenceId(competence.id);
        
        // Filtrar solo los que tienen tiempo y ordenar
        final finishedParticipants = competenceRegistrations
            .where((r) => r.time != Duration.zero)
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));
        
        // Calcular posición
        final position = finishedParticipants.indexWhere(
              (r) => r.userDni == currentUser.dni && r.id == registration.id,
            ) + 1;
        
        if (position > 0) {
          recordsList.add(RecordData(
            competenceId: competence.id,
            competenceName: competence.name,
            position: position,
            time: registration.time,
            nTurns: registration.nTurns,
            date: competence.competitionDate!,
            totalParticipants: finishedParticipants.length,
            registrationNumber: registration.registrationNumber,
          ));
        }
      }
      
      // Ordenar por fecha (más reciente primero)
      recordsList.sort((a, b) => b.date.compareTo(a.date));
      
      if (mounted) {
        setState(() {
          records = recordsList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          records = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar records: $e'),
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
        decoration: BoxDecoration(
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
              : Column(
                  children: [
                    _buildHeader(context),
                    _buildStats(),
                    Expanded(
                      child: records.isEmpty
                          ? _buildEmptyState()
                          : _buildRecordsList(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mis Records',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadUserRecords,
              ),
            ],
          ),
          if (currentUser != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                '${currentUser.name} ${currentUser.lastName}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats() {
    int totalRaces = records.length;
    int podiums = records.where((r) => r.position <= 3).length;
    int victories = records.where((r) => r.position == 1).length;
    
    Duration? bestTime = records.isEmpty
        ? null
        : records.map((r) => r.time).reduce((a, b) => a < b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.emoji_events,
                  value: victories.toString(),
                  label: 'Victorias',
                  color: Color(0xFFFFD700),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.workspace_premium,
                  value: podiums.toString(),
                  label: 'Podios',
                  color: Color(0xFFD50000),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.flag,
                  value: totalRaces.toString(),
                  label: 'Carreras',
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.timer,
                  value: bestTime != null ? _formatDuration(bestTime) : '-',
                  label: 'Mejor Tiempo',
                  color: Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
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
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return _buildRecordCard(records[index], index);
      },
    );
  }

  Widget _buildRecordCard(RecordData record, int index) {
    Color positionColor = _getPositionColor(record.position);
    IconData positionIcon = _getPositionIcon(record.position);

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
          color: record.position <= 3
              ? positionColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navegar a detalles de la competencia
            context.push('/user/competence-details', extra: record.competenceId);
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
                        color: positionColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        positionIcon,
                        color: positionColor,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.competenceName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatDate(record.date),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: record.position <= 3
                            ? LinearGradient(
                                colors: [
                                  positionColor,
                                  positionColor.withOpacity(0.7)
                                ],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                              ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        record.position <= 3
                            ? _getPositionEmoji(record.position)
                            : '#${record.position}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoChip(
                      Icons.timer_outlined,
                      _formatDuration(record.time),
                    ),
                    _buildInfoChip(
                      Icons.loop,
                      '${record.nTurns} vueltas',
                    ),
                    _buildInfoChip(
                      Icons.people_outline,
                      '${record.totalParticipants} pilotos',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.6), size: 16),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sin records aún',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Participa en competencias para ver tus records',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/user/available-competences'),
              icon: const Icon(Icons.search),
              label: const Text('Ver Competencias'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD50000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Color(0xFFFFD700); // Oro
      case 2:
        return Color(0xFFC0C0C0); // Plata
      case 3:
        return Color(0xFFCD7F32); // Bronce
      default:
        return Color(0xFFD50000); // Rojo
    }
  }

  IconData _getPositionIcon(int position) {
    if (position <= 3) return Icons.emoji_events;
    return Icons.military_tech;
  }

  String _getPositionEmoji(int position) {
    switch (position) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '#$position';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class RecordData {
  final int competenceId;
  final String competenceName;
  final int position;
  final Duration time;
  final int nTurns;
  final DateTime date;
  final int totalParticipants;
  final int registrationNumber;

  RecordData({
    required this.competenceId,
    required this.competenceName,
    required this.position,
    required this.time,
    required this.nTurns,
    required this.date,
    required this.totalParticipants,
    required this.registrationNumber,
  });
}