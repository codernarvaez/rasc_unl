import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/shared/interfaces/wirgets/connection_banner.dart';
import 'package:rasc_unl_flutter_app/core/router/router.dart';
import 'package:flutter/foundation.dart'; // ya lo tienes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    // Continuar sin .env, usar valores por defecto
  }
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'UNL RASC',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: const Color(0xFFE1858B),
        ).copyWith(background: const Color(0xFFFFFFFF)),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF8B0000),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Color(0xFF2A2A2A), fontSize: 16),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFFD50000),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            alignment: Alignment.center,
            children: [
              // Contenido principal
              Positioned.fill(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: !kIsWeb),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),

              // Banner de conexión flotante y curvado
              FloatingConnectionBanner(),
            ],
          ),
        );
      },
    );
  }
}
