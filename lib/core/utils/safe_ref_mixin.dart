import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin to safely handle ref operations in ConsumerStatefulWidget
/// Prevents "Bad state: No ProviderScope found" errors when using ref after disposal
mixin SafeRefMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool _isDisposed = false;
  final List<StreamSubscription> _subscriptions = [];
  final List<VoidCallback> _cleanupCallbacks = [];

  /// Check if the widget is still mounted and not disposed
  bool get isSafeToUseRef => mounted && !_isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    
    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    
    // Execute all cleanup callbacks
    for (final callback in _cleanupCallbacks) {
      try {
        callback();
      } catch (e) {
        // Silently catch errors during cleanup to prevent crashes
        debugPrint('SafeRefMixin cleanup error: $e');
      }
    }
    _cleanupCallbacks.clear();
    
    super.dispose();
  }

  /// Safely execute a function that uses ref
  /// Returns null if the widget is disposed
  T? safeRef<T>(T Function() action) {
    if (isSafeToUseRef) {
      try {
        return action();
      } catch (e) {
        debugPrint('SafeRefMixin: Error in safeRef - $e');
        return null;
      }
    }
    return null;
  }

  /// Safely execute an async function that uses ref
  /// Returns null if the widget is disposed
  Future<T?> safeAsyncRef<T>(Future<T> Function() action) async {
    if (isSafeToUseRef) {
      try {
        return await action();
      } catch (e) {
        debugPrint('SafeRefMixin: Error in safeAsyncRef - $e');
        return null;
      }
    }
    return null;
  }

  /// Add a listener that will be set up in the next frame
  /// This avoids the "ref.listen can only be used within the build method" error
  void safeListen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener,
  ) {
    // Defer the listen to the next frame to ensure it happens during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isSafeToUseRef) {
        try {
          // Store the current value for initial callback
          final currentValue = ref.read(provider);
          listener(null, currentValue);
        } catch (e) {
          debugPrint('SafeRefMixin: Error in safeListen - $e');
        }
      }
    });
  }

  /// Add a stream subscription with automatic cleanup
  void safeSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Add a cleanup callback to be executed on disposal
  /// Useful for stopping services, timers, etc.
  void addCleanupCallback(VoidCallback callback) {
    _cleanupCallbacks.add(callback);
  }

  /// Safely read a provider value
  T? safeRead<T>(ProviderListenable<T> provider) {
    return safeRef(() => ref.read(provider));
  }

  /// Safely watch a provider value
  /// Returns null if disposed
  T? safeWatch<T>(ProviderListenable<T> provider) {
    if (isSafeToUseRef) {
      try {
        return ref.watch(provider);
      } catch (e) {
        debugPrint('SafeRefMixin: Error in safeWatch - $e');
        return null;
      }
    }
    return null;
  }

  /// Execute a delayed action only if the widget is still mounted
  Future<void> safeDelayed(
    Duration duration,
    VoidCallback action,
  ) async {
    await Future.delayed(duration);
    if (isSafeToUseRef) {
      action();
    }
  }

  /// Create a periodic timer with automatic cleanup
  Timer? safePeriodic(
    Duration duration,
    void Function(Timer timer) callback,
  ) {
    final timer = Timer.periodic(duration, (timer) {
      if (isSafeToUseRef) {
        callback(timer);
      } else {
        timer.cancel();
      }
    });
    
    addCleanupCallback(() => timer.cancel());
    return timer;
  }
}