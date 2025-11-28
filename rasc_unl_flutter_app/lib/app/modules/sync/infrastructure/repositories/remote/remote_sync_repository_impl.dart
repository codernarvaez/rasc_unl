import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/time_record_model.dart';

class SyncPushRequest {
  final List<CompetenceModel> competences;
  final List<CompetitionRegistrationModel> registrations;
  final List<TimeRecordModel> timeRecords;
  final String? deviceId;

  SyncPushRequest({
    this.competences = const [],
    this.registrations = const [],
    this.timeRecords = const [],
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'competences': competences.map((e) => _competenceToJson(e)).toList(),
      'registrations': registrations
          .map((e) => _registrationToJson(e))
          .toList(),
      'time_records': timeRecords.map((e) => _timeRecordToJson(e)).toList(),
      'device_id': deviceId,
    };
  }

  // Helper methods to match backend expected schema
  Map<String, dynamic> _competenceToJson(CompetenceModel c) {
    return {
      'id': c.id,
      'name': c.name,
      'competition_date': c.competitionDate?.toIso8601String(),
      'is_active': c.isActive,
      'is_finished': c.isFinished,
      'created_by': c.createdBy,
      'created_at': c.createdAt.toIso8601String(),
      'updated_at': c.updatedAt?.toIso8601String(),
      'sync_status': c.syncStatus.toString().split('.').last,
      'last_sync_at': c.lastSyncAt?.toIso8601String(),
      'version': c.version,
      'device_id': c.deviceId,
      'is_deleted': c.isDeleted,
    };
  }

  Map<String, dynamic> _registrationToJson(CompetitionRegistrationModel r) {
    return {
      'id': r.id,
      'dorsal_number': r.dorsalNumber,
      'name': r.name,
      'n_participants': r.nParticipants,
      'user_dni': r.userDni,
      'competence_id': r.competenceId,
      'created_at': r.createdAt.toIso8601String(),
      'updated_at': r.updatedAt?.toIso8601String(),
      'sync_status': r.syncStatus.toString().split('.').last,
      'last_sync_at': r.lastSyncAt?.toIso8601String(),
      'version': r.version,
      'device_id': r.deviceId,
      'is_deleted': r.isDeleted,
    };
  }

  Map<String, dynamic> _timeRecordToJson(TimeRecordModel t) {
    return {
      'id': t.id,
      'time': t.time.inMilliseconds,
      'competition_registration_id': t.competitionRegistrationId,
      'created_at': t.createdAt.toIso8601String(),
      'updated_at': t.updatedAt.toIso8601String(),
      'sync_status': t.syncStatus.toString().split('.').last,
      'last_sync_at': t.lastSyncAt?.toIso8601String(),
      'version': t.version,
      'device_id': t.deviceId,
      'is_deleted': t.isDeleted,
    };
  }
}

class SyncPullResponse {
  final List<CompetenceModel> competences;
  final List<CompetitionRegistrationModel> registrations;
  final List<TimeRecordModel> timeRecords;
  final DateTime syncTimestamp;

  SyncPullResponse({
    required this.competences,
    required this.registrations,
    required this.timeRecords,
    required this.syncTimestamp,
  });

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    return SyncPullResponse(
      competences: (json['competences'] as List)
          .map((e) => CompetenceModel.fromJson(e))
          .toList(),
      registrations: (json['registrations'] as List)
          .map((e) => CompetitionRegistrationModel.fromJson(e))
          .toList(),
      timeRecords: (json['time_records'] as List)
          .map((e) => TimeRecordModel.fromJson(e))
          .toList(),
      syncTimestamp: DateTime.parse(json['sync_timestamp']),
    );
  }
}

abstract class RemoteSyncRepository {
  Future<SyncPullResponse> pullSyncData({DateTime? since, String? userDni});
  Future<void> pushSyncData(SyncPushRequest data);
}

class RemoteSyncRepositoryImpl implements RemoteSyncRepository {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';
  final String? _accessToken;

  RemoteSyncRepositoryImpl({String? accessToken}) : _accessToken = accessToken;

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_accessToken != null && _accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  @override
  Future<SyncPullResponse> pullSyncData({
    DateTime? since,
    String? userDni,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }
      if (userDni != null) {
        queryParams['user_dni'] = userDni;
      }

      final uri = Uri.parse(
        '$_baseUrl/api/v1/sync/pull',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SyncPullResponse.fromJson(data);
      }

      throw Exception('Error pulling sync data: ${response.statusCode}');
    } catch (e) {
      throw Exception('Connection error during sync pull: $e');
    }
  }

  @override
  Future<void> pushSyncData(SyncPushRequest data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/sync/push'),
        headers: _headers,
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Error pushing sync data: ${errorData['detail'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Connection error during sync push: $e');
    }
  }
}
