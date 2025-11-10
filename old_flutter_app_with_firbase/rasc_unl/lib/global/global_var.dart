import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Color color = const Color.fromARGB(255, 246, 246, 246);
Color primary = Color(0xFFdf0913);
Color secondary = Color.fromARGB(0, 254, 254, 254);
String userName = "";
String userApellido = "";
String userPhone = "";
String userRole = "";
String pass = "";
String idUserFirebaseAdmin = "";
String email = "";

String idCompetition = "";
String idTeam = "";
String competition = "";
String team = "";
String nro = "";

double userWallet = 0.0;
String? imageUser;
String userID = FirebaseAuth.instance.currentUser!.uid;
String googleMapKey = "";
String serverKeyFCM = "key=";

String countryShortCode = "ve";
final audiPlayer = AssetsAudioPlayer();

String apiDolarPriceUrl = "";
bool hasOverlayPermissionVar = false;
bool hasPostNotificationsPermissionVar = false;
double ratioUserGeoFire = 10;
