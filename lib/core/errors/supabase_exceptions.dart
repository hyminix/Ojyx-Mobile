import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/data_sanitizer.dart';
import '../services/logging/console_logger.dart';
import '../services/logging/i_error_logger.dart';

/// Enhanced wrapper to catch and log Supabase errors with retry logic
class SupabaseExceptionHandler {
  /// Default retry configuration
  static const int defaultMaxRetries = 3;
  static const Duration defaultRetryDelay = Duration(seconds: 1);
  
  /// Wraps Supabase calls and handles exceptions with retry logic
  static Future<T> handleSupabaseCall<T>({
    required Future<T> Function() call,
    required String operation,
    Map<String, dynamic>? context,
    int maxRetries = defaultMaxRetries,
    Duration retryDelay = defaultRetryDelay,
    bool Function(dynamic)? shouldRetry,
  }) async {
    int attempts = 0;
    dynamic lastException;
    final stopwatch = Stopwatch()..start();
    
    // Add initial breadcrumb for operation start
    await Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'Starting Supabase operation: $operation',
        category: 'supabase.start',
        level: SentryLevel.info,
        data: DataSanitizer.sanitizeMap({
          'operation': operation,
          'max_retries': maxRetries,
          'retry_delay_ms': retryDelay.inMilliseconds,
          if (context != null) ...context,
        }),
        timestamp: DateTime.now(),
      ),
    );
    
    while (attempts < maxRetries) {
      attempts++;
      final attemptStopwatch = Stopwatch()..start();
      
      try {
        // Add attempt breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Attempting: $operation (attempt $attempts/$maxRetries)',
            category: 'supabase.attempt',
            level: SentryLevel.info,
            data: {
              'operation': operation,
              'attempt': attempts,
              'max_retries': maxRetries,
              'elapsed_ms': stopwatch.elapsedMilliseconds,
            },
            timestamp: DateTime.now(),
          ),
        );

        // Execute the call
        final result = await call();
        
        attemptStopwatch.stop();
        stopwatch.stop();
        
        // Add success breadcrumb with detailed metrics
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Success: $operation',
            category: 'supabase.success',
            level: SentryLevel.info,
            data: {
              'operation': operation,
              'attempts_required': attempts,
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'total_duration_ms': stopwatch.elapsedMilliseconds,
              'retries_used': attempts - 1,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        return result;
      } on PostgrestException catch (e, stackTrace) {
        lastException = e;
        attemptStopwatch.stop();
        
        // Add error breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'PostgrestException: $operation',
            category: 'supabase.error.postgrest',
            level: SentryLevel.error,
            data: {
              'operation': operation,
              'attempt': attempts,
              'code': e.code,
              'message': e.message,
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'will_retry': false,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        // Don't retry database errors - they're usually logical errors
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'PostgrestException',
          duration: stopwatch.elapsed,
        );
        
        throw _transformPostgrestError(e, operation);
      } on AuthException catch (e, stackTrace) {
        lastException = e;
        attemptStopwatch.stop();
        
        // Add error breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'AuthException: $operation',
            category: 'supabase.error.auth',
            level: SentryLevel.warning,
            data: {
              'operation': operation,
              'attempt': attempts,
              'message': e.message,
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'will_retry': false,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        // Don't retry auth errors
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'AuthException',
          duration: stopwatch.elapsed,
        );
        
        throw _transformAuthError(e, operation);
      } on StorageException catch (e, stackTrace) {
        lastException = e;
        attemptStopwatch.stop();
        
        // Check if we should retry storage errors
        final shouldRetry = _shouldRetryStorageError(e) && attempts < maxRetries;
        
        // Add error breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'StorageException: $operation',
            category: 'supabase.error.storage',
            level: shouldRetry ? SentryLevel.warning : SentryLevel.error,
            data: {
              'operation': operation,
              'attempt': attempts,
              'message': e.message,
              'status_code': e.statusCode,
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'will_retry': shouldRetry,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        if (shouldRetry) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: 'StorageException',
            willRetry: true,
            duration: stopwatch.elapsed,
          );
          
          await _waitForRetry(attempts, retryDelay);
          continue;
        }
        
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'StorageException',
          duration: stopwatch.elapsed,
        );
        
        rethrow;
      } on SocketException catch (e, stackTrace) {
        lastException = e;
        attemptStopwatch.stop();
        
        // Retry network errors
        final willRetry = attempts < maxRetries && (shouldRetry?.call(e) ?? true);
        
        // Add error breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'SocketException: $operation',
            category: 'supabase.error.network',
            level: SentryLevel.warning,
            data: {
              'operation': operation,
              'attempt': attempts,
              'message': e.message,
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'will_retry': willRetry,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        if (willRetry) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: 'SocketException',
            willRetry: true,
            duration: stopwatch.elapsed,
          );
          
          await _waitForRetry(attempts, retryDelay);
          continue;
        }
        
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'SocketException',
          duration: stopwatch.elapsed,
        );
        
        throw Exception('Erreur de connexion réseau. Veuillez vérifier votre connexion.');
      } on TimeoutException catch (e, stackTrace) {
        lastException = e;
        attemptStopwatch.stop();
        
        // Retry timeout errors
        final willRetry = attempts < maxRetries;
        
        // Add error breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'TimeoutException: $operation',
            category: 'supabase.error.timeout',
            level: SentryLevel.warning,
            data: {
              'operation': operation,
              'attempt': attempts,
              'message': e.message ?? 'Timeout',
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'will_retry': willRetry,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        if (willRetry) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: 'TimeoutException',
            willRetry: true,
            duration: stopwatch.elapsed,
          );
          
          await _waitForRetry(attempts, retryDelay);
          continue;
        }
        
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'TimeoutException',
          duration: stopwatch.elapsed,
        );
        
        throw Exception('La connexion a pris trop de temps. Veuillez réessayer.');
      } catch (e, stackTrace) {
        lastException = e;
        attemptStopwatch.stop();
        
        // Check if we should retry unknown errors
        final willRetry = attempts < maxRetries && shouldRetry != null && shouldRetry(e);
        
        // Add error breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Unknown error: $operation',
            category: 'supabase.error.unknown',
            level: SentryLevel.error,
            data: {
              'operation': operation,
              'attempt': attempts,
              'error_type': e.runtimeType.toString(),
              'message': e.toString(),
              'attempt_duration_ms': attemptStopwatch.elapsedMilliseconds,
              'will_retry': willRetry,
            },
            timestamp: DateTime.now(),
          ),
        );
        
        if (willRetry) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: e.runtimeType.toString(),
            willRetry: true,
            duration: stopwatch.elapsed,
          );
          
          await _waitForRetry(attempts, retryDelay);
          continue;
        }
        
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: e.runtimeType.toString(),
          duration: stopwatch.elapsed,
        );
        
        rethrow;
      }
    }
    
    // Should never reach here, but throw last exception if we do
    if (lastException != null) {
      throw lastException;
    }
    throw Exception('Maximum retry attempts reached for operation: $operation');
  }

  /// Unified error handling method
  static Future<void> _handleError({
    required dynamic exception,
    required StackTrace stackTrace,
    required String operation,
    required Map<String, dynamic>? context,
    required int attempt,
    required int maxRetries,
    required String errorType,
    bool willRetry = false,
    Duration? duration,
  }) async {
    // Log to console
    _logError(
      type: errorType,
      operation: operation,
      message: exception.toString(),
      attempt: attempt,
      maxRetries: maxRetries,
      willRetry: willRetry,
      code: exception is PostgrestException ? exception.code : null,
      details: exception is PostgrestException && exception.details != null ? exception.details.toString() : null,
      hint: exception is PostgrestException && exception.hint != null ? exception.hint.toString() : null,
      duration: duration,
    );
    
    // Send to Sentry on final attempt only
    if (!willRetry) {
      await _sendToSentry(
        exception: exception,
        stackTrace: stackTrace,
        operation: operation,
        context: context,
        attempt: attempt,
        maxRetries: maxRetries,
        errorType: errorType,
        duration: duration,
      );
    }
  }

  /// Wait before retry with exponential backoff
  static Future<void> _waitForRetry(int attempt, Duration baseDelay) async {
    // Exponential backoff: delay = baseDelay * (2^(attempt-1))
    // For attempt 1: baseDelay * 1 = 1s
    // For attempt 2: baseDelay * 2 = 2s
    // For attempt 3: baseDelay * 4 = 4s
    final multiplier = 1 << (attempt - 1); // 2^(attempt-1)
    final delay = baseDelay * multiplier;
    
    // Cap maximum delay at 30 seconds
    final actualDelay = delay.inSeconds > 30 
        ? const Duration(seconds: 30) 
        : delay;
    
    if (kDebugMode) {
      debugPrint('[RETRY] Waiting ${actualDelay.inSeconds}s before retry attempt ${attempt + 1} (exponential backoff)');
    }
    await Future.delayed(actualDelay);
  }

  /// Check if storage error should be retried
  static bool _shouldRetryStorageError(StorageException error) {
    final message = error.message.toLowerCase();
    return message.contains('timeout') || 
           message.contains('network') ||
           message.contains('connection');
  }

  /// Logs error using the structured logger
  static void _logError({
    required String type,
    required String operation,
    String? code,
    required String message,
    String? details,
    String? hint,
    int? attempt,
    int? maxRetries,
    bool willRetry = false,
    Duration? duration,
  }) {
    final data = <String, dynamic>{
      'operation': operation,
      'error_type': type,
      if (code != null) 'error_code': code,
      if (details != null) 'details': details,
      if (hint != null) 'hint': hint,
      if (attempt != null && maxRetries != null) 'attempt': '$attempt/$maxRetries',
      if (willRetry) 'will_retry': true,
    };
    
    final level = willRetry ? LogLevel.warning : LogLevel.error;
    
    if (level == LogLevel.error) {
      ErrorLogger.error(
        message,
        category: 'supabase.$type',
        data: data,
        duration: duration,
      );
    } else {
      ErrorLogger.warning(
        message,
        category: 'supabase.$type',
        data: data,
      );
    }
  }

  /// Send error to Sentry with enriched context
  static Future<void> _sendToSentry({
    required dynamic exception,
    required StackTrace stackTrace,
    required String operation,
    required Map<String, dynamic>? context,
    required int attempt,
    required int maxRetries,
    required String errorType,
    Duration? duration,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        // Basic error categorization
        scope.setTag('error.type', errorType.toLowerCase());
        scope.setTag('error.category', 'supabase');
        scope.setTag('operation', operation);
        scope.setTag('operation.type', _getOperationType(operation));
        
        // Retry information
        scope.setTag('retry.attempts', attempt.toString());
        scope.setTag('retry.max_attempts', maxRetries.toString());
        scope.setTag('retry.exhausted', 'true');
        scope.setTag('retry.succeeded', 'false');
        
        // Performance metrics
        if (duration != null) {
          scope.setTag('duration.ms', duration.inMilliseconds.toString());
          scope.setTag('duration.category', _categorizeDuration(duration));
        }
        
        // Error-specific tags
        if (exception is PostgrestException) {
          scope.setTag('postgrest.code', exception.code ?? 'unknown');
          scope.setTag('postgrest.has_details', (exception.details != null).toString());
          scope.setTag('postgrest.has_hint', (exception.hint != null).toString());
        } else if (exception is AuthException) {
          scope.setTag('auth.status_code', exception.statusCode ?? 'unknown');
        } else if (exception is StorageException) {
          scope.setTag('storage.status_code', exception.statusCode ?? 'unknown');
        } else if (exception is SocketException) {
          scope.setTag('network.type', 'socket_exception');
        } else if (exception is TimeoutException) {
          scope.setTag('network.type', 'timeout');
        }
        
        // Set appropriate error level
        scope.level = _getErrorLevel(errorType, exception);
        
        // Add user feedback hint for user-facing errors
        if (_isUserFacingError(exception)) {
          scope.setTag('user.feedback_required', 'true');
        }
        
        // Sanitize and add context
        final sanitizedContext = DataSanitizer.sanitizeMap(context);
        final errorDetails = DataSanitizer.sanitizeMap({
          'operation': operation,
          'error_type': errorType,
          'attempts': attempt,
          'max_retries': maxRetries,
          'duration_ms': duration?.inMilliseconds,
          if (exception is PostgrestException) ...{
            'code': exception.code,
            'message': exception.message,
            'details': exception.details,
            'hint': exception.hint?.toString(),
          },
          if (exception is AuthException) ...{
            'message': exception.message,
            'status_code': exception.statusCode,
          },
          if (exception is StorageException) ...{
            'message': exception.message,
            'status_code': exception.statusCode,
          },
          'context': sanitizedContext,
          'timestamp': DateTime.now().toIso8601String(),
        });
        
        // Add fingerprint for grouping similar errors
        scope.fingerprint = _generateFingerprint(operation, errorType, exception);
        
        // Add transaction info if available
        scope.transaction = 'supabase.$operation';
        
        // Log sanitized details for debugging
        if (kDebugMode) {
          debugPrint('[SENTRY] Capturing error: ${DataSanitizer.toDebugString(errorDetails)}');
        }
      },
    );
  }

  /// Determines the operation type from the operation name
  static String _getOperationType(String operation) {
    if (operation.contains('select') || operation.contains('get')) return 'read';
    if (operation.contains('insert') || operation.contains('create')) return 'write';
    if (operation.contains('update')) return 'update';
    if (operation.contains('delete')) return 'delete';
    if (operation.contains('rpc')) return 'rpc';
    return 'other';
  }

  /// Categorizes duration for performance monitoring
  static String _categorizeDuration(Duration duration) {
    final ms = duration.inMilliseconds;
    if (ms < 100) return 'fast';
    if (ms < 500) return 'normal';
    if (ms < 2000) return 'slow';
    return 'very_slow';
  }

  /// Determines the appropriate error level
  static SentryLevel _getErrorLevel(String errorType, dynamic exception) {
    // Network errors are warnings as they're often transient
    if (errorType == 'SocketException' || errorType == 'TimeoutException') {
      return SentryLevel.warning;
    }
    
    // Auth errors might be user error
    if (errorType == 'AuthException') {
      return SentryLevel.warning;
    }
    
    // Database constraint violations are often user errors
    if (exception is PostgrestException) {
      final code = exception.code;
      if (code == '23505' || code == '23503') { // unique/foreign key violations
        return SentryLevel.warning;
      }
    }
    
    return SentryLevel.error;
  }

  /// Checks if error should trigger user feedback
  static bool _isUserFacingError(dynamic exception) {
    if (exception is PostgrestException) {
      final code = exception.code;
      return code == '23505' || // duplicate
             code == '23503' || // foreign key
             code == '22P02';   // invalid format
    }
    return exception is AuthException;
  }

  /// Generates a fingerprint for error grouping
  static List<String> _generateFingerprint(String operation, String errorType, dynamic exception) {
    final fingerprint = <String>[
      'supabase',
      errorType,
      operation,
    ];
    
    if (exception is PostgrestException && exception.code != null) {
      fingerprint.add(exception.code!);
    } else if (exception is AuthException) {
      fingerprint.add('auth_error');
    } else if (exception is StorageException) {
      fingerprint.add('storage_error');
    }
    
    return fingerprint;
  }

  /// Transforms PostgrestException to user-friendly error
  static Exception _transformPostgrestError(PostgrestException e, String operation) {
    String userMessage;
    
    // Parse common PostgreSQL error codes
    switch (e.code) {
      case '23505': // unique_violation
        userMessage = 'Cette donnée existe déjà.';
        break;
      case '23503': // foreign_key_violation
        userMessage = 'Référence invalide.';
        break;
      case '42501': // insufficient_privilege
        userMessage = 'Permissions insuffisantes.';
        break;
      case '22P02': // invalid_text_representation
        userMessage = 'Format de données invalide.';
        break;
      case 'PGRST301': // not found
        userMessage = 'Donnée introuvable.';
        break;
      default:
        if (e.message.contains('duplicate')) {
          userMessage = 'Cette donnée existe déjà.';
        } else if (e.message.contains('not found')) {
          userMessage = 'Donnée introuvable.';
        } else if (e.message.contains('permission')) {
          userMessage = 'Vous n\'avez pas les permissions nécessaires.';
        } else {
          userMessage = 'Une erreur est survenue. Veuillez réessayer.';
        }
    }
    
    return Exception('$userMessage (Code: ${e.code ?? "unknown"})');
  }

  /// Transforms AuthException to user-friendly error
  static Exception _transformAuthError(AuthException e, String operation) {
    String userMessage;
    
    if (e.message.contains('Invalid login')) {
      userMessage = 'Identifiants incorrects.';
    } else if (e.message.contains('User not found')) {
      userMessage = 'Utilisateur introuvable.';
    } else if (e.message.contains('Email not confirmed')) {
      userMessage = 'Veuillez confirmer votre email.';
    } else if (e.message.contains('expired')) {
      userMessage = 'Session expirée. Veuillez vous reconnecter.';
    } else {
      userMessage = 'Erreur d\'authentification.';
    }
    
    return Exception(userMessage);
  }
}

// Extension methods moved to lib/core/extensions/supabase_extensions.dart
// to avoid conflicts and provide more comprehensive functionality