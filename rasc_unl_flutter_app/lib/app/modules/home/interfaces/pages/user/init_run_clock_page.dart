import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class InitRunClockPage extends ConsumerStatefulWidget {
  const InitRunClockPage({super.key});

  @override
  ConsumerState<InitRunClockPage> createState() => _InitRunClockState();
}

class _InitRunClockState extends ConsumerState<InitRunClockPage> with TickerProviderStateMixin {
  Timer? _timer;
  Timer? _refreshTimer;
  int _elapsedMilliseconds = 0;
  DateTime? _competitionDateTime;
  bool _isRunning = false;
  bool _isCountdown = false;
  int _countdownMilliseconds = 0;
  bool _isRegistered = false;
  bool _isLoading = true;
  
  CompetenceModel? _nextCompetence;
  CompetenceModel? _upcomingCompetence;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Cargar competencia y verificar estado cada minuto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNextCompetence();
      _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _loadNextCompetence();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshTimer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
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
            _upcomingCompetence = null;
            _isRegistered = false;
            _isLoading = false;
          });
        }
        return;
      }
      
      // Obtener todas las competencias activas
      final allCompetences = await repository.competenceRepository.getAllCompetences();
      final now = DateTime.now();
      
      // Filtrar competencias activas futuras (incluyendo hoy)
      final futureCompetences = allCompetences.where((comp) {
        if (comp.competitionDate == null || !comp.isActive) return false;
        final compDate = DateTime(
          comp.competitionDate!.year,
          comp.competitionDate!.month,
          comp.competitionDate!.day,
        );
        final today = DateTime(now.year, now.month, now.day);
        return compDate.isAfter(today) || compDate.isAtSameMomentAs(today);
      }).toList();
      
      // Ordenar por fecha más cercana
      futureCompetences.sort((a, b) => a.competitionDate!.compareTo(b.competitionDate!));
      
      if (futureCompetences.isEmpty) {
        setState(() {
          _nextCompetence = null;
          _upcomingCompetence = null;
          _isLoading = false;
        });
        return;
      }
      
      final nextComp = futureCompetences.first;
      final upcomingComp = futureCompetences.length > 1 ? futureCompetences[1] : null;
      
      // Verificar si está registrado en la próxima competencia
      final registration = await repository.competitionRegistrationRepository
          .getRegistrationByUserAndCompetence(currentUser.dni, nextComp.id);
      
      setState(() {
        _nextCompetence = nextComp;
        _upcomingCompetence = upcomingComp;
        _isRegistered = registration != null;
        _competitionDateTime = nextComp.competitionDate;
        _isLoading = false;
      });
      
      _checkTimeAndStart();
    } catch (e) {
      setState(() {
        _nextCompetence = null;
        _upcomingCompetence = null;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar competencias: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _checkTimeAndStart() {
    if (_competitionDateTime == null) return;

    final now = DateTime.now();
    final difference = _competitionDateTime!.difference(now);
    
    if (difference.inMilliseconds > 0) {
      // Iniciar cuenta regresiva
      _startCountdown(difference.inMilliseconds);
    } else if (difference.inMilliseconds > -3600000) {
      // Ya pasó la hora pero hace menos de 1 hora, iniciar cronómetro
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
    
    _pulseController.repeat(reverse: true);
    
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
    
    _pulseController.repeat(reverse: true);
    
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

  String _formatElapsedTime() {
    final totalSeconds = _elapsedMilliseconds ~/ 1000;
    final milliseconds = (_elapsedMilliseconds % 1000) ~/ 10;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
  }

  String _formatCountdown() {
    final totalSeconds = _countdownMilliseconds ~/ 1000;
    final milliseconds = (_countdownMilliseconds % 1000) ~/ 10;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
  }

  String _formatStartTime() {
    if (_competitionDateTime == null) return '--:--';
    return '${_competitionDateTime!.hour.toString().padLeft(2, '0')}:${_competitionDateTime!.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A2A2A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFD50000)))
              : _nextCompetence == null
                  ? _buildNoCompetencesView()
                  : _buildCompetenceView(isSmallScreen),
        ),
      ),
    );
  }

  Widget _buildNoCompetencesView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 100,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            const Text(
              'No hay competencias próximas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Consulta las competencias disponibles para más información',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/available-competences'),
              icon: const Icon(Icons.event),
              label: const Text('Ver Competencias'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD50000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetenceView(bool isSmallScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 40),
                
                // Información de la competencia
                _buildCompetenceInfo(isSmallScreen),
                
                SizedBox(height: isSmallScreen ? 20 : 30),
                
                // Estado de registro
                _buildRegistrationStatus(isSmallScreen),
                
                SizedBox(height: isSmallScreen ? 20 : 30),
                
                // Cronómetro
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTimer(isSmallScreen),
                ),
                
                SizedBox(height: isSmallScreen ? 20 : 30),
                
                // Información adicional
                if (_isRunning)
                  _buildRunningInfo(isSmallScreen)
                else if (_isCountdown)
                  _buildCountdownInfo(isSmallScreen),
                
                // Competencia siguiente
                if (_upcomingCompetence != null)
                  _buildUpcomingCompetence(isSmallScreen),
                
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompetenceInfo(bool isSmall) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nextCompetence!.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmall ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(_nextCompetence!.competitionDate),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: isSmall ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(Icons.access_time, _formatStartTime(), Colors.orange),
                _buildInfoChip(Icons.loop, '${_nextCompetence!.nTurns} vueltas', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationStatus(bool isSmall) {
    if (_nextCompetence == null) return const SizedBox.shrink();
    
    final now = DateTime.now();
    final canRegister = _nextCompetence!.competitionLimitForRegistrationDate != null &&
        now.isBefore(_nextCompetence!.competitionLimitForRegistrationDate!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isRegistered
              ? Colors.green.withOpacity(0.1)
              : (canRegister ? Colors.orange.withOpacity(0.1) : Colors.red.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isRegistered
                ? Colors.green
                : (canRegister ? Colors.orange : Colors.red),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isRegistered
                      ? Icons.check_circle
                      : (canRegister ? Icons.info : Icons.cancel),
                  color: _isRegistered
                      ? Colors.green
                      : (canRegister ? Colors.orange : Colors.red),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isRegistered
                            ? '¡Estás registrado!'
                            : (canRegister ? 'No estás registrado' : 'Registro cerrado'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmall ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isRegistered && canRegister) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Regístrate antes del ${_formatDateTime(_nextCompetence!.competitionLimitForRegistrationDate)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: isSmall ? 11 : 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (!_isRegistered && canRegister) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _showRegistrationDialog,
                icon: const Icon(Icons.how_to_reg, size: 18),
                label: const Text('Registrarme ahora'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD50000),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(bool isSmallScreen) {
    final timerSize = isSmallScreen ? 200.0 : 260.0;
    final fontSize = isSmallScreen ? 28.0 : 38.0;
    
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anillo exterior giratorio
          RotationTransition(
            turns: _rotationController,
            child: Container(
              width: timerSize + 40,
              height: timerSize + 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD50000).withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CustomPaint(
                painter: DottedCirclePainter(
                  color: const Color(0xFFD50000).withOpacity(0.3),
                ),
              ),
            ),
          ),
          
          // Círculo principal
          Container(
            width: timerSize,
            height: timerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFD50000).withOpacity(0.1),
                  const Color(0xFF8B0000).withOpacity(0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor().withOpacity(_isRunning || _isCountdown ? 0.4 : 0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.all(isSmallScreen ? 15 : 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2A2A2A),
                border: Border.all(
                  color: const Color(0xFFD50000).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isCountdown) ...[
                        Text(
                          'Comienza en:',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 12,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      
                      // Tiempo
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _isCountdown ? _formatCountdown() : _formatElapsedTime(),
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Labels
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTimeLabel('HRS', isSmallScreen),
                            SizedBox(width: isSmallScreen ? 8 : 14),
                            _buildTimeLabel('MIN', isSmallScreen),
                            SizedBox(width: isSmallScreen ? 8 : 14),
                            _buildTimeLabel('SEG', isSmallScreen),
                            SizedBox(width: isSmallScreen ? 4 : 8),
                            _buildTimeLabel('MS', isSmallScreen),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabel(String label, bool isSmall) {
    return Text(
      label,
      style: TextStyle(
        fontSize: isSmall ? 8 : 10,
        color: const Color(0xFFD50000).withOpacity(0.7),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildRunningInfo(bool isSmall) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            '¡La competencia está en curso!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: isSmall ? 13 : 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            '¡Sigue así! 💪',
            style: TextStyle(
              color: Color(0xFFD50000),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownInfo(bool isSmall) {
    if (_countdownMilliseconds <= 60000) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          '¡Prepárate para comenzar!',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: isSmall ? 13 : 15,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildUpcomingCompetence(bool isSmall) {
    if (_upcomingCompetence == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Siguiente competencia',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _upcomingCompetence!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(_upcomingCompetence!.competitionDate),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isCountdown) return Colors.orange;
    if (_isRunning) return const Color(0xFFD50000);
    return Colors.grey;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sin fecha';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
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
                    _nextCompetence!.name,
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
                        _formatDateTime(_nextCompetence!.competitionDate),
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
    try {
      final repository = ref.read(rascUNLMainProvider);
      final currentUser = ref.read(currentUserProvider);
      
      if (currentUser == null || _nextCompetence == null) return;
      
      // Verificar si ya está registrado
      final existing = await repository.competitionRegistrationRepository
          .getRegistrationByUserAndCompetence(currentUser.dni, _nextCompetence!.id);
      
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
      // Generar número de registro
      final allRegistrations = await repository.competitionRegistrationRepository.getAllRegistrations();
      final existingNumbers = allRegistrations
          .where((r) => r.competenceId == _nextCompetence!.id)
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
        registrationNumber: newRegistrationNumber,
        time: Duration.zero,
        userDni: currentUser.dni,
        nTurns: 0,
        competenceId: _nextCompetence!.id,
      );
      
      await repository.competitionRegistrationRepository.createRegistration(registration);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Registro exitoso! Número de dorsal: $newRegistrationNumber'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadNextCompetence();
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

class DottedCirclePainter extends CustomPainter {
  final Color color;

  DottedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    
    const dotCount = 60;
    const dotRadius = 3.0;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i * 360 / dotCount) * (math.pi / 180);
      final x = center.dx + radius * 0.95 * math.cos(angle);
      final y = center.dy + radius * 0.95 * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
