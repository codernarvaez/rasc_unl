import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/repositories/competition_registration_repository.dart';

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
    // Note: The API doesn't provide a direct endpoint for all registrations
    // This would need to iterate through competences or be implemented differently
    throw UnimplementedError('API does not provide endpoint for all registrations');
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserDni(
      String userDni) async {
    // The backend does not provide a direct endpoint to fetch a registration
    // by user DNI. We fetch registrations across all competences and filter.
    try {
      final competencesResponse = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/'),
        headers: _headers,
      );

      if (competencesResponse.statusCode != 200) {
        throw Exception('Error al obtener competencias: ${competencesResponse.statusCode} - ${competencesResponse.body}');
      }

      final competencesData = jsonDecode(competencesResponse.body);
      final competences = (competencesData['competences'] as List?) ?? [];

      for (final compJson in competences) {
        final compId = compJson['id'];
        if (compId == null) continue;

        final regs = await getRegistrationsByCompetenceId(compId as int);
        for (final r in regs) {
          if (r.userDni == userDni) return r;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Error de conexión al obtener registro por DNI: $e');
    }
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByCompetitionId(
      int competitionId) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v1/competencias/$competitionId/registrations');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = (data['items'] as List?) ?? [];
        if (registrations.isNotEmpty) {
          return CompetitionRegistrationModel.fromJson(registrations.first);
        }
        return null;
      }

      throw Exception(
          'Error al obtener registro por competencia: ${response.statusCode} - ${response.body}');
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
        Uri.parse('$_baseUrl/api/v1/competencias/${registration.competenceId}/registrations'),
        headers: _headers,
        body: jsonEncode({
          'dorsal_number': registration.dorsalNumber,
          'n_participants': registration.nParticipants,
          'name': registration.name,
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
        Uri.parse('$_baseUrl/api/v1/competencias/registrations/$id'),
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
        Uri.parse('$_baseUrl/api/v1/competencias/$competenceId/registrations'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registrations = (data['items'] as List?) ?? [];
        return registrations
        .map((json) => CompetitionRegistrationModel.fromJson(json))
        .toList();
      }

        throw Exception(
          'Error al obtener registros de competencia: ${response.statusCode} - ${response.body}');
    } catch (e) {
      throw Exception(
          'Error de conexión al obtener registros de competencia: $e');
    }
  }

  @override
  Future<CompetitionRegistrationModel?> getRegistrationByUserAndCompetence(
      String userDni, int competenceId) async {
    try {
      final regs = await getRegistrationsByCompetenceId(competenceId);
      for (final r in regs) {
        if (r.userDni == userDni) return r;
      }
      return null;
    } catch (e) {
      throw Exception(
          'Error de conexión al obtener registro por usuario y competencia: $e');
    }
  }

  @override
  Future<List<CompetitionRegistrationModel>> getRegistrationsByUserDni(
      String userDni) async {
    // No direct endpoint to get registrations by user; iterate competences and collect matches
    try {
      final competencesResponse = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/'),
        headers: _headers,
      );

      if (competencesResponse.statusCode != 200) {
        throw Exception('Error al obtener competencias: ${competencesResponse.statusCode} - ${competencesResponse.body}');
      }

      final competencesData = jsonDecode(competencesResponse.body);
      final competences = (competencesData['competences'] as List?) ?? [];

      final results = <CompetitionRegistrationModel>[];

      for (final compJson in competences) {
        final compId = compJson['id'];
        if (compId == null) continue;

        final regs = await getRegistrationsByCompetenceId(compId as int);
        results.addAll(regs.where((r) => r.userDni == userDni));
      }

      return results;
    } catch (e) {
      throw Exception('Error de conexión al obtener registros por DNI: $e');
    }
  }

  @override
  Future<void> updateRegistration(
      CompetitionRegistrationModel registration) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/v1/competencias/registrations/${registration.id}'),
        headers: _headers,
        body: jsonEncode({
          'dorsal_number': registration.dorsalNumber,
          'n_participants': registration.nParticipants,
          'name': registration.name,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al actualizar registro: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar registro: $e');
    }
  }
}
