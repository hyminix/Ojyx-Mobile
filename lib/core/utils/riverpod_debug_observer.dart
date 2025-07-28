import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A custom ProviderObserver for debugging Riverpod lifecycle events
/// Tracks provider creation, disposal, and ref usage errors
class RiverpodDebugObserver extends ProviderObserver {
  static bool _debugMode = false;
  
  /// Enable or disable debug mode
  static bool get debugMode => _debugMode;
  static set debugMode(bool value) {
    _debugMode = value;
    if (value && kDebugMode) {
      debugPrint('🔍 Riverpod Debug Mode: ENABLED');
    }
  }
  
  /// Check if RIVERPOD_DEBUG environment variable is set
  static bool get isDebugEnvironment {
    const debugEnv = String.fromEnvironment('RIVERPOD_DEBUG');
    return debugEnv == 'true' || debugEnv == '1';
  }
  
  RiverpodDebugObserver() {
    // Auto-enable if environment variable is set
    if (isDebugEnvironment) {
      debugMode = true;
    }
  }
  
  void _log(String message, {Object? error, StackTrace? stackTrace}) {
    if (!_debugMode) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] Riverpod: $message';
    
    if (kDebugMode) {
      debugPrint(logMessage);
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null && error != null) {
        debugPrint('  Stack: ${stackTrace.toString().split('\n').take(5).join('\n')}');
      }
    }
    
    // Send to Sentry in production if it's an error
    if (!kDebugMode && error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('riverpod_lifecycle', 'true');
          scope.setExtra('riverpod_message', message);
          scope.setExtra('riverpod_timestamp', timestamp);
        },
      );
    }
  }
  
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    super.didAddProvider(provider, value, container);
    _log('➕ Provider created: ${provider.name ?? provider.runtimeType}');
  }
  
  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    super.didDisposeProvider(provider, container);
    _log('➖ Provider disposed: ${provider.name ?? provider.runtimeType}');
  }
  
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    super.providerDidFail(provider, error, stackTrace, container);
    
    final providerName = provider.name ?? provider.runtimeType.toString();
    _log(
      '❌ Provider failed: $providerName',
      error: error,
      stackTrace: stackTrace,
    );
    
    // Check for ref usage after disposal
    if (error.toString().contains('No ProviderScope found') ||
        error.toString().contains('Cannot use ref after')) {
      _log(
        '⚠️ CRITICAL: Ref used after disposal in provider: $providerName',
        error: error,
        stackTrace: stackTrace,
      );
      
      // Always send these critical errors to Sentry
      Sentry.captureException(
        Exception('Ref used after disposal: $providerName'),
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('error_type', 'ref_after_disposal');
          scope.setTag('provider_name', providerName);
          scope.level = SentryLevel.error;
        },
      );
    }
  }
  
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    
    if (_debugMode && kDebugMode) {
      final providerName = provider.name ?? provider.runtimeType.toString();
      
      // Only log state providers and notifiers to reduce noise
      if (providerName.contains('StateProvider') || 
          providerName.contains('Notifier') ||
          providerName.contains('Manager')) {
        _log('🔄 Provider updated: $providerName');
      }
    }
  }
}

/// Extension to make it easy to add the observer
extension ProviderContainerDebugExtension on ProviderContainer {
  /// Add debug observer to this container
  void addDebugObserver() {
    final observer = RiverpodDebugObserver();
    this.observers.add(observer);
  }
}

/// Extension for ProviderScope
extension ProviderScopeDebugExtension on ProviderScope {
  /// Create a ProviderScope with debug observer
  static ProviderScope withDebugObserver({
    Key? key,
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      key: key,
      overrides: overrides,
      observers: [RiverpodDebugObserver()],
      child: child,
    );
  }
}