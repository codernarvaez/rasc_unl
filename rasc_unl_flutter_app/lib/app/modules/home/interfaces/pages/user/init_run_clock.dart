import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class InitRunClock extends StatefulWidget {
  const InitRunClock({super.key});

  @override
  State<InitRunClock> createState() => _InitRunClockState();
}

class _InitRunClockState extends State<InitRunClock> with TickerProviderStateMixin {
  Timer? _timer;
  int _elapsedMilliseconds = 0;
  DateTime? _startTime; // Esta viene de la configuración
  bool _isRunning = false;
  bool _isCountdown = false;
  int _countdownMilliseconds = 0;
  
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

    // Simular hora configurada (esto vendría de tu sistema de configuración)
    _loadConfiguredTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  // Simula cargar la hora configurada del usuario
  void _loadConfiguredTime() {
    // TODO: Reemplazar con la hora real del usuario desde tu provider/database
    // Por ejemplo: ref.watch(userStartTimeProvider)
    
    // Ejemplo: hora configurada es 14:30
    final now = DateTime.now();
    setState(() {
      _startTime = DateTime(now.year, now.month, now.day, 14, 30);
      // Si quieres probar inmediatamente, usa:
      // _startTime = now.add(Duration(seconds: 10)); // 10 segundos en el futuro
    });
    
    _checkTimeAndStart();
    
    // Revisar cada minuto si hay cambios en la hora configurada
    Timer.periodic(Duration(minutes: 1), (timer) {
      _checkForTimeChanges();
    });
  }

  void _checkForTimeChanges() {
    // TODO: Verificar si la hora configurada cambió
    // Si cambió, llamar a _loadConfiguredTime() nuevamente
  }

  void _checkTimeAndStart() {
    if (_startTime == null) return;

    final now = DateTime.now();
    final difference = _startTime!.difference(now);
    
    if (difference.inMilliseconds > 0) {
      // Iniciar cuenta regresiva
      _startCountdown(difference.inMilliseconds);
    } else if (difference.inMilliseconds > -3600000) {
      // Ya pasó la hora pero hace menos de 1 hora, iniciar cronómetro
      _startTimer(initialMilliseconds: -difference.inMilliseconds);
    } else {
      // Pasó hace mucho tiempo, esperar hasta mañana a la misma hora
      final tomorrow = _startTime!.add(Duration(days: 1));
      final differenceToTomorrow = tomorrow.difference(now);
      _startCountdown(differenceToTomorrow.inMilliseconds);
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
    if (_startTime == null) return '--:--';
    return '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
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
          child: LayoutBuilder(
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
                      
                      // Título
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Cronómetro de Trabajo',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 12 : 20),
                      
                      // Hora configurada
                      if (_startTime != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: isSmallScreen ? 16 : 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Hora de inicio: ${_formatStartTime()}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      SizedBox(height: isSmallScreen ? 12 : 20),
                      
                      // Badge de estado
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor().withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getStatusColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _getStatusText(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: isSmallScreen ? 12 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 30 : 40),
                      
                      // Cronómetro circular
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _buildTimer(isSmallScreen),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 30 : 50),
                      
                      // Información adicional
                      if (_isRunning)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Text(
                                'Trabajando desde las ${_formatStartTime()}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: isSmallScreen ? 13 : 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '¡Sigue así! 💪',
                                style: TextStyle(
                                  color: Color(0xFFD50000),
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      if (_isCountdown && _countdownMilliseconds > 60000)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Prepárate para comenzar tu jornada',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: isSmallScreen ? 13 : 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      
                      SizedBox(height: isSmallScreen ? 20 : 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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
                  color: Color(0xFFD50000).withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CustomPaint(
                painter: DottedCirclePainter(
                  color: Color(0xFFD50000).withOpacity(0.3),
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
                  Color(0xFFD50000).withOpacity(0.1),
                  Color(0xFF8B0000).withOpacity(0.05),
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
                color: Color(0xFF2A2A2A),
                border: Border.all(
                  color: Color(0xFFD50000).withOpacity(0.3),
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
                        SizedBox(height: 4),
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
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 4),
                      
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
        color: Color(0xFFD50000).withOpacity(0.7),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Color _getStatusColor() {
    if (_isCountdown) return Colors.orange;
    if (_isRunning) return Color(0xFFD50000);
    return Colors.grey;
  }

  String _getStatusText() {
    if (_isCountdown) return 'Cuenta regresiva';
    if (_isRunning) return 'En ejecución';
    return 'Esperando hora de inicio';
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