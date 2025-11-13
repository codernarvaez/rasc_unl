import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/home/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/domain/repositories/competence_repository.dart';

class RemoteCompetenceRepositoryImpl implements CompetenceRepository {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  final String? _accessToken;

  RemoteCompetenceRepositoryImpl({String? accessToken})
      : _accessToken = accessToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  @override
  Future<List<CompetenceModel>> getAllCompetences() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final competences = data['competences'] as List;
        return competences
            .map((json) => CompetenceModel.fromJson(json))
            .toList();
      }

      throw Exception('Error al obtener competencias: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener competencias: $e');
    }
  }

  @override
  Future<CompetenceModel?> getCompetenceById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/competencias/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CompetenceModel.fromJson(data);
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception(
          'Error al obtener competencia por ID: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de conexión al obtener competencia: $e');
    }
  }

  @override
  Future<void> createCompetence(CompetenceModel competence) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/competencias/'),
        headers: _headers,
        body: jsonEncode({
          'name': competence.name,
          'competition_date': competence.competitionDate?.toIso8601String(),
          'created_by': competence.createdBy,
          'external_id': competence.externalId,
          'competition_limit_for_registration_date':
              competence.competitionLimitForRegistrationDate?.toIso8601String(),
          'n_turns': competence.nTurns,
          'is_active': competence.isActive,
          'start_coordinates': competence.startCoordinates,
          'finish_coordinates': competence.finishCoordinates,
        }),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al crear competencia: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al crear competencia: $e');
    }
  }

  @override
  Future<void> updateCompetence(CompetenceModel competence) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/v1/competencias/${competence.id}'),
        headers: _headers,
        body: jsonEncode({
          'external_id': competence.externalId,
          'name': competence.name,
          'competition_date': competence.competitionDate?.toIso8601String(),
          'competition_limit_for_registration_date':
              competence.competitionLimitForRegistrationDate?.toIso8601String(),
          'n_turns': competence.nTurns,
          'is_active': competence.isActive,
          'created_by': competence.createdBy,
          'start_coordinates': competence.startCoordinates,
          'finish_coordinates': competence.finishCoordinates,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al actualizar competencia: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar competencia: $e');
    }
  }

  @override
  Future<void> deleteCompetence(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/v1/competencias/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Error al eliminar competencia: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al eliminar competencia: $e');
    }
  }
}
