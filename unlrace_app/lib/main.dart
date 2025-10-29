import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ----------------------------------------------------
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Importación de dotenv
// ----------------------------------------------------
import 'package:unl_race/authentication/login_screen.dart';
import 'package:unl_race/firebase_options.dart';
import 'package:unl_race/pages/home_page.dart';
import 'package:unl_race/pages/splash_page.dart';

import 'appInfo/app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ------------------------------------------------------------------
  // 🔑 PASO DE SEGURIDAD: Cargar las variables de entorno del .env
  // Esto debe ocurrir ANTES de inicializar Firebase para que las opciones estén disponibles.
  // ------------------------------------------------------------------
  try {
    await dotenv.load(fileName: ".env"); 
    print('✅ Archivo .env cargado con éxito.');
  } catch (e) {
    print('⚠️ Error al cargar el archivo .env. Asegúrate de que existe y está en pubspec.yaml: $e');
  }
  // ------------------------------------------------------------------

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 👇 Solo suscribirse al topic en Android/iOS (no en Web)
  if (!kIsWeb) {
    try {
      await FirebaseMessaging.instance.subscribeToTopic("unl_raceapp");
      print('✅ Suscrito al topic unl_raceapp');
    } catch (e) {
      print('⚠️ Error al suscribirse al topic: $e');
    }
  } else {
    print('⚠️ Suscripción a topic no soportada en Flutter Web.');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppInfo()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UNLrace",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 252, 17, 0),
        ),
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const SplashPage()
          : const HomePage(),
    );
  }
}