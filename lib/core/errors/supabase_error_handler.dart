import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:postgrest/postgrest.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'custom_errors.dart';

/// Handles all Supabase-related errors with Sentry integration and logging
class SupabaseErrorHandler {
  SupabaseErrorHandler._();

  /// Default retry configuration
  static const int defaultMaxRetries = 3;
  static const Duration defaultRetryDelay = Duration(seconds: 1);

  /// Wraps Supabase calls with comprehensive error handling
  static Future<T> wrapSupabaseCall<T>({
    required Future<T> Function() call,
    required String operation,
    int maxRetries = defaultMaxRetries,
    Duration retryDelay = defaultRetryDelay,
    bool Function(Exception)? shouldRetry,
    Map<String, dynamic>? additionalContext,
  }) async {
    int attempts = 0;
    DateTime startTime = DateTime.now();

    // Add Sentry breadcrumb for operation start
    await Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'Starting Supabase operation: $operation',
        category: 'supabase',
        level: SentryLevel.info,
        data: _sanitizeData({
          'operation': operation,
          'attempt': attempts + 1,
          ...?additionalContext,
        }),
      ),
    );

    while (attempts < maxRetries) {
      try {
        attempts++;
        
        // Execute the Supabase call
        final result = await call();
        
        // Add success breadcrumb
        final duration = DateTime.now().difference(startTime);
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Supabase operation succeeded: $operation',
            category: 'supabase',
            level: SentryLevel.info,
            data: {
              'operation': operation,
              'duration_ms': duration.inMilliseconds,
              'attempts': attempts,
            },
          ),
        );
        
        return result;
      } on PostgrestException catch (e, stackTrace) {
        // Handle PostgreSQL errors
        final error = DatabaseError.fromPostgrest(
          e,
          operation: operation,
          table: _extractTableFromOperation(operation),
        );
        
        await _handleError(
          error: error,
          originalException: e,
          stackTrace: stackTrace,
          operation: operation,
          attempt: attempts,
          maxRetries: maxRetries,
        );

        // Don't retry database errors (usually logical errors)
        throw error;
      } on AuthException catch (e, stackTrace) {
        // Handle authentication errors
        final error = AuthError.fromSupabaseAuth(
          e,
          operation: operation,
        );
        
        await _handleError(
          error: error,
          originalException: e,
          stackTrace: stackTrace,
          operation: operation,
          attempt: attempts,
          maxRetries: maxRetries,
        );

        // Don't retry auth errors
        throw error;
      } on StorageException catch (e, stackTrace) {
        // Handle storage errors
        final error = StorageError.fromSupabaseStorage(
          e,
          operation: operation,
        );
        
        await _handleError(
          error: error,
          originalException: e,
          stackTrace: stackTrace,
          operation: operation,
          attempt: attempts,
          maxRetries: maxRetries,
        );

        // Check if we should retry storage errors
        if (_shouldRetryStorageError(e) && attempts < maxRetries) {
          await _waitBeforeRetry(attempts, retryDelay);
          continue;
        }
        
        throw error;
      } on SocketException catch (e, stackTrace) {
        // Handle network errors
        final error = NetworkError.fromException(
          e,
          operation: operation,
        );
        
        await _handleError(
          error: error,
          originalException: e,
          stackTrace: stackTrace,
          operation: operation,
          attempt: attempts,
          maxRetries: maxRetries,
        );

        // Retry network errors
        if (attempts < maxRetries && (shouldRetry?.call(e) ?? true)) {
          await _waitBeforeRetry(attempts, retryDelay);
          continue;
        }
        
        throw error;
      } on TimeoutException catch (e, stackTrace) {
        // Handle timeout errors
        final error = NetworkError.timeout(
          operation: operation,
          timeout: e.duration ?? const Duration(seconds: 30),
        );
        
        await _handleError(
          error: error,
          originalException: e,
          stackTrace: stackTrace,
          operation: operation,
          attempt: attempts,
          maxRetries: maxRetries,
        );

        // Retry timeout errors
        if (attempts < maxRetries) {
          await _waitBeforeRetry(attempts, retryDelay);
          continue;
        }
        
        throw error;
      } catch (e, stackTrace) {
        // Handle unexpected errors
        await _handleError(
          error: null,
          originalException: e,
          stackTrace: stackTrace,
          operation: operation,
          attempt: attempts,
          maxRetries: maxRetries,
        );

        // Check if we should retry unknown errors
        if (e is Exception && 
            attempts < maxRetries && 
            (shouldRetry?.call(e) ?? false)) {
          await _waitBeforeRetry(attempts, retryDelay);
          continue;
        }
        
        rethrow;
      }
    }

    // This should never be reached, but just in case
    throw Exception('Max retries exceeded for operation: $operation');
  }

  /// Handles error logging to Sentry and console
  static Future<void> _handleError({
    AppError? error,
    required dynamic originalException,
    required StackTrace stackTrace,
    required String operation,
    required int attempt,
    required int maxRetries,
  }) async {
    final duration = DateTime.now();
    
    // Log to console with structured format
    _logToConsole(
      level: 'ERROR',
      category: error?.runtimeType.toString() ?? 'UnknownError',
      operation: operation,
      message: error?.message ?? originalException.toString(),
      details: {
        'code': error?.code ?? 'UNKNOWN',
        'attempt': '$attempt/$maxRetries',
        'timestamp': duration.toIso8601String(),
        if (error?.details != null) 'details': error!.details,
      },
    );

    // Send to Sentry with enriched context
    await Sentry.captureException(
      error ?? originalException,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error.type', error?.runtimeType.toString() ?? 'unknown');
        scope.setTag('operation.name', operation);
        scope.setTag('retry.attempted', (attempt > 1).toString());
        scope.setTag('retry.count', attempt.toString());
        
        scope.setExtra('supabase_error', {
          'operation': operation,
          'error_code': error?.code ?? 'UNKNOWN',
          'error_message': error?.message ?? originalException.toString(),
          'attempt': attempt,
          'max_retries': maxRetries,
          'timestamp': duration.toIso8601String(),
          if (error is DatabaseError) ...{
            'table': error.table,
            'constraint': error.constraint,
          },
          if (error is NetworkError) ...{
            'status_code': error.statusCode,
            'timeout': error.timeout?.inSeconds,
          },
          if (error is StorageError) ...{
            'bucket': error.bucket,
            'path': error.path,
          },
        });
      },
    );
  }

  /// Logs structured error to console with formatting
  static void _logToConsole({
    required String level,
    required String category,
    required String operation,
    required String message,
    Map<String, dynamic>? details,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer();
    
    // Use ANSI colors in debug mode
    if (kDebugMode) {
      const red = '\x1B[31m';
      const yellow = '\x1B[33m';
      const blue = '\x1B[34m';
      const reset = '\x1B[0m';
      
      buffer.write('$blue[$timestamp]$reset ');
      buffer.write('$red[$level]$reset ');
      buffer.write('$yellow[$category]$reset ');
      buffer.write('$operation: $message');
      
      if (details != null && details.isNotEmpty) {
        buffer.write(' | ');
        buffer.write(details.entries
            .map((e) => '${e.key}=${e.value}')
            .join(', '));
      }
    } else {
      // Plain format for non-debug
      buffer.write('[$timestamp] [$level] [$category] $operation: $message');
      if (details != null && details.isNotEmpty) {
        buffer.write(' | ${details.toString()}');
      }
    }
    
    debugPrint(buffer.toString());
  }

  /// Waits before retry with exponential backoff
  static Future<void> _waitBeforeRetry(int attempt, Duration baseDelay) async {
    final delay = baseDelay * (attempt * attempt); // Exponential backoff
    debugPrint('[RETRY] Waiting ${delay.inSeconds}s before retry attempt $attempt');
    await Future.delayed(delay);
  }

  /// Checks if storage error should be retried
  static bool _shouldRetryStorageError(StorageException error) {
    final message = error.message.toLowerCase();
    return message.contains('timeout') || 
           message.contains('network') ||
           message.contains('connection');
  }

  /// Extracts table name from operation string
  static String? _extractTableFromOperation(String operation) {
    // Try to extract table name from operation like "select_users" or "insert_game_states"
    final match = RegExp(r'(?:select|insert|update|delete|upsert)_(\w+)').firstMatch(operation);
    return match?.group(1);
  }

  /// Sanitizes data to remove sensitive information before sending to Sentry
  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sensitiveKeys = ['password', 'token', 'secret', 'key', 'authorization'];
    final sanitized = Map<String, dynamic>.from(data);
    
    sanitized.removeWhere((key, value) {
      final lowerKey = key.toLowerCase();
      return sensitiveKeys.any((sensitive) => lowerKey.contains(sensitive));
    });
    
    return sanitized;
  }
}