import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/connectivity_service.dart';

part 'connectivity_provider.g.dart';

/// Provider for ConnectivityService instance
@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  final service = ConnectivityService();

  // Initialize the service
  service.initialize();

  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}

/// Provider for current connectivity status
@riverpod
ConnectivityStatus connectivityStatus(Ref ref) {
  final service = ref.watch(connectivityServiceProvider);

  // Listen to connectivity changes
  ref.listen(connectivityStatusStreamProvider.stream, (previous, next) {
    // Status will be updated via stream
  });

  return service.currentStatus;
}

/// Provider for connectivity status stream
@riverpod
Stream<ConnectivityStatus> connectivityStatusStream(Ref ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
}

/// Provider to check if currently online
@riverpod
bool isOnline(Ref ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.isOnline;
}

/// Provider to check if currently offline
@riverpod
bool isOffline(Ref ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.isOffline;
}
