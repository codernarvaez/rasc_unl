// Archivo: push_notification_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart" as auth;
// ⬇️ Importación clave para leer el .env
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
// ⬆️
import 'package:unl_race/appInfo/app_info.dart';
import 'package:unl_race/global/global_var.dart';

class PushNotificationService {
  static Future<String> getAccessToken() async {
    
    // -----------------------------------------------------------------
    // 1. OBTENER y DECODIFICAR el JSON desde el .env
    // -----------------------------------------------------------------
    final String serviceAccountJsonString = dotenv.env['FIREBASE_SERVICE_ACCOUNT_JSON']!;
    
    final Map<String, dynamic> serviceAccountJson = 
        jsonDecode(serviceAccountJsonString);
    // -----------------------------------------------------------------


    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), 
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), 
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  static Future<void> sendNotificationToSelectedDriver(
    String deviceToken,
    BuildContext context,
    String tripID,
  ) async {
    final String serverKey = await getAccessToken(); 
    
    // -----------------------------------------------------------------
    // ✅ CORREGIDO: El project ID se obtiene del .env
    // -----------------------------------------------------------------
    final String projectId = dotenv.env['FIREBASE_PROJECT_ID_FCM']!;
    final String fcmEndPoint =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'; 
    // -----------------------------------------------------------------

    String dropOffDestinationAddress =
        Provider.of<AppInfo>(context, listen: false)
            .dropOffLocation!
            .placeName
            .toString();

    String pickUpLocationAddress = Provider.of<AppInfo>(context, listen: false)
        .pickUpLocation!
        .placeName
        .toString();

    Map<String, String> headerNotificationMap = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $serverKey',
    };

    Map titleBodyNotificationMap = {
      "title": "Nuevo viaje solicitada de: $userName", 
      "body":
          "Ubicación origen: $pickUpLocationAddress \nUbicación destino: $dropOffDestinationAddress",
    };

    Map dataMapNotification = {
      "tripID": tripID,
    };

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': titleBodyNotificationMap,
        'data': dataMapNotification
      }
    };

    try {
      await http.post(
        Uri.parse(fcmEndPoint),
        headers: headerNotificationMap,
        body: jsonEncode(message),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}