import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_time_record_model.dart';

class ModeratorTimerPageImproved extends ConsumerStatefulWidget {
  const ModeratorTimerPageImproved({Key? key}) : super(key: key);

  @override
  ConsumerState<ModeratorTimerPageImproved> createState() => _ModeratorTimerPageImprovedState();
}

class _ModeratorTimerPageImprovedState extends ConsumerState<ModeratorTimerPageImproved> {
  CompetenceModel? _selectedCompetence;
  List<CompetenceModel> _activeCompetences = [];
  bool _isLoading = true;
  bool _hasCompetitionStarted = false;
  
  // Timer state
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Timer? _checkTimer;
  String _displayTime = "00:00.000";
  
  // Temporary marks (not saved yet)
  List<TemporaryMark> _temporaryMarks = [];
  int _nextMarkNumber = 1;

  @override
  void initState() {
    super.initState();
    _loadActiveCompetences();
    // Check every second if competition should start
    _checkTimer = Timer.periodic(Duration(seconds: 1), (_) => _checkCompetitionStart());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadActiveCompetences() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider).competenceRepository;
      final allCompetences = await repository.getAllCompetences();
      
      // Filter only active and not finished competences
      _activeCompetences = allCompetences
          .where((c) => c.isActive && !c.isFinished)
          .toList();
      
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

  void _checkCompetitionStart() {
    if (_selectedCompetence == null) return;
    
    final now = DateTime.now();
    final compDate = _selectedCompetence!.competitionDate;
    
    if (compDate == null) return;
    
    // Check if the competition date has arrived (same day or later)
    final competitionDay = DateTime(compDate.year, compDate.month, compDate.day);
    final today = DateTime(now.year, now.month, now.day);
    
    final shouldStart = !competitionDay.isAfter(today);
    
    if (shouldStart != _hasCompetitionStarted) {
      setState(() {
        _hasCompetitionStarted = shouldStart;
        if (shouldStart && !_stopwatch.isRunning) {
          _startTimer();
        }
      });
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

  void _resetTimer() {
    _stopwatch.reset();
    _timer?.cancel();
    setState(() {
      _displayTime = "00:00.000";
      _temporaryMarks.clear();
      _nextMarkNumber = 1;
    });
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String millisecondsStr = (milliseconds % 1000).toString().padLeft(3, '0');

    return "$minutesStr:$secondsStr.$millisecondsStr";
  }

  void _addTemporaryMark() {
    if (!_hasCompetitionStarted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La competencia aún no ha comenzado'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_stopwatch.isRunning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El cronómetro no está corriendo'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final mark = TemporaryMark(
      number: _nextMarkNumber,
      timeInMilliseconds: _stopwatch.elapsedMilliseconds,
      timestamp: DateTime.now(),
    );

    setState(() {
      _temporaryMarks.add(mark);
      _nextMarkNumber++;
    });

    // Visual feedback
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marca #${mark.number} registrada: ${mark.formattedTime}'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void _removeTemporaryMark(TemporaryMark mark) {
    setState(() {
      _temporaryMarks.remove(mark);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marca #${mark.number} eliminada'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _temporaryMarks.add(mark);
              _temporaryMarks.sort((a, b) => a.number.compareTo(b.number));
            });
          },
        ),
      ),
    );
  }

  Future<void> _saveMarkWithRegistration(TemporaryMark mark) async {
    final registrationController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.save, color: Color(0xFFD50000)),
            SizedBox(width: 12),
            Text(
              'Guardar Marca #${mark.number}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiempo: ${mark.formattedTime}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: registrationController,
              autofocus: true,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Número de Registro',
                labelStyle: TextStyle(color: Colors.white70),
                hintText: 'Ej: 001, 002, TEAM-A',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFD50000), width: 2),
                ),
                prefixIcon: Icon(Icons.tag, color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (registrationController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ingrese un número de registro'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD50000),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        final user = ref.read(currentUserProvider);
        final repository = ref.read(rascUNLMainProvider).competitionTimeRecordRepository;
        
        await repository.createTimeRecord(
          registrationNumber: registrationController.text.trim(),
          timeInMilliseconds: mark.timeInMilliseconds,
          competenceId: _selectedCompetence!.id,
          recordedByDni: user!.dni,
        );
        
        setState(() {
          _temporaryMarks.remove(mark);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tiempo guardado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cronómetro de Moderador'),
        backgroundColor: Color(0xFF1A1A2E),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadActiveCompetences();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
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
                      // Competition selector
                      _buildCompetenceSelector(isMobile),
                      SizedBox(height: 24),

                      if (_selectedCompetence != null) ...[
                        // Competition status
                        _buildCompetitionStatus(isMobile),
                        SizedBox(height: 24),

                        // Timer display
                        _buildTimerDisplay(isMobile),
                        SizedBox(height: 24),

                        // Mark button
                        _buildMarkButton(isMobile),
                        SizedBox(height: 32),

                        // Temporary marks list
                        _buildTemporaryMarks(isMobile),
                      ],
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: _selectedCompetence != null && _temporaryMarks.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _resetTimer,
              backgroundColor: Colors.red,
              icon: Icon(Icons.refresh),
              label: Text('Reiniciar Todo'),
            )
          : null,
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
                  _temporaryMarks.clear();
                  _nextMarkNumber = 1;
                  _resetTimer();
                });
                _checkCompetitionStart();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCompetitionStatus(bool isMobile) {
    final now = DateTime.now();
    final compDate = _selectedCompetence!.competitionDate;
    
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    if (_hasCompetitionStarted) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Competencia en curso';
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.schedule;
      statusText = 'Esperando inicio';
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (compDate != null)
                  Text(
                    'Fecha: ${compDate.day}/${compDate.month}/${compDate.year}',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
            size: isMobile ? 48 : 64,
          ),
          SizedBox(height: 16),
          Text(
            _displayTime,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 56 : 72,
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
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _stopwatch.isRunning
                  ? Colors.green.withOpacity(0.3)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _stopwatch.isRunning ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  _stopwatch.isRunning ? 'En Ejecución' : 'Pausado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkButton(bool isMobile) {
    return ElevatedButton(
      onPressed: _hasCompetitionStarted ? _addTemporaryMark : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 20 : 28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag, size: isMobile ? 32 : 40),
          SizedBox(width: 12),
          Text(
            'MARCAR TIEMPO',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemporaryMarks(bool isMobile) {
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
              Icon(Icons.list, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Marcas Temporales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_temporaryMarks.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (_temporaryMarks.isEmpty)
            Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Sin marcas aún.\nPresiona "MARCAR TIEMPO" para registrar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            )
          else
            ..._temporaryMarks.reversed.map((mark) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '#${mark.number}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        mark.formattedTime,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.save, color: Colors.green),
                      onPressed: () => _saveMarkWithRegistration(mark),
                      tooltip: 'Guardar con registro',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeTemporaryMark(mark),
                      tooltip: 'Eliminar',
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

class TemporaryMark {
  final int number;
  final int timeInMilliseconds;
  final DateTime timestamp;

  TemporaryMark({
    required this.number,
    required this.timeInMilliseconds,
    required this.timestamp,
  });

  String get formattedTime {
    int seconds = (timeInMilliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String millisecondsStr = (timeInMilliseconds % 1000).toString().padLeft(3, '0');

    return "$minutesStr:$secondsStr.$millisecondsStr";
  }
}
