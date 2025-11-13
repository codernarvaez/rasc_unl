import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart';

class ModeratorTimerPage extends ConsumerStatefulWidget {
  const ModeratorTimerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ModeratorTimerPage> createState() => _ModeratorTimerPageState();
}

class _ModeratorTimerPageState extends ConsumerState<ModeratorTimerPage> {
  CompetenceModel? _selectedCompetence;
  List<CompetenceModel> _activeCompetences = [];
  bool _isLoading = true;
  
  // Timer state
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _displayTime = "00:00.000";
  
  // Registration state
  String _registrationNumber = "";
  List<CompetitionRegistrationModel> _currentRegistrations = [];
  int _registrationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadActiveCompetences();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadActiveCompetences() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider).competenceRepository;
      final allCompetences = await repository.getAllCompetences();
      
      // Filter only active competences
      _activeCompetences = allCompetences.where((c) => c.isActive).toList();
      
      // Sort by competition date (nearest first)
      _activeCompetences.sort((a, b) {
        if (a.competitionDate == null && b.competitionDate == null) return 0;
        if (a.competitionDate == null) return 1;
        if (b.competitionDate == null) return -1;
        return a.competitionDate!.compareTo(b.competitionDate!);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar competencias: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadRegistrations() async {
    if (_selectedCompetence == null) return;
    
    try {
      final repository = ref.read(rascUNLMainProvider).competitionRegistrationRepository;
      _currentRegistrations = await repository.getRegistrationsByCompetenceId(_selectedCompetence!.id);
      
      // Count registrations with the same registration number
      if (_registrationNumber.isNotEmpty) {
        _registrationCount = _currentRegistrations
            .where((r) => r.registrationNumber == _registrationNumber)
            .length;
      }
      
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar registros: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (mounted) {
          setState(() {
            _displayTime = _formatTime(_stopwatch.elapsedMilliseconds);
          });
        }
      });
    }
  }

  void _stopTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    _stopwatch.reset();
    _timer?.cancel();
    setState(() {
      _displayTime = "00:00.000";
    });
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String millisecondsStr = (hundreds % 100).toString().padLeft(3, '0');

    return "$minutesStr:$secondsStr.$millisecondsStr";
  }

  Future<void> _saveTime() async {
    if (_selectedCompetence == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccione una competencia'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_registrationNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingrese un número de registro'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (!_stopwatch.isRunning && _stopwatch.elapsedMilliseconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicie el cronómetro primero'), backgroundColor: Colors.orange),
      );
      return;
    }

    // Check if max registrations limit is reached
    if (_selectedCompetence!.maxRegistrations != null) {
      if (_registrationCount >= _selectedCompetence!.maxRegistrations!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se alcanzó el límite máximo de ${_selectedCompetence!.maxRegistrations} registros para este número'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    _stopTimer();

    try {
      final currentUser = ref.read(currentUserProvider);
      final repository = ref.read(rascUNLMainProvider).competitionRegistrationRepository;
      
      final newRegistration = CompetitionRegistrationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        userDni: currentUser?.dni ?? 'MODERATOR',
        competenceId: _selectedCompetence!.id,
        registrationNumber: _registrationNumber,
        time: Duration(milliseconds: _stopwatch.elapsedMilliseconds),
        nTurns: _selectedCompetence!.nTurns,
        externalId: null,
      );

      await repository.createRegistration(newRegistration);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tiempo registrado exitosamente'), backgroundColor: Colors.green),
        );
      }

      _resetTimer();
      await _loadRegistrations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar tiempo: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.white, size: isMobile ? 28 : 32),
                          SizedBox(width: 12),
                          Text(
                            'Cronómetro de Moderador',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Competition selector
                      _buildCompetenceSelector(isMobile),
                      SizedBox(height: 24),

                      if (_selectedCompetence != null) ...[
                        // Registration number input
                        _buildRegistrationNumberInput(isMobile),
                        SizedBox(height: 24),

                        // Timer display
                        _buildTimerDisplay(isMobile),
                        SizedBox(height: 24),

                        // Timer controls
                        _buildTimerControls(isMobile),
                        SizedBox(height: 32),

                        // Recent registrations
                        _buildRecentRegistrations(isMobile),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCompetenceSelector(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar Competencia',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          if (_activeCompetences.isEmpty)
            Text(
              'No hay competencias activas disponibles',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            )
          else
            DropdownButtonFormField<CompetenceModel>(
              value: _selectedCompetence,
              dropdownColor: Color(0xFF1A1A2E),
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
              items: _activeCompetences.map((competence) {
                return DropdownMenuItem<CompetenceModel>(
                  value: competence,
                  child: Text(
                    '${competence.name} - ${competence.competitionDate != null ? "${competence.competitionDate!.day}/${competence.competitionDate!.month}/${competence.competitionDate!.year}" : "Sin fecha"}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCompetence = value;
                  _registrationNumber = "";
                  _registrationCount = 0;
                  _resetTimer();
                });
                _loadRegistrations();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRegistrationNumberInput(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Número de Registro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_selectedCompetence?.maxRegistrations != null) ...[
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _registrationCount >= _selectedCompetence!.maxRegistrations!
                        ? Colors.red.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_registrationCount/${_selectedCompetence!.maxRegistrations}',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12),
          TextFormField(
            initialValue: _registrationNumber,
            style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 18),
            decoration: InputDecoration(
              hintText: 'Ej: 001, 002, TEAM-A...',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              prefixIcon: Icon(Icons.tag, color: Colors.white70),
            ),
            onChanged: (value) {
              setState(() {
                _registrationNumber = value.trim();
              });
              _loadRegistrations();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.timer,
            color: Colors.white,
            size: isMobile ? 40 : 48,
          ),
          SizedBox(height: 16),
          Text(
            _displayTime,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 48 : 64,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'MIN:SEG.MIL',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 12 : 14,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerControls(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
          label: _stopwatch.isRunning ? 'Pausar' : 'Iniciar',
          color: _stopwatch.isRunning ? Colors.orange : Colors.green,
          onPressed: _stopwatch.isRunning ? _stopTimer : _startTimer,
          isMobile: isMobile,
        ),
        _buildControlButton(
          icon: Icons.stop,
          label: 'Reset',
          color: Colors.red,
          onPressed: _resetTimer,
          isMobile: isMobile,
        ),
        _buildControlButton(
          icon: Icons.save,
          label: 'Guardar',
          color: Colors.blue,
          onPressed: _saveTime,
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required bool isMobile,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 24,
          vertical: isMobile ? 12 : 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isMobile ? 24 : 28),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: isMobile ? 12 : 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRegistrations(bool isMobile) {
    final recentRegistrations = _currentRegistrations
        .where((r) => r.registrationNumber == _registrationNumber)
        .toList();
    
    recentRegistrations.sort((a, b) {
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      return a.time!.compareTo(b.time!);
    });

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Registros de ${_registrationNumber.isEmpty ? "este número" : _registrationNumber}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (recentRegistrations.isEmpty)
            Text(
              'No hay registros aún',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            )
          else
            ...recentRegistrations.take(5).map((reg) {
              final timeStr = reg.time != null 
                  ? _formatTime(reg.time!.inMilliseconds)
                  : 'Sin tiempo';
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      '${reg.nTurns ?? 0} vueltas',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
