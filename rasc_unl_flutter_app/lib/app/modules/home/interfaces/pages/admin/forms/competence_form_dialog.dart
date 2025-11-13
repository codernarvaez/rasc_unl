import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';

class CompetenceFormDialog extends StatefulWidget {
  final CompetenceModel? competence;
  final Function(CompetenceFormData) onSave;

  const CompetenceFormDialog({Key? key, this.competence, required this.onSave})
    : super(key: key);

  @override
  State<CompetenceFormDialog> createState() => _CompetenceFormDialogState();
}

class CompetenceFormData {
  final String name;
  final int nTurns;
  final int? maxRegistrations;
  final DateTime competitionDate;
  final DateTime? competitionLimitForRegistrationDate;
  final bool isActive;
  final Map<String, List<double>> startCoordinates;
  final Map<String, List<double>> finishCoordinates;

  CompetenceFormData({
    required this.name,
    required this.nTurns,
    this.maxRegistrations,
    required this.competitionDate,
    this.competitionLimitForRegistrationDate,
    required this.isActive,
    required this.startCoordinates,
    required this.finishCoordinates,
  });
}

class _CompetenceFormDialogState extends State<CompetenceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _turnsController;
  late TextEditingController _maxRegistrationsController;
  late DateTime _selectedDate;
  late DateTime? _registrationLimitDate;
  late bool _isActive;

  // Start line points
  Position? _startPoint1;
  Position? _startPoint2;

  // Finish line points
  Position? _finishPoint1;
  Position? _finishPoint2;

  bool _useSameFinish = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.competence?.name ?? '',
    );
    _turnsController = TextEditingController(
      text: widget.competence?.nTurns.toString() ?? '1',
    );
    _maxRegistrationsController = TextEditingController(
      text: widget.competence?.maxRegistrations?.toString() ?? '',
    );
    _selectedDate = widget.competence?.competitionDate ?? DateTime.now();
    _registrationLimitDate =
        widget.competence?.competitionLimitForRegistrationDate;
    _isActive = widget.competence?.isActive ?? true;

    // Cargar coordenadas existentes si estamos editando
    if (widget.competence != null) {
      _loadExistingCoordinates();
    }
  }

  void _loadExistingCoordinates() {
    final comp = widget.competence!;

    // Start coordinates: point_x = [lat1, lat2], point_y = [lon1, lon2]
    if (comp.startCoordinates.containsKey('point_x') &&
        comp.startCoordinates.containsKey('point_y')) {
      final lats = comp.startCoordinates['point_x']!;
      final lons = comp.startCoordinates['point_y']!;

      if (lats.length >= 2 && lons.length >= 2) {
        _startPoint1 = Position(
          latitude: lats[0],
          longitude: lons[0],
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        _startPoint2 = Position(
          latitude: lats[1],
          longitude: lons[1],
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
    }

    // Finish coordinates
    if (comp.finishCoordinates.containsKey('point_x') &&
        comp.finishCoordinates.containsKey('point_y')) {
      final lats = comp.finishCoordinates['point_x']!;
      final lons = comp.finishCoordinates['point_y']!;

      if (lats.length >= 2 && lons.length >= 2) {
        _finishPoint1 = Position(
          latitude: lats[0],
          longitude: lons[0],
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        _finishPoint2 = Position(
          latitude: lats[1],
          longitude: lons[1],
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
    }

    // Check if coordinates are the same
    if (_startPoint1 != null &&
        _finishPoint1 != null &&
        _startPoint1!.latitude == _finishPoint1!.latitude &&
        _startPoint1!.longitude == _finishPoint1!.longitude &&
        _startPoint2 != null &&
        _finishPoint2 != null &&
        _startPoint2!.latitude == _finishPoint2!.latitude &&
        _startPoint2!.longitude == _finishPoint2!.longitude) {
      _useSameFinish = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _turnsController.dispose();
    super.dispose();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están desactivados');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permisos de ubicación denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permisos de ubicación denegados permanentemente');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _captureLocation(String type, int pointNumber) async {
    setState(() => _isLoading = true);
    try {
      final position = await _getCurrentLocation();

      setState(() {
        if (type == 'start') {
          if (pointNumber == 1) {
            _startPoint1 = position;
          } else {
            _startPoint2 = position;
          }

          // Si useSameFinish está activado, copiar automáticamente
          if (_useSameFinish) {
            if (pointNumber == 1) {
              _finishPoint1 = position;
            } else {
              _finishPoint2 = position;
            }
          }
        } else {
          if (pointNumber == 1) {
            _finishPoint1 = position;
          } else {
            _finishPoint2 = position;
          }
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ubicación capturada'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, List<double>> _buildCoordinateMap(
    Position? point1,
    Position? point2,
  ) {
    if (point1 == null || point2 == null) {
      return {
        "point_x": [0.0, 0.0],
        "point_y": [0.0, 0.0],
      };
    }

    return {
      "point_x": [point1.latitude, point2.latitude],
      "point_y": [point1.longitude, point2.longitude],
    };
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar que se hayan capturado ambos puntos de inicio
    if (_startPoint1 == null || _startPoint2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe capturar ambos puntos de la línea de inicio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar que se hayan capturado ambos puntos de meta
    if (_finishPoint1 == null || _finishPoint2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe capturar ambos puntos de la línea de meta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final formData = CompetenceFormData(
      name: _nameController.text.trim(),
      nTurns: int.parse(_turnsController.text),
      maxRegistrations: _maxRegistrationsController.text.trim().isEmpty 
          ? null 
          : int.parse(_maxRegistrationsController.text.trim()),
      competitionDate: _selectedDate,
      competitionLimitForRegistrationDate: _registrationLimitDate,
      isActive: _isActive,
      startCoordinates: _buildCoordinateMap(_startPoint1, _startPoint2),
      finishCoordinates: _buildCoordinateMap(_finishPoint1, _finishPoint2),
    );

    widget.onSave(formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final dialogWidth = isMobile ? screenWidth * 0.95 : 600.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 8 : 24),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(isMobile),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBasicInfoSection(isMobile),
                      SizedBox(height: 24),
                      _buildGPSSection(isMobile),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.competence == null ? Icons.add_circle : Icons.edit,
            color: Color(0xFFD50000),
            size: isMobile ? 24 : 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.competence == null
                  ? 'Nueva Competencia'
                  : 'Editar Competencia',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Información Básica',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),

        // Nombre
        _buildTextField(
          controller: _nameController,
          label: 'Nombre de la competencia',
          icon: Icons.emoji_events,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingrese el nombre';
            }
            return null;
          },
        ),
        SizedBox(height: 16),

        // Número de vueltas y fecha en fila en desktop
        isMobile
            ? Column(
                children: [
                  _buildTextField(
                    controller: _turnsController,
                    label: 'Número de vueltas',
                    icon: Icons.loop,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el número';
                      }
                      if (int.tryParse(value) == null || int.parse(value) < 1) {
                        return 'Debe ser mayor a 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _maxRegistrationsController,
                    label: 'Máximo de registros de tiempo (opcional)',
                    icon: Icons.timer,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (int.tryParse(value) == null || int.parse(value) < 1) {
                          return 'Debe ser mayor a 0';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _turnsController,
                      label: 'Número de vueltas',
                      icon: Icons.loop,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el número';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return 'Debe ser mayor a 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _maxRegistrationsController,
                      label: 'Máx. registros (opcional)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.tryParse(value) == null ||
                              int.parse(value) < 1) {
                            return 'Debe ser mayor a 0';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
        SizedBox(height: 16),

        // Fecha límite de registro
        Text(
          'Fecha de la competencia',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _buildDatePicker(),
        SizedBox(height: 8),
        Text(
          'Fecha Límite de Registro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _buildRegistrationLimitDatePicker(),
        SizedBox(height: 16),

        // Estado activo
        SwitchListTile(
          title: Text(
            'Competencia Activa',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          subtitle: Text(
            _isActive
                ? 'Los usuarios pueden inscribirse'
                : 'No visible para inscripciones',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          value: _isActive,
          activeColor: Color(0xFFD50000),
          onChanged: (value) {
            setState(() => _isActive = value);
          },
        ),
      ],
    );
  }

  Widget _buildGPSSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(color: Colors.white.withOpacity(0.2)),
        SizedBox(height: 16),

        Row(
          children: [
            Icon(Icons.map, color: Color(0xFFD50000), size: 20),
            SizedBox(width: 8),
            Text(
              'Ubicaciones GPS',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Capture 2 puntos para trazar cada línea (inicio y meta)',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 16),

        // Línea de inicio
        _buildLineSection(
          title: 'Línea de Inicio',
          icon: Icons.flag,
          color: Colors.green,
          point1: _startPoint1,
          point2: _startPoint2,
          onCapturePoint1: () => _captureLocation('start', 1),
          onCapturePoint2: () => _captureLocation('start', 2),
          isMobile: isMobile,
        ),
        SizedBox(height: 16),

        // Checkbox para usar misma ubicación
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Usar misma línea como meta',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Text(
              'La línea de inicio también será la meta',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
            value: _useSameFinish,
            activeColor: Color(0xFFD50000),
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _useSameFinish = value ?? false;
                if (_useSameFinish) {
                  _finishPoint1 = _startPoint1;
                  _finishPoint2 = _startPoint2;
                } else {
                  _finishPoint1 = null;
                  _finishPoint2 = null;
                }
              });
            },
          ),
        ),
        SizedBox(height: 16),

        // Línea de meta (solo si no es la misma)
        if (!_useSameFinish)
          _buildLineSection(
            title: 'Línea de Meta',
            icon: Icons.sports_score,
            color: Colors.blue,
            point1: _finishPoint1,
            point2: _finishPoint2,
            onCapturePoint1: () => _captureLocation('finish', 1),
            onCapturePoint2: () => _captureLocation('finish', 2),
            isMobile: isMobile,
          ),
      ],
    );
  }

  Widget _buildLineSection({
    required String title,
    required IconData icon,
    required Color color,
    required Position? point1,
    required Position? point2,
    required VoidCallback onCapturePoint1,
    required VoidCallback onCapturePoint2,
    required bool isMobile,
  }) {
    final bool hasPoint1 = point1 != null;
    final bool hasPoint2 = point2 != null;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (hasPoint1 && hasPoint2)
              ? color.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: (hasPoint1 && hasPoint2) ? color : Colors.white70,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ),
              if (hasPoint1 && hasPoint2)
                Icon(Icons.check_circle, color: color, size: 20),
            ],
          ),
          SizedBox(height: 12),

          // Punto 1
          _buildPointRow(
            pointNumber: 1,
            position: point1,
            onCapture: onCapturePoint1,
            color: color,
            isMobile: isMobile,
          ),
          SizedBox(height: 8),

          // Punto 2
          _buildPointRow(
            pointNumber: 2,
            position: point2,
            onCapture: onCapturePoint2,
            color: color,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildPointRow({
    required int pointNumber,
    required Position? position,
    required VoidCallback onCapture,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: position != null
            ? color.withOpacity(0.1)
            : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: position != null
              ? color.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isMobile ? 24 : 28,
                height: isMobile ? 24 : 28,
                decoration: BoxDecoration(
                  color: position != null ? color : Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$pointNumber',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  position != null
                      ? 'Punto $pointNumber capturado'
                      : 'Punto $pointNumber',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : onCapture,
                icon: Icon(
                  position != null ? Icons.refresh : Icons.my_location,
                  size: isMobile ? 14 : 16,
                ),
                label: Text(
                  position != null ? 'Recapturar' : 'Capturar',
                  style: TextStyle(fontSize: isMobile ? 11 : 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD50000),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: isMobile ? 6 : 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          if (position != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: isMobile ? 32 : 36),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lat: ${position.latitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isMobile ? 10 : 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'Lon: ${position.longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isMobile ? 10 : 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        // Primero seleccionar fecha
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 730)),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Color(0xFFD50000),
                  surface: Color(0xFF2A2A2A),
                ),
              ),
              child: child!,
            );
          },
        );

        if (date != null) {
          // Luego seleccionar hora
          if (mounted) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_selectedDate),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Color(0xFFD50000),
                      surface: Color(0xFF2A2A2A),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (time != null) {
              setState(() {
                _selectedDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              });
            } else {
              // Si cancela la hora, usar la fecha con la hora actual de _selectedDate
              setState(() {
                _selectedDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  _selectedDate.hour,
                  _selectedDate.minute,
                );
              });
            }
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white70, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white70, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationLimitDatePicker() {
    return InkWell(
      onTap: () async {
        // Calcular fecha inicial: si no hay límite, usar 1 día antes de la competencia
        // pero no menor a hoy
        final now = DateTime.now();
        final defaultDate = _selectedDate.subtract(Duration(days: 1));
        final initialDate =
            _registrationLimitDate ??
            (defaultDate.isBefore(now) ? now : defaultDate);

        // Primero seleccionar fecha
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: now,
          lastDate: _selectedDate,
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Color(0xFFD50000),
                  surface: Color(0xFF2A2A2A),
                ),
              ),
              child: child!,
            );
          },
        );

        if (date != null) {
          // Luego seleccionar hora
          if (mounted) {
            final time = await showTimePicker(
              context: context,
              initialTime: _registrationLimitDate != null
                  ? TimeOfDay.fromDateTime(_registrationLimitDate!)
                  : TimeOfDay.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Color(0xFFD50000),
                      surface: Color(0xFF2A2A2A),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (time != null) {
              setState(() {
                _registrationLimitDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              });
            }
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _registrationLimitDate != null
                ? Colors.orange.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _registrationLimitDate != null
                  ? Icons.event_available
                  : Icons.event_busy,
              color: _registrationLimitDate != null
                  ? Colors.orange
                  : Colors.white70,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _registrationLimitDate != null
                        ? '${_registrationLimitDate!.day.toString().padLeft(2, '0')}/${_registrationLimitDate!.month.toString().padLeft(2, '0')}/${_registrationLimitDate!.year}'
                        : 'Sin límite de registro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  _registrationLimitDate != null
                      ? Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white70,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${_registrationLimitDate!.hour.toString().padLeft(2, '0')}:${_registrationLimitDate!.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Toca para establecer fecha límite',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                ],
              ),
            ),
            if (_registrationLimitDate != null)
              IconButton(
                icon: Icon(Icons.clear, color: Colors.red, size: 18),
                onPressed: () {
                  setState(() {
                    _registrationLimitDate = null;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              )
            else
              Icon(Icons.edit, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFD50000)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: isMobile ? 14 : 16),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD50000),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
