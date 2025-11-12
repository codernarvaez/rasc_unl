import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class ConnectionBanner extends ConsumerWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectionStatusProvider);

    return connection.when(
      data: (status) {
        final isOffline = status == InternetConnectionStatus.disconnected;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: isOffline ? Colors.red : Colors.green,
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Center(
            child: Text(
              isOffline ? 'Sin conexión - Modo offline' : 'Conectado a Internet',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
