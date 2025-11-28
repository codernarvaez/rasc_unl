import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/application/services/sync_service.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class SyncIndicatorWidget extends ConsumerWidget {
  const SyncIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncService = ref.watch(syncServiceProvider);

    return ValueListenableBuilder<SyncStatus>(
      valueListenable: syncService.statusNotifier,
      builder: (context, status, child) {
        switch (status) {
          case SyncStatus.syncing:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          case SyncStatus.synced:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_done, color: Colors.green),
            );
          case SyncStatus.error:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_off, color: Colors.red),
            );
          case SyncStatus.pending:
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_upload, color: Colors.orange),
            );
        }
      },
    );
  }
}
