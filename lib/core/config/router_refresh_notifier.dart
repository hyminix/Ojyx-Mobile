import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

part 'router_refresh_notifier.g.dart';

/// Custom ChangeNotifier that allows protected member access
class _RouterRefreshListenable extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

/// Modern router refresh notifier using Riverpod 3.0 API
@riverpod
class RouterRefresh extends _$RouterRefresh {
  @override
  Listenable build() {
    final notifier = _RouterRefreshListenable();

    // Listen to auth state changes
    ref.listen(authNotifierProvider, (previous, next) {
      notifier.notify();
    });

    // Dispose the notifier when provider is disposed
    ref.onDispose(() {
      notifier.dispose();
    });

    return notifier;
  }
}
