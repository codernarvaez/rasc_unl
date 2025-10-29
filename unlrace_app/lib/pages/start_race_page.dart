import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unl_race/pages/generar_reporte_page.dart';

class Cronometro extends StatefulWidget {
  final String name;
  final String idKey;
  final String status;
  const Cronometro({
    super.key,
    required this.name,
    required this.idKey,
    required this.status,
  });

  @override
  State<Cronometro> createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro> {
  late Timer _timer;
  late DateTime _startTime;
  Duration _elapsed = Duration.zero;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isRunning = false;
  String _timeDisplay = "00:00:00.00";
  final Map<String, List<Map<String, dynamic>>> _resultadosPorEquipo = {};
  final Map<String, List<Map<String, dynamic>>> _resultadosPorEquipoB = {};
  Map<String, String> _nombresEquipos = {};
  final Map<String, bool> _bonificacionesAplicadas = {};

  String _equipoGanador = "";
  String _tiempoGanador = "";
  List<String> _equiposOrdenados = [];
  List<String> _equiposOrdenadosB = [];

  void startTimer() {
    _startTime = DateTime.now();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final currentTime = DateTime.now();
      setState(() {
        _elapsed = currentTime.difference(_startTime);
        _timeDisplay = _formatDuration(_elapsed);
      });
      _database.child('competencia/${widget.idKey}/tiempo').set(_timeDisplay);
    });
  }

  void pauseTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void resumeTimer() {
    if (!_isRunning) {
      _startTime = DateTime.now().subtract(_elapsed);
      _isRunning = true;
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        final currentTime = DateTime.now();
        setState(() {
          _elapsed = currentTime.difference(_startTime);
          _timeDisplay = _formatDuration(_elapsed);
        });
        _database.child('competencia/${widget.idKey}/tiempo').set(_timeDisplay);
      });
    }
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _timeDisplay = "00:00:00.000";
      _isRunning = false;
    });
    _database.child('competencia/${widget.idKey}/tiempo').remove();
    _database.child('resultados/${widget.idKey}/').remove();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    //String threeDigits(int n) => n.toString().padLeft(3, "0");
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = twoDigits(duration.inMilliseconds.remainder(1000));
    return "$hours:$minutes:$seconds.$milliseconds";
  }

  @override
  void initState() {
    super.initState();

    // Obtener los nombres de los equipos una sola vez

    _database.child('teams').once().then((event) {
      _nombresEquipos = {};
      for (var team in event.snapshot.children) {
        final String teamId = team.key!;
        if (team.exists) {
          final Map data = team.value as Map;
          final int teamName = data["nro"];
          _nombresEquipos[teamId] = "$teamName-${data["category"]}";
        }
      }
      setState(() {});
    });

    _database.child('resultados/${widget.idKey}').onChildAdded.listen((event) {
      log("nuevo resultado");
      if (event.snapshot.exists) {
        final String equipoId = event.snapshot.key!;
        final Map datos = event.snapshot.value as Map;

        final List<Map<String, dynamic>> resultados =
            datos.entries.map((entry) {
          final Map data = entry.value as Map;
          return {
            'key': entry.key,
            'tiempo': data['tiempo'],
            'timestamp': data['timestamp'],
            'bonificacion': data['bonificacion'] ?? false,
          };
        }).toList();

        if (_nombresEquipos[equipoId]!.split("-")[1] == "Institucional") {
          _resultadosPorEquipo[equipoId] = resultados;
        } else if (_nombresEquipos[equipoId]!.split("-")[1] ==
            "Carrera de Pedagogía de la actividad Física y Deporte PAFD") {
          _resultadosPorEquipoB[equipoId] = resultados;
        }
        _actualizarEquipoGanador();
        setState(() {});
      }
    });

    _database
        .child('resultados/${widget.idKey}')
        .onChildChanged
        .listen((event) {
      log("nuevo resultado");
      final String equipoId = event.snapshot.key!;
      final Map datos = event.snapshot.value as Map;
      final List<Map<String, dynamic>> resultados = datos.entries.map((entry) {
        final Map data = entry.value as Map;
        return {
          'key': entry.key,
          'tiempo': data['tiempo'],
          'timestamp': data['timestamp'],
          'bonificacion': data['bonificacion'] ?? false,
        };
      }).toList();

      if (_nombresEquipos[equipoId]!.split("-")[1] == "Institucional") {
        _resultadosPorEquipo[equipoId] = resultados;
      } else if (_nombresEquipos[equipoId]!.split("-")[1] ==
          "Carrera de Pedagogía de la actividad Física y Deporte PAFD") {
        _resultadosPorEquipoB[equipoId] = resultados;
      }

      _actualizarEquipoGanador();
      setState(() {
        //  _resultadosPorEquipo[equipoId] = resultados;
      });
    });

    // BONIFICACIONES
    _database
        .child('competencia/${widget.idKey}/bonificaciones')
        .onChildAdded
        .listen((event) {
      final String equipoId = event.snapshot.key!;
      setState(() {
        _bonificacionesAplicadas[equipoId] = true;
        _actualizarEquipoGanador();
      });
    });
  }

  Map<String, dynamic> calcularSumatoria(
    List<Map<String, dynamic>> resultados,
    bool bonificacionAplicada,
  ) {
    Duration total = Duration.zero;
    int numParticipantes = 0;
    for (var resultado in resultados) {
      final partes = resultado['tiempo'].split(':');
      final hours = int.parse(partes[0]);
      final minutes = int.parse(partes[1]);
      final secondsMilliseconds = partes[2].split('.');
      final seconds = int.parse(secondsMilliseconds[0]);
      final milliseconds = int.parse(secondsMilliseconds[1]);
      final tiempo = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
      total += tiempo;
      numParticipantes++;
    }
    if (bonificacionAplicada) {
      total -= const Duration(seconds: 30);
    }
    return {
      'total': total.toString().split('.').first,
      'numParticipantes': numParticipantes,
    };
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _actualizarEquipoGanador() {
    // Ordenar los equipos por el mejor tiempo
    final equiposOrdenados = _resultadosPorEquipo.keys.toList()
      ..sort((a, b) {
        final sumA = calcularSumatoria(
            _resultadosPorEquipo[a]!, _bonificacionesAplicadas[a] ?? false);
        final sumB = calcularSumatoria(
            _resultadosPorEquipo[b]!, _bonificacionesAplicadas[b] ?? false);
        final tiempoA = Duration(
          hours: int.parse(sumA['total'].split(':')[0]),
          minutes: int.parse(sumA['total'].split(':')[1]),
          seconds: int.parse(sumA['total'].split(':')[2]),
        );
        final tiempoB = Duration(
          hours: int.parse(sumB['total'].split(':')[0]),
          minutes: int.parse(sumB['total'].split(':')[1]),
          seconds: int.parse(sumB['total'].split(':')[2]),
        );
        return tiempoA.compareTo(tiempoB);
      });

    // EQUIPO B

    final equiposOrdenadosB = _resultadosPorEquipoB.keys.toList()
      ..sort((a, b) {
        final sumA = calcularSumatoria(
            _resultadosPorEquipoB[a]!, _bonificacionesAplicadas[a] ?? false);
        final sumB = calcularSumatoria(
            _resultadosPorEquipoB[b]!, _bonificacionesAplicadas[b] ?? false);
        final tiempoA = Duration(
          hours: int.parse(sumA['total'].split(':')[0]),
          minutes: int.parse(sumA['total'].split(':')[1]),
          seconds: int.parse(sumA['total'].split(':')[2]),
        );
        final tiempoB = Duration(
          hours: int.parse(sumB['total'].split(':')[0]),
          minutes: int.parse(sumB['total'].split(':')[1]),
          seconds: int.parse(sumB['total'].split(':')[2]),
        );
        return tiempoA.compareTo(tiempoB);
      });

    setState(() {
      _equiposOrdenados = equiposOrdenados;
      _equiposOrdenadosB = equiposOrdenadosB;
    });
  }

  showModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Finalizar competencia",
          ),
          content: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Center(
                child: Text("Estas seguro de finalizar la competencia?"),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text(
                'Finalizar',
                style: TextStyle(fontFamily: "QuicksandMedium"),
              ),
              onPressed: () async {
                Navigator.pop(context);

                await _database
                    .child("competitions")
                    .child(widget.idKey)
                    .update({"status": "off"});

                if (!context.mounted) {
                  return;
                }

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return GenerarReporte(
                      competenciaId: widget.idKey,
                      nameCompetition: widget.name,
                    );
                  },
                ), (route) => false);
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontFamily: "QuicksandMedium",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tiempo: $_timeDisplay',
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "QuicksandMedium",
              ),
            ),
            const SizedBox(height: 20),
            _isRunning
                ? ElevatedButton(
                    onPressed: widget.status == "on" ? pauseTimer : null,
                    child: const Text(
                      'Pausar',
                      style: TextStyle(
                        fontFamily: "QuicksandMedium",
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: widget.status == "on"
                        ? _elapsed == Duration.zero
                            ? startTimer
                            : resumeTimer
                        : null,
                    child:
                        Text(_elapsed == Duration.zero ? 'Iniciar' : 'Reanudar',
                            style: const TextStyle(
                              fontFamily: "QuicksandMedium",
                            )),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.status == "on" ? resetTimer : null,
              child: const Text('Reset',
                  style: TextStyle(
                    fontFamily: "QuicksandMedium",
                  )),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultados Institucional - Mejor tiempo',
              style: TextStyle(
                fontFamily: "QuicksandBold",
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Equipo",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "#Meta",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Tiempo Total",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bono",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: _equiposOrdenados.length,
                itemBuilder: (context, index) {
                  final equipoId = _equiposOrdenados[index];

                  final sumatoria = calcularSumatoria(
                    _resultadosPorEquipo[equipoId]!,
                    _bonificacionesAplicadas[equipoId] ?? false,
                  );

                  final equipoNombre = _nombresEquipos[equipoId] ?? equipoId;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.grey[200],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("#${equipoNombre.split("-")[0]}"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${sumatoria['numParticipantes']}'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${sumatoria['total']}'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _bonificacionesAplicadas[equipoId] == true
                                    ? 'Sí'
                                    : 'No',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Resultados Carrera de Pedagogía de la actividad Física y Deporte PAFD - Mejor tiempo',
                style: TextStyle(
                  fontFamily: "QuicksandBold",
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Equipo",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "#Meta",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Tiempo Total",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bono",
                          style: TextStyle(
                            fontFamily: "QuicksandBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: _equiposOrdenadosB.length,
                itemBuilder: (context, index) {
                  final equipoId = _equiposOrdenadosB[index];

                  final sumatoria = calcularSumatoria(
                    _resultadosPorEquipoB[equipoId]!,
                    _bonificacionesAplicadas[equipoId] ?? false,
                  );

                  final equipoNombre = _nombresEquipos[equipoId] ?? equipoId;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.grey[200],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("#${equipoNombre.split("-")[0]}"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${sumatoria['numParticipantes']}'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${sumatoria['total']}'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _bonificacionesAplicadas[equipoId] == true
                                    ? 'Sí'
                                    : 'No',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModal();
              },
              child: const Text(
                "Finalizar competencia y generar reporte pdf",
                style: TextStyle(
                  fontFamily: "QuicksandBold",
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            /*
          Container(
              padding: const EdgeInsets.all(16),
              color: Colors.yellow[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Equipo que va ganando:',
                    style: TextStyle(
                      fontFamily: "QuicksandMedium",
                    ),
                  ),
                  Text(
                    '# del Equipo: $_equipoGanador',
                    style: const TextStyle(
                      fontFamily: "QuicksandMedium",
                    ),
                  ),
                  Text(
                    'Tiempo Total: $_tiempoGanador',
                    style: const TextStyle(
                      fontFamily: "QuicksandMedium",
                    ),
                  ),
                ],
              ),
            ),
        
          */
          ],
        ),
      ),
    );
  }
}
