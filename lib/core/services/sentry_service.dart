import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Service wrapper for Sentry with enhanced performance monitoring
class SentryService {
  SentryService._();

  /// Track a custom transaction
  static Future<T> trackTransaction<T>({
    required String name,
    required String operation,
    required Future<T> Function() action,
    Map<String, dynamic>? data,
  }) async {
    final transaction = Sentry.startTransaction(
      name,
      operation,
      bindToScope: true,
    );

    try {
      // Add custom data to transaction
      if (data != null) {
        data.forEach((key, value) {
          transaction.setData(key, value);
        });
      }

      // Execute the action
      final result = await action();

      // Mark transaction as successful
      transaction.status = const SpanStatus.ok();

      return result;
    } catch (e, stackTrace) {
      // Mark transaction as failed
      transaction.status = const SpanStatus.internalError();

      // Capture the exception
      await captureException(e, stackTrace: stackTrace);

      rethrow;
    } finally {
      await transaction.finish();
    }
  }

  /// Track a database operation
  static Future<T> trackDatabaseOperation<T>({
    required String description,
    required String operation,
    required Future<T> Function() query,
    String? table,
  }) async {
    return trackTransaction(
      name: 'db.$operation',
      operation: 'db',
      action: query,
      data: {
        'db.operation': operation,
        'db.description': description,
        if (table != null) 'db.table': table,
      },
    );
  }

  /// Track a network request
  static Future<T> trackNetworkRequest<T>({
    required String url,
    required String method,
    required Future<T> Function() request,
  }) async {
    return trackTransaction(
      name: '$method $url',
      operation: 'http.client',
      action: request,
      data: {'http.method': method, 'http.url': url},
    );
  }

  /// Track UI interaction
  static Future<T> trackUserInteraction<T>({
    required String widget,
    required String action,
    required Future<T> Function() interaction,
    Map<String, dynamic>? extra,
  }) async {
    return trackTransaction(
      name: '$widget.$action',
      operation: 'ui.action',
      action: interaction,
      data: {
        'ui.widget': widget,
        'ui.action': action,
        if (extra != null) ...extra,
      },
    );
  }

  /// Add a breadcrumb with enhanced context
  static void addBreadcrumb({
    required String message,
    required String category,
    SentryLevel? level,
    Map<String, dynamic>? data,
    String? type,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level ?? SentryLevel.info,
        data: data,
        type: type,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Capture an exception with enhanced context
  static Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, dynamic>? extra,
    Map<String, String>? tags,
    List<Breadcrumb>? breadcrumbs,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        // Add extra context
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }

        // Add tags
        if (tags != null) {
          tags.forEach((key, value) {
            scope.setTag(key, value);
          });
        }

        // Add breadcrumbs
        if (breadcrumbs != null) {
          for (final breadcrumb in breadcrumbs) {
            scope.addBreadcrumb(breadcrumb);
          }
        }
      },
    );
  }

  /// Capture a message with context
  static Future<void> captureMessage(
    String message, {
    SentryLevel? level,
    Map<String, dynamic>? extra,
    Map<String, String>? tags,
  }) async {
    await Sentry.captureMessage(
      message,
      level: level ?? SentryLevel.info,
      withScope: (scope) {
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }

        if (tags != null) {
          tags.forEach((key, value) {
            scope.setTag(key, value);
          });
        }
      },
    );
  }

  /// Set user context for all events
  static void setUser({
    String? id,
    String? username,
    String? email,
    Map<String, dynamic>? extra,
  }) {
    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(id: id, username: username, email: email, data: extra),
      );
    });
  }

  /// Clear user context
  static void clearUser() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Track app lifecycle events
  static void trackAppLifecycle(String event) {
    addBreadcrumb(
      message: 'App lifecycle: $event',
      category: 'app.lifecycle',
      data: {'event': event, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  /// Track navigation events
  static void trackNavigation({
    required String from,
    required String to,
    Map<String, dynamic>? params,
  }) {
    addBreadcrumb(
      message: 'Navigated from $from to $to',
      category: 'navigation',
      type: 'navigation',
      data: {'from': from, 'to': to, if (params != null) 'params': params},
    );
  }

  /// Performance monitoring for Supabase operations
  static Future<T> trackSupabaseOperation<T>({
    required String operation,
    required String table,
    required Future<T> Function() query,
    Map<String, dynamic>? filters,
  }) async {
    return trackDatabaseOperation(
      description: 'Supabase $operation on $table',
      operation: operation,
      table: table,
      query: () async {
        try {
          final result = await query();

          // Add success breadcrumb
          addBreadcrumb(
            message: 'Supabase $operation successful',
            category: 'supabase',
            data: {
              'operation': operation,
              'table': table,
              if (filters != null) 'filters': filters,
            },
          );

          return result;
        } catch (e) {
          // Add error breadcrumb
          addBreadcrumb(
            message: 'Supabase $operation failed',
            category: 'supabase',
            level: SentryLevel.error,
            data: {
              'operation': operation,
              'table': table,
              'error': e.toString(),
              if (filters != null) 'filters': filters,
            },
          );

          rethrow;
        }
      },
    );
  }

  /// Check if Sentry is enabled
  static bool get isEnabled => !kDebugMode && Sentry.isEnabled;
}
