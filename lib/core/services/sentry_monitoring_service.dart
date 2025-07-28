import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sentry_monitoring_service.g.dart';

/// Service for enhanced Sentry monitoring with custom breadcrumbs and tags
class SentryMonitoringService {
  // Singleton instance
  static final SentryMonitoringService _instance = SentryMonitoringService._internal();
  factory SentryMonitoringService() => _instance;
  SentryMonitoringService._internal();

  // Version des fixes appliqués
  static const String _fixesVersion = 'ojyx-7,ojyx-c,ojyx-d,ojyx-8,ojyx-9';
  
  /// Initialize monitoring tags and context
  Future<void> initializeMonitoring() async {
    await Sentry.configureScope((scope) {
      // Tags de version et fixes
      scope.setTag('app.version', '1.0.0');
      scope.setTag('fixes.applied', _fixesVersion);
      scope.setTag('platform', defaultTargetPlatform.name);
      scope.setTag('environment', kDebugMode ? 'debug' : 'release');
      
      // Context utilisateur par défaut
      if (Supabase.instance.client.auth.currentUser != null) {
        scope.setUser(SentryUser(
          id: Supabase.instance.client.auth.currentUser!.id,
          email: Supabase.instance.client.auth.currentUser!.email,
        ));
      }
    });

    // Breadcrumb initial
    addBreadcrumb(
      message: 'Monitoring initialized',
      category: 'app.lifecycle',
      data: {'fixes_version': _fixesVersion},
    );
  }

  /// Add a custom breadcrumb
  void addBreadcrumb({
    required String message,
    required String category,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level,
        data: data,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log zone initialization
  void logZoneInitialization({required bool success, String? error}) {
    addBreadcrumb(
      message: success ? 'Zone initialization completed' : 'Zone initialization failed',
      category: 'app.lifecycle',
      level: success ? SentryLevel.info : SentryLevel.error,
      data: {
        'success': success,
        if (error != null) 'error': error,
      },
    );
  }

  /// Log Riverpod provider lifecycle events
  void logProviderLifecycle({
    required String providerName,
    required String event,
    Map<String, dynamic>? data,
  }) {
    addBreadcrumb(
      message: 'Provider $event: $providerName',
      category: 'riverpod.lifecycle',
      data: {
        'provider': providerName,
        'event': event,
        if (data != null) ...data,
      },
    );
  }

  /// Log Supabase connection events
  void logSupabaseConnection({
    required String event,
    bool success = true,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    addBreadcrumb(
      message: 'Supabase $event',
      category: 'supabase.connection',
      level: success ? SentryLevel.info : SentryLevel.warning,
      data: {
        'event': event,
        'success': success,
        if (error != null) 'error': error,
        if (metadata != null) ...metadata,
      },
    );
  }

  /// Create a transaction for critical operations
  ISentrySpan? startTransaction({
    required String name,
    required String operation,
    Map<String, dynamic>? data,
  }) {
    final transaction = Sentry.startTransaction(name, operation);
    
    if (data != null) {
      data.forEach((key, value) {
        transaction.setData(key, value);
      });
    }
    
    addBreadcrumb(
      message: 'Transaction started: $name',
      category: 'performance',
      data: {'operation': operation, ...?data},
    );
    
    return transaction;
  }

  /// Complete a transaction
  void finishTransaction(ISentrySpan? transaction, {bool success = true}) {
    if (transaction == null) return;
    
    transaction.status = success 
        ? const SpanStatus.ok() 
        : const SpanStatus.internalError();
    
    transaction.finish();
    
    addBreadcrumb(
      message: 'Transaction finished',
      category: 'performance',
      data: {'success': success},
    );
  }

  /// Monitor RLS violations
  void logRLSViolation({
    required String table,
    required String operation,
    String? userId,
    Map<String, dynamic>? context,
  }) {
    final message = 'RLS violation on $table.$operation';
    
    Sentry.captureMessage(
      message,
      level: SentryLevel.warning,
      withScope: (scope) {
        scope.setTag('rls.table', table);
        scope.setTag('rls.operation', operation);
        scope.setContexts('rls_violation', {
          'table': table,
          'operation': operation,
          'user_id': userId,
          if (context != null) ...context,
        });
      },
    );
    
    addBreadcrumb(
      message: message,
      category: 'security.rls',
      level: SentryLevel.warning,
      data: {
        'table': table,
        'operation': operation,
        if (userId != null) 'user_id': userId,
      },
    );
  }

  /// Check if an error is a known fixed issue
  bool isKnownFixedError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Liste des erreurs connues et corrigées
    final fixedErrors = [
      'zone mismatch',
      'bad state: the provider was disposed',
      'ref.read is called after dispose',
      'infinite recursion',
      'user not authenticated',
    ];
    
    return fixedErrors.any((fixed) => errorString.contains(fixed));
  }

  /// Report error with enhanced context
  void reportError({
    required dynamic error,
    required StackTrace stackTrace,
    String? context,
    Map<String, dynamic>? extra,
    bool fatal = false,
  }) {
    // Skip known fixed errors in release mode
    if (!kDebugMode && isKnownFixedError(error)) {
      debugPrint('Skipping known fixed error: $error');
      return;
    }
    
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (context != null) {
          scope.setContexts('error_context', {'description': context});
        }
        
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
        
        scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
      },
    );
  }
}

/// Riverpod provider for SentryMonitoringService
@riverpod
SentryMonitoringService sentryMonitoring(SentryMonitoringRef ref) {
  final service = SentryMonitoringService();
  
  // Initialize monitoring when provider is first accessed
  service.initializeMonitoring();
  
  // Log provider creation
  service.logProviderLifecycle(
    providerName: 'sentryMonitoringProvider',
    event: 'created',
  );
  
  // Cleanup on dispose
  ref.onDispose(() {
    service.logProviderLifecycle(
      providerName: 'sentryMonitoringProvider',
      event: 'disposed',
    );
  });
  
  return service;
}

/// Extension for easy access in widgets
extension SentryMonitoringContext on WidgetRef {
  SentryMonitoringService get sentryMonitoring => read(sentryMonitoringProvider);
}