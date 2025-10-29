import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class GenerarReporte extends StatefulWidget {
  final String competenciaId;
  final String nameCompetition;

  const GenerarReporte(
      {super.key, required this.competenciaId, required this.nameCompetition});

  @override
  State<GenerarReporte> createState() => _GenerarReporteState();
}

class _GenerarReporteState extends State<GenerarReporte> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final Map<String, List<Map<String, dynamic>>> _resultadosPorEquipo = {};
  final Map<String, String> _nombresEquipos = {};
  final Map<String, bool> _bonificacionesAplicadas = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final equiposSnapshot = await _database.child('teams').once();
    final resultadosSnapshot =
        await _database.child('resultados/${widget.competenciaId}').once();
    final bonificacionesSnapshot = await _database
        .child('competencia/${widget.competenciaId}/bonificaciones')
        .once();

    setState(() {
      for (var team in equiposSnapshot.snapshot.children) {
        final String teamId = team.key!;
        final String teamName = team.child('name').value as String;
        _nombresEquipos[teamId] = teamName;
      }

      for (var equipo in resultadosSnapshot.snapshot.children) {
        final String equipoId = equipo.key!;
        final List<Map<String, dynamic>> resultados =
            equipo.children.map((entry) {
          final Map data = entry.value as Map;
          return {
            'key': entry.key,
            'tiempo': data['tiempo'],
            'timestamp': data['timestamp'],
            'bonificacion': data['bonificacion'] ?? false,
          };
        }).toList();
        resultados.sort((a, b) {
          final tiempoA = Duration(
            hours: int.parse(a['tiempo'].split(':')[0]),
            minutes: int.parse(a['tiempo'].split(':')[1]),
            seconds: int.parse(a['tiempo'].split(':')[2].split('.')[0]),
            milliseconds: int.parse(a['tiempo'].split(':')[2].split('.')[1]),
          );
          final tiempoB = Duration(
            hours: int.parse(b['tiempo'].split(':')[0]),
            minutes: int.parse(b['tiempo'].split(':')[1]),
            seconds: int.parse(b['tiempo'].split(':')[2].split('.')[0]),
            milliseconds: int.parse(b['tiempo'].split(':')[2].split('.')[1]),
          );
          return tiempoA.compareTo(tiempoB);
        });
        _resultadosPorEquipo[equipoId] = resultados;
      }

      for (var bonificacion in bonificacionesSnapshot.snapshot.children) {
        final String equipoId = bonificacion.key!;
        _bonificacionesAplicadas[equipoId] = true;
      }
    });
  }

  List<Map<String, dynamic>> _obtenerResultadosGenerales() {
    List<Map<String, dynamic>> resultadosGenerales = [];

    _resultadosPorEquipo.forEach((equipoId, resultados) {
      for (var resultado in resultados) {
        resultadosGenerales.add({
          'equipoId': equipoId,
          'tiempo': resultado['tiempo'],
          'timestamp': resultado['timestamp'],
          'bonificacion': resultado['bonificacion'],
        });
      }
    });

    resultadosGenerales.sort((a, b) {
      final tiempoA = Duration(
        hours: int.parse(a['tiempo'].split(':')[0]),
        minutes: int.parse(a['tiempo'].split(':')[1]),
        seconds: int.parse(a['tiempo'].split(':')[2].split('.')[0]),
        milliseconds: int.parse(a['tiempo'].split(':')[2].split('.')[1]),
      );
      final tiempoB = Duration(
        hours: int.parse(b['tiempo'].split(':')[0]),
        minutes: int.parse(b['tiempo'].split(':')[1]),
        seconds: int.parse(b['tiempo'].split(':')[2].split('.')[0]),
        milliseconds: int.parse(b['tiempo'].split(':')[2].split('.')[1]),
      );
      return tiempoA.compareTo(tiempoB);
    });

    return resultadosGenerales;
  }

  Future<void> _generarPdf() async {
    final pdf = pw.Document();
    final resultadosGenerales = _obtenerResultadosGenerales();

    // Página 1: Resultados Generales Ordenados por Mejor Tiempo
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                  'Reporte de Competencia (${widget.nameCompetition})  - Resultados Generales',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              for (var i = 0; i < resultadosGenerales.length; i++)
                pw.Text(
                  '#${i + 1} - Equipo: ${_nombresEquipos[resultadosGenerales[i]['equipoId']] ?? resultadosGenerales[i]['equipoId']} - Tiempo: ${resultadosGenerales[i]['tiempo']} (Bonificación: ${resultadosGenerales[i]['bonificacion'] ? 'Sí' : 'No'})',
                  style: const pw.TextStyle(fontSize: 16),
                ),
            ],
          );
        },
      ),
    );

    // Página 2: Resultados por Equipo
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                  'Reporte de Competencia (${widget.nameCompetition}) - Resultados por Equipo',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              for (var equipoId in _resultadosPorEquipo.keys)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Equipo: ${_nombresEquipos[equipoId] ?? equipoId}',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text('Tiempos:',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    for (var resultado in _resultadosPorEquipo[equipoId]!)
                      pw.Text(
                          ' - ${resultado['tiempo']} (Bonificación: ${resultado['bonificacion'] ? 'Sí' : 'No'})'),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        'Bonificación aplicada: ${_bonificacionesAplicadas[equipoId] == true ? 'Sí' : 'No'}',
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 20),
                  ],
                ),
            ],
          );
        },
      ),
    );

    // Guardar el PDF en el dispositivo
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/reporte_competencia.pdf');
    await file.writeAsBytes(await pdf.save());

    // Compartir el PDF
    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'reporte_competencia${widget.competenciaId}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generar Reporte de Competencia',
          style: TextStyle(
            fontFamily: "QuicksandBold",
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _generarPdf,
          child: Text(
            'Generar Reporte  - ${widget.nameCompetition}',
            style: const TextStyle(
              fontFamily: "QuicksandBold",
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
