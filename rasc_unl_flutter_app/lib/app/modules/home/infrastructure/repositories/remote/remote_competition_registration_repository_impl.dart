import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competition_registration_repository.dart';

class RemoteCompetitionRegistrationRepositoryImpl
    implements CompetitionRegistrationRepository {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  final String? _accessToken;

  RemoteCompetitionRegistrationRepositoryImpl({String? accessToken})
      : _accessToken = accessToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  @override
  Future<List<CompetitionRegistrationModel>> getAllRegistrations() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/registro'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = data['competition_registrations'] as List;
        return registrations
            .map((json) => CompetitionRegistrationModel.fromJson(json))
            .toList();
      }

      throw Exception('Error al obtener registros: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener registros: $e');
    }
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(
      String userDni) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api/v1/competencias/registro?user_dni=$userDni&limit=1'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = data['competition_registrations'] as List;
        if (registrations.isNotEmpty) {
          return CompetitionRegistrationModel.fromJson(registrations.first);
        }
        return null;
      }

      throw Exception(
          'Error al obtener registro por DNI: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener registro por DNI: $e');
    }
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(
      int competitionId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api/v1/competencias/registro?competence_id=$competitionId&limit=1'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = data['competition_registrations'] as List;
        if (registrations.isNotEmpty) {
          return CompetitionRegistrationModel.fromJson(registrations.first);
        }
        return null;
      }

      throw Exception(
          'Error al obtener registro por competencia: ${response.statusCode}');
    } catch (e) {
      throw Exception(
          'Error de conexión al obtener registro por competencia: $e');
    }
  }

  @override
  Future<void> createRegistration(
      CompetitionRegistrationModel registration) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/competencias/registro'),
        headers: _headers,
        body: jsonEncode({
          'user_dni': registration.userDni,
          'external_id': registration.externalId,
          'registration_number': registration.registrationNumber.toString(),
          'time': registration.time.inMilliseconds,
          'n_turns': registration.nTurns,
          'competence_id': registration.competenceId,
        }),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al crear registro: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al crear registro: $e');
    }
  }

  @override
  Future<void> deleteRegistration(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/v1/competencias/registro/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al eliminar registro: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al eliminar registro: $e');
    }
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByCompetenceId(
      int competenceId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/$competenceId/registros'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = data['competition_registrations'] as List;
        return registrations
            .map((json) => CompetitionRegistrationModel.fromJson(json))
            .toList();
      }

      throw Exception(
          'Error al obtener registros de competencia: ${response.statusCode}');
    } catch (e) {
      throw Exception(
          'Error de conexión al obtener registros de competencia: $e');
    }
  }

  @override
  Future<void> updateNTurns(int id, int nTurns) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/v1/competencias/registro/$id'),
        headers: _headers,
        body: jsonEncode({
          'n_turns': nTurns,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al actualizar n_turns: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar n_turns: $e');
    }
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(
      String userDni, int competenceId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api/v1/competencias/registro?user_dni=$userDni&competence_id=$competenceId&limit=1'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = data['competition_registrations'] as List;
        if (registrations.isNotEmpty) {
          return CompetitionRegistrationModel.fromJson(registrations.first);
        }
        return null;
      }

      throw Exception(
          'Error al obtener registro por usuario y competencia: ${response.statusCode}');
    } catch (e) {
      throw Exception(
          'Error de conexión al obtener registro por usuario y competencia: $e');
    }
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(
      String userDni) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/registro?user_dni=$userDni'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = data['competition_registrations'] as List;
        return registrations
            .map((json) => CompetitionRegistrationModel.fromJson(json))
            .toList();
      }

      throw Exception(
          'Error al obtener registros por DNI: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener registros por DNI: $e');
    }
  }
}
