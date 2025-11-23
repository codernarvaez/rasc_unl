import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_time_record_repository.dart';

class RemoteCompetitionTimeRecordRepositoryImpl implements CompetitionTimeRecordRepository {
  final String? accessToken;
  final String _baseUrl = dotenv.env['API_URL'] ?? '';

  RemoteCompetitionTimeRecordRepositoryImpl({this.accessToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

  @override
  Future<TimeRecordModel> createTimeRecord({
    required int registrationId,
    required int timeInMilliseconds,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/competencias/registrations/$registrationId/time-records');
    
    final body = jsonEncode({
      'time': timeInMilliseconds,
    });

    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return TimeRecordModel.fromJson(jsonData);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Error al crear el registro de tiempo');
    }
  }

  @override
  Future<TimeRecordModel?> getTimeRecordById(int id) async {
    final url = Uri.parse('$_baseUrl/api/v1/competencias/time-records/$id');
    
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return TimeRecordModel.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener registro de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<List<TimeRecordModel>> getTimeRecordsByRegistrationId(int registrationId) async {
    final url = Uri.parse('$_baseUrl/api/v1/competencias/registrations/$registrationId/time-records');
    
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final timeRecords = (jsonData['items'] as List)
          .map((tr) => TimeRecordModel.fromJson(tr))
          .toList();
      return timeRecords;
    } else {
      throw Exception('Error al obtener registros de tiempo: ${response.statusCode}');
    }
  }

  @override
  Future<TimeRecordModel> updateTimeRecord({
    required int id,
    required int timeInMilliseconds,
  }) async {
    final url = Uri.parse('$_baseUrl/api/v1/competencias/time-records/$id');
    
    final body = jsonEncode({
      'time': timeInMilliseconds,
    });

    final response = await http.patch(
      url,
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return TimeRecordModel.fromJson(jsonData);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Error al actualizar registro de tiempo');
    }
  }

  @override
  Future<void> deleteTimeRecord(int id) async {
    final url = Uri.parse('$_baseUrl/api/v1/competencias/time-records/$id');
    
    final response = await http.delete(url, headers: _headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar registro de tiempo: ${response.statusCode}');
    }
  }
}
