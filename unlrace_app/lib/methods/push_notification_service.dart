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
    // Obtener la cadena JSON completa desde la variable de entorno
    final String serviceAccountJsonString = dotenv.env['FIREBASE_SERVICE_ACCOUNT_JSON']!;
    
    // Decodificar la cadena en un mapa (Map<String, dynamic>)
    final Map<String, dynamic> serviceAccountJson = 
        jsonDecode(serviceAccountJsonString);

    // El bloque anterior reemplaza todo el bloque JSON hardcodeado que causaba el problema.
    // -----------------------------------------------------------------


    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), // Usa el mapa decodificado
      scopes,
    );

    // Obtain access Token

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), // Usa el mapa decodificado
      scopes,
      client,
    );

    // close the http Client

    client.close();

    return credentials.accessToken.data;
  }

  static Future<void> sendNotificationToSelectedDriver(
    String deviceToken,
    BuildContext context,
    String tripID,
  ) async {
    // ⚠️ ATENCIÓN: Esta parte usa la clave de administrador para obtener el serverKey.
    // Esta lógica DEBE ser movida a un Cloud Function para seguridad.
    final String serverKey = await getAccessToken(); 
    
    // ⚠️ ATENCIÓN: El project ID sigue hardcodeado aquí. Lo ideal es moverlo al .env
    const String fcmEndPoint =
        'https://fcm.googleapis.com/v1/projects/flutter-taxi-app-b9ff5/messages:send'; 

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
      // Asumiendo que 'userName' es una variable global o de contexto
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