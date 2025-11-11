import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/core/router/router.dart';
import 'package:flutter/foundation.dart';

void main() async {
  // await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter  = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'UNL RASC',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: (context, router) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: !kIsWeb && (Platform.isWindows || Platform.isLinux),
          ),
          child: router!,
        );
      },
    );  
  }
}
