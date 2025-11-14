import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_time_record_repository.dart';

class RemoteCompetitionTimeRecordRepositoryImpl implements CompetitionTimeRecordRepository {
  final String? accessToken;
  final String baseUrl = 'http://10.0.2.2:8000'; // Cambiar según tu configuración

  RemoteCompetitionTimeRecordRepositoryImpl({this.accessToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

  @override
  Future<CompetitionTimeRecordModel> createTimeRecord({
    required String? registrationNumber,
    required int timeInMilliseconds,
    required int competenceId,
    required String recordedByDni,
    int? position,
    bool isEarly = false,
    bool isReference = false,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/competencias/time-records');
    
    final body = jsonEncode({
      'registration_number': registrationNumber,
      'time': timeInMilliseconds,
      'competence_id': competenceId,
      'recorded_by_dni': recordedByDni,
      if (position != null) 'position': position,
      'is_early': isEarly,
      'is_reference': isReference,
    });

    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return CompetitionTimeRecordModel.fromJson(jsonData);
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Error al crear el registro de tiempo');
    } else if (response.statusCode == 404) {
      throw Exception('Competencia no encontrada');
    } else {
      throw Exception('Error al crear el registro de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<List<CompetitionTimeRecordModel>> getAllTimeRecords({
    int skip = 0,
    int limit = 100,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/competencias/time-records?skip=$skip&limit=$limit');
    
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final timeRecords = (jsonData['time_records'] as List)
          .map((tr) => CompetitionTimeRecordModel.fromJson(tr))
          .toList();
      return timeRecords;
    } else {
      throw Exception('Error al obtener registros de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<CompetitionTimeRecordModel> getTimeRecordById(int id) async {
    final url = Uri.parse('$baseUrl/api/v1/competencias/time-records/$id');
    
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return CompetitionTimeRecordModel.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      throw Exception('Registro de tiempo no encontrado');
    } else {
      throw Exception('Error al obtener registro de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<List<CompetitionTimeRecordModel>> getTimeRecordsByCompetenceId(
    int competenceId, {
    String? registrationNumber,
  }) async {
    String url = '$baseUrl/api/v1/competencias/$competenceId/time-records';
    if (registrationNumber != null && registrationNumber.isNotEmpty) {
      url += '?registration_number=$registrationNumber';
    }
    
    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final timeRecords = (jsonData['time_records'] as List)
          .map((tr) => CompetitionTimeRecordModel.fromJson(tr))
          .toList();
      return timeRecords;
    } else {
      throw Exception('Error al obtener registros de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<CompetitionTimeRecordModel> updateTimeRecord({
    required int id,
    String? registrationNumber,
    int? timeInMilliseconds,
    int? position,
    bool? isEarly,
    bool? isReference,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/competencias/time-records/$id');
    
    final Map<String, dynamic> body = {};
    if (registrationNumber != null) body['registration_number'] = registrationNumber;
    if (timeInMilliseconds != null) body['time'] = timeInMilliseconds;
    if (position != null) body['position'] = position;
    if (isEarly != null) body['is_early'] = isEarly;
    if (isReference != null) body['is_reference'] = isReference;

    final response = await http.patch(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return CompetitionTimeRecordModel.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      throw Exception('Registro de tiempo no encontrado');
    } else {
      throw Exception('Error al actualizar registro de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteTimeRecord(int id) async {
    final url = Uri.parse('$baseUrl/api/v1/competencias/time-records/$id');
    
    final response = await http.delete(url, headers: _headers);

    if (response.statusCode != 204) {
      if (response.statusCode == 404) {
        throw Exception('Registro de tiempo no encontrado');
      } else {
        throw Exception('Error al eliminar registro de tiempo: ${response.statusCode}');
      }
    }
  }

  @override
  Future<int> countTimeRecordsByCompetenceAndRegistration(
    int competenceId,
    String registrationNumber,
  ) async {
    final records = await getTimeRecordsByCompetenceId(
      competenceId,
      registrationNumber: registrationNumber,
    );
    return records.length;
  }
}
