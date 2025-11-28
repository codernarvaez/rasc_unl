import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';
import 'package:uuid/uuid.dart';

class InitRunClockModeratorPage extends ConsumerStatefulWidget {
  const InitRunClockModeratorPage({super.key});

  @override
  ConsumerState<InitRunClockModeratorPage> createState() =>
      _InitRunClockModeratorState();
}

class _InitRunClockModeratorState
    extends ConsumerState<InitRunClockModeratorPage> {
  Timer? _timer;
  Timer? _refreshTimer;
  int _elapsedMilliseconds = 0;
  DateTime? _competitionDateTime;
  bool _isRunning = false;
  bool _isCountdown = false;
  int _countdownMilliseconds = 0;
  bool _isLoading = true;

  CompetenceModel? _nextCompetence;
  CompetitionRegistrationModel? _myRegistration;
  List<int> _recordedTimes = []; // Tiempos registrados en milisegundos

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNextCompetence();
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _loadNextCompetence();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadNextCompetence() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider);
      final currentUser = ref.read(currentUserProvider);

      if (currentUser == null) {
        if (mounted) {
          setState(() {
            _nextCompetence = null;
            _myRegistration = null;
            _isLoading = false;
          });
        }
        return;
      }

      // Obtener todas las competencias activas
      final allCompetences = await repository.competenceRepository
          .getAllCompetences();
      final currentTime = utcNow();

      // Filtrar competencias activas (hoy o futuras)
      final futureCompetences = allCompetences.where((comp) {
        if (comp.competitionDate == null || !comp.isActive) return false;
        final compDate = DateTime(
          comp.competitionDate!.year,
          comp.competitionDate!.month,
          comp.competitionDate!.day,
        );
        final today = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
        );
        return compDate.isAfter(today) || compDate.isAtSameMomentAs(today);
      }).toList();

      futureCompetences.sort(
        (a, b) => a.competitionDate!.compareTo(b.competitionDate!),
      );

      if (futureCompetences.isEmpty) {
        setState(() {
          _nextCompetence = null;
          _myRegistration = null;
          _isLoading = false;
        });
        return;
      }

      final nextComp = futureCompetences.first;

      // Verificar si el moderador está registrado
      final registration = await repository.competitionRegistrationRepository
          .getRegistrationByUserAndCompetence(currentUser.dni, nextComp.id);

      setState(() {
        _nextCompetence = nextComp;
        _myRegistration = registration;
        _competitionDateTime = nextComp.competitionDate;
        _isLoading = false;
      });

      // Cargar tiempos ya registrados si existen
      if (_myRegistration != null) {
        await _loadRecordedTimes();
      }

      _checkTimeAndStart();
    } catch (e) {
      setState(() {
        _nextCompetence = null;
        _myRegistration = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecordedTimes() async {
    if (_myRegistration == null) return;

    try {
      final repository = ref.read(rascUNLMainProvider);
      final records = await repository.competitionTimeRecordRepository
          .getTimeRecordsByRegistrationId(_myRegistration!.id);

      setState(() {
        _recordedTimes = records.map((r) => r.time.inMilliseconds).toList();
      });
    } catch (e) {
      print('Error loading recorded times: $e');
      // Error silencioso - no afecta la funcionalidad principal
    }
  }

  void _checkTimeAndStart() {
    if (_competitionDateTime == null) return;

    final currentTime = utcNow();
    final difference = _competitionDateTime!.difference(currentTime);

    if (difference.inMilliseconds > 0) {
      // Cuenta regresiva
      _startCountdown(difference.inMilliseconds);
    } else if (difference.inMilliseconds > -7200000) {
      // Menos de 2 horas desde inicio, iniciar cronómetro
      _startTimer(initialMilliseconds: -difference.inMilliseconds);
    }
  }

  void _startCountdown(int milliseconds) {
    _timer?.cancel();

    setState(() {
      _isCountdown = true;
      _countdownMilliseconds = milliseconds;
      _isRunning = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _countdownMilliseconds -= 100;

        if (_countdownMilliseconds <= 0) {
          _timer?.cancel();
          _isCountdown = false;
          _startTimer();
        }
      });
    });
  }

  void _startTimer({int initialMilliseconds = 0}) {
    _timer?.cancel();

    setState(() {
      _isRunning = true;
      _isCountdown = false;
      _elapsedMilliseconds = initialMilliseconds;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _elapsedMilliseconds += 100;
      });
    });
  }

  Future<void> _recordTime() async {
    if (!_isRunning || _myRegistration == null) return;

    final int totalParticipants = _myRegistration!.nParticipants;

    // Verificar si ya registró todos los tiempos
    if (_recordedTimes.length >= totalParticipants) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ya registraste los $totalParticipants tiempos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final repository = ref.read(rascUNLMainProvider);

      // Crear registro de tiempo
      final timeRecord = TimeRecordModel(
        id: const Uuid().v4(),
        time: Duration(milliseconds: _elapsedMilliseconds),
        competitionRegistrationId: _myRegistration!.id,
        createdAt: utcNow(),
        updatedAt: utcNow(),
      );

      await repository.competitionTimeRecordRepository.createTimeRecord(
        timeRecord,
      );

      setState(() {
        _recordedTimes.add(_elapsedMilliseconds);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tiempo ${_recordedTimes.length}/$totalParticipants registrado: ${_formatTime(_elapsedMilliseconds)}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Si completó todos los tiempos
      if (_recordedTimes.length >= totalParticipants) {
        _timer?.cancel();
        setState(() => _isRunning = false);

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => _buildCompletionDialog(),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar tiempo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCompletionDialog() {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 30),
          SizedBox(width: 12),
          Text('¡Completado!', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Has registrado todos los tiempos exitosamente',
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          ...List.generate(_recordedTimes.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Participante ${index + 1}:',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  Text(
                    _formatTime(_recordedTimes[index]),
                    style: const TextStyle(
                      color: Color(0xFFD50000),
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  String _formatTime(int milliseconds) {
    final totalSeconds = milliseconds ~/ 1000;
    final ms = (milliseconds % 1000) ~/ 10;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
  }

  String _formatCountdown() {
    final totalSeconds = _countdownMilliseconds ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cronómetro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNextCompetence,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD50000)),
            )
          : _nextCompetence == null
          ? _buildNoCompetence()
          : _myRegistration == null
          ? _buildNotRegistered()
          : _buildTimerView(),
    );
  }

  Widget _buildNoCompetence() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay competencias próximas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotRegistered() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No estás registrado en esta competencia',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _nextCompetence!.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerView() {
    final int totalParticipants = _myRegistration!.nParticipants;
    final int recordedCount = _recordedTimes.length;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Info
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1A1A1A),
                        const Color(0xFF1A1A1A).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD50000).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: Color(0xFFD50000),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nextCompetence!.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _myRegistration!.name,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatChip(
                              'Participantes',
                              '$totalParticipants',
                              Icons.groups,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatChip(
                              'Registrados',
                              '$recordedCount/$totalParticipants',
                              Icons.timer,
                              color: recordedCount == totalParticipants
                                  ? Colors.green
                                  : const Color(0xFFD50000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Timer Display
                Container(
                  height: 280,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isCountdown) ...[
                        Text(
                          'INICIA EN',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _formatCountdown(),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 64,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 2,
                          ),
                        ),
                      ] else ...[
                        Text(
                          _formatTime(_elapsedMilliseconds),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 4,
                            fontFeatures: [FontFeature.tabularFigures()],
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLabel('MIN'),
                            const SizedBox(width: 40),
                            _buildLabel('SEG'),
                            const SizedBox(width: 40),
                            _buildLabel('MS'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Recorded Times List
                if (_recordedTimes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            'TIEMPOS REGISTRADOS',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recordedTimes.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFD50000,
                                          ).withOpacity(0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Color(0xFFD50000),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'Participante ${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _formatTime(_recordedTimes[index]),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFeatures: [
                                            FontFeature.tabularFigures(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red.withOpacity(0.8),
                                          size: 22,
                                        ),
                                        onPressed: () =>
                                            _deleteTimeRecord(index),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        splashRadius: 24,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 80), // Space for FAB
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Bottom Action Area
        if (_isRunning && recordedCount < totalParticipants)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _recordTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD50000),
                  foregroundColor: Colors.white,
                  elevation: 8,
                  shadowColor: const Color(0xFFD50000).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'REGISTRAR TIEMPO',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Participante ${recordedCount + 1} de $totalParticipants',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFFD50000)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? const Color(0xFFD50000)).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? const Color(0xFFD50000)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color ?? const Color(0xFFD50000),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTimeRecord(int index) async {
    if (_myRegistration == null) return;

    try {
      final repository = ref.read(rascUNLMainProvider);

      // Need to find the actual record ID to delete from DB
      // Since _recordedTimes only stores int, we need to fetch records again or store models
      // For simplicity, let's fetch, find by time (risky if duplicates) or just reload
      // Better: Update _recordedTimes to store models or pairs (id, time)
      // But to avoid large refactor, let's fetch all records, sort by creation, and delete the one at index

      final records = await repository.competitionTimeRecordRepository
          .getTimeRecordsByRegistrationId(_myRegistration!.id);

      // Assuming records are returned in insertion order or we can sort them
      records.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      if (index < records.length) {
        final recordToDelete = records[index];
        await repository.competitionTimeRecordRepository.deleteTimeRecord(
          recordToDelete.id,
        );

        setState(() {
          _recordedTimes.removeAt(index);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tiempo eliminado'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar tiempo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _finishCompetence() async {
    if (_nextCompetence == null) return;

    try {
      final repository = ref.read(rascUNLMainProvider);
      // Create a copy with isFinished = true
      // Note: copyWith might not exist or be generated, check model.
      // Assuming copyWith exists as seen in other files.
      final updatedCompetence = CompetenceModel(
        id: _nextCompetence!.id,
        name: _nextCompetence!.name,
        competitionDate: _nextCompetence!.competitionDate,
        isActive: _nextCompetence!.isActive,
        isFinished: true,
        createdBy: _nextCompetence!.createdBy,
        createdAt: _nextCompetence!.createdAt,
        updatedAt: utcNow(),
        syncStatus: _nextCompetence!.syncStatus,
        lastSyncAt: _nextCompetence!.lastSyncAt,
        version: _nextCompetence!.version,
        deviceId: _nextCompetence!.deviceId,
        isDeleted: _nextCompetence!.isDeleted,
      );

      await repository.competenceRepository.updateCompetence(updatedCompetence);

      if (mounted) {
        Navigator.pop(context); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Competencia finalizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadNextCompetence(); // Refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al finalizar competencia: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFFD50000).withOpacity(0.5),
        fontSize: 10,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
