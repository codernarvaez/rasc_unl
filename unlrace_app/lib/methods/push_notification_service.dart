import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart" as auth;
import 'package:unl_race/appInfo/app_info.dart';
import 'package:unl_race/global/global_var.dart';

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "flutter-taxi-app-b9ff5",
      "private_key_id": "9b92d3560981020aef6bc39fc9db84d29a638e76",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxzHXvCYbA+LkJ\ne4PoFbVjkmc73uFyXim1RwyRtstPGYFaWwK3XgXt61rTYU8Oe6yqQsxwDhfPHxVc\nleD7znOGz6iYhuELPB4xsZukj5OaO8eCfADfCKjtKqIe15rw3RfEdqfRW0IMraDH\nH2bNmsQjji0TWYLwR6yBuj1ifLa0bg60onBKcQCMMNBD4koHPJlXLZzUeFfhpn/E\nyg1g0inEUrnG7LhmOaFICj6XcHjwtNoXnDP9iU+Gv4dpFLxg3iC745q1+y5TsFQs\nqBRkezN9pqoEA0WJE5zBUqparK8xIML8xU8lAaD96s8iCoKb4uReuaG4luD/nrSU\nMl3Pg7FtAgMBAAECggEAIP6yfBOmgDUoEYxsZCtzJ/FJWyD3cYPr9Yoj2P61KA6x\npJTzIhg+vXJJvqR2SVfGKSqQSdMzs+ouyqm9wL0FT2VGAlg1dyJG8C3nllhWqe6i\nDaL5fmpa/vhEcbjNNhmxiXIDnqRy02t9RLadG1a3Q2nlD4wy8mg6qTBop9hBB6Z9\nht7EqMbvXgjsB2ixvTQ/pSD+T/5yGzhDC/zj3S732E+uOwZBAyHdxFG78SPWRMw8\nrOUeiOG0JG91Env/ENt+8i7QUrXOF0h7mCShhSEQ1GReObEaO/eHNLP9HA9PZoXk\ngtlqCL7h1U3BXLKO/RlFA2hlpzSa7UQGI/OgT9n5+QKBgQDmHlzuzoFnJc361c3S\njryKvs9AUhTGYlkeVMiJF20fHAvXqtPAvXoCj9sFYX2Gn2ij5au2kH6KsgGIMVwA\nrtzrSJLqrAF6mWPqksmvg5QrBzhnSy6ojbv1qRS3ClIeMzcW0iXZe5iaimFLLUEz\nsJy4oPZ9ZMr9NsvSlFG4nSRqiwKBgQDFy7Ammnc8rdIj77pEk3GD5O6aHto90BTL\nel0Kqb2CvKmXqkDgOStfcRdDlzNpW7o5yq0vy+08g4A0+nz2h+UBzXPpztMUvdKa\ngZLAHFU/VALa0nDB6/B8smGHCTLhBjiVy/H+8OqB6/060mTIt3zasAz1xmH3sx+D\nqFwoAd5q5wKBgBZLCLvF27lvayYKwnbMhy110MQtb3/MlU+f7RGC6HpkEC2jigIZ\nGRHYd+JskGmTVeLS5DC6jNfI6OcVyRDz38kXbcw4P6ht5cUa1VkgiSEmAOvY17tS\nh8wDxlL5N/1e/s5CK5KHK8CE+Wn8B14HlRc52MdLFXM0dMiAv+3/o0CDAoGBAIGQ\nIC3ZRru/nIQftyLOdjAQWN8p0Ilm8Qgseh/O+i1WSbzoMCDwMeIN4VBMDcg45q6O\nfY1uhlL6TJPndM3ETJU2sHP6H7hZc0f0El228XxPGqOd73CHjXsRGeNreiF+grhU\n5Iq74tEB9Vl/kbcMwkM5yPOBZJDti3ohYWRvfPMHAoGAYtaz163UrSLMD92Uew/d\nwmwoOD47iUEB0MqONnxbjw/H5WQGg+gCNnVERx2WRBW0i0eLaY3Z7R4OdgMXVmPU\nXZXjU6M9Ex8/3i2h6q8ssImQix62Oz2DMROGvyrb7IgaspHIjO45GlimnK7QVGKT\nZXFC9cv3vk39t/DKCgRLIT0=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-9t02s@flutter-taxi-app-b9ff5.iam.gserviceaccount.com",
      "client_id": "118015234714351206166",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9t02s%40flutter-taxi-app-b9ff5.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain access Token

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
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
    final String serverKey = await getAccessToken();
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
      "title": "Nuevo viaje solicitada de: $userName",
      "body":
          "Ubicación origen: $pickUpLocationAddress \nUbicación destino: $dropOffDestinationAddress",
    };

    //"sound": "alert_sound.mp3"

    Map dataMapNotification = {
      "tripID": tripID,
    };

    // Map bodyNotificationMap = {
    //   "notification": titleBodyNotificationMap,
    //   "data": dataMapNotification,
    //   "priority": "high",
    //   "to": deviceToken,
    // };

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
