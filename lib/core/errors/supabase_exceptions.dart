import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    StackTrace? lastStackTrace;
    
    while (attempts < maxRetries) {
      attempts++;
      
      try {
        // Add Sentry breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Supabase operation: $operation (attempt $attempts/$maxRetries)',
            category: 'supabase',
            level: SentryLevel.info,
            data: {
              'operation': operation,
              'attempt': attempts,
              'max_retries': maxRetries,
              if (context != null) ...context,
            },
          ),
        );

        // Execute the call
        final result = await call();
        
        // Add success breadcrumb
        await Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Supabase operation succeeded: $operation',
            category: 'supabase',
            level: SentryLevel.info,
            data: {
              'attempts_required': attempts,
            },
          ),
        );
        
        return result;
      } on PostgrestException catch (e, stackTrace) {
        lastException = e;
        lastStackTrace = stackTrace;
        
        // Don't retry database errors - they're usually logical errors
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'PostgrestException',
        );
        
        throw _transformPostgrestError(e, operation);
      } on AuthException catch (e, stackTrace) {
        lastException = e;
        lastStackTrace = stackTrace;
        
        // Don't retry auth errors
        await _handleError(
          exception: e,
          stackTrace: stackTrace,
          operation: operation,
          context: context,
          attempt: attempts,
          maxRetries: maxRetries,
          errorType: 'AuthException',
        );
        
        throw _transformAuthError(e, operation);
      } on StorageException catch (e, stackTrace) {
        lastException = e;
        lastStackTrace = stackTrace;
        
        // Check if we should retry storage errors
        if (_shouldRetryStorageError(e) && attempts < maxRetries) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: 'StorageException',
            willRetry: true,
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
        );
        
        rethrow;
      } on SocketException catch (e, stackTrace) {
        lastException = e;
        lastStackTrace = stackTrace;
        
        // Retry network errors
        if (attempts < maxRetries && (shouldRetry?.call(e) ?? true)) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: 'SocketException',
            willRetry: true,
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
        );
        
        throw Exception('Erreur de connexion réseau. Veuillez vérifier votre connexion.');
      } on TimeoutException catch (e, stackTrace) {
        lastException = e;
        lastStackTrace = stackTrace;
        
        // Retry timeout errors
        if (attempts < maxRetries) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: 'TimeoutException',
            willRetry: true,
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
        );
        
        throw Exception('La connexion a pris trop de temps. Veuillez réessayer.');
      } catch (e, stackTrace) {
        lastException = e;
        lastStackTrace = stackTrace;
        
        // Check if we should retry unknown errors
        if (attempts < maxRetries && shouldRetry != null && shouldRetry(e)) {
          await _handleError(
            exception: e,
            stackTrace: stackTrace,
            operation: operation,
            context: context,
            attempt: attempts,
            maxRetries: maxRetries,
            errorType: e.runtimeType.toString(),
            willRetry: true,
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

  /// Logs error to console with structured format
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
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer();
    
    if (kDebugMode) {
      // ANSI colors for debug mode
      const red = '\x1B[31m';
      const yellow = '\x1B[33m';
      const blue = '\x1B[34m';
      const green = '\x1B[32m';
      const reset = '\x1B[0m';
      
      buffer.write('$blue[$timestamp]$reset ');
      buffer.write('$red[SUPABASE ERROR]$reset ');
      buffer.write('$yellow[$type]$reset ');
      buffer.write('$operation: $message');
      
      if (attempt != null && maxRetries != null) {
        buffer.write(' | ${green}attempt=$attempt/$maxRetries$reset');
      }
      if (willRetry) {
        buffer.write(' | ${yellow}will_retry=true$reset');
      }
      if (code != null) buffer.write(' | code=$code');
      if (details != null) buffer.write(' | details=$details');
      if (hint != null) buffer.write(' | hint=$hint');
    } else {
      buffer.write('[$timestamp] [SUPABASE ERROR] [$type] $operation: $message');
      if (attempt != null && maxRetries != null) {
        buffer.write(' | attempt=$attempt/$maxRetries');
      }
      if (willRetry) buffer.write(' | will_retry=true');
      if (code != null) buffer.write(' | code=$code');
      if (details != null) buffer.write(' | details=$details');
    }
    
    debugPrint(buffer.toString());
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
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('error.type', errorType.toLowerCase());
        scope.setTag('operation', operation);
        scope.setTag('retry.attempts', attempt.toString());
        scope.setTag('retry.max_attempts', maxRetries.toString());
        scope.setTag('retry.exhausted', 'true');
        
        if (exception is PostgrestException) {
          scope.setTag('error.code', exception.code ?? 'unknown');
        }
        
        scope.level = SentryLevel.error;
        
        // Using tags for important metadata
        scope.setTag('error.operation', operation);
        scope.setTag('error.attempts', attempt.toString());
        
        // Additional context in tags
        if (exception is PostgrestException && exception.code != null) {
          scope.setTag('postgrest.code', exception.code!);
        }
        
        // Log error details as JSON string in tag (workaround for deprecated setExtra)
        final errorDetails = {
          'operation': operation,
          'error_type': errorType,
          'attempts': attempt,
          'max_retries': maxRetries,
          if (exception is PostgrestException) ...{
            'code': exception.code,
            'message': exception.message,
            'details': exception.details,
            'hint': exception.hint,
          },
          if (exception is AuthException) 'message': exception.message,
          if (exception is StorageException) ...{
            'message': exception.message,
            'statusCode': exception.statusCode,
          },
          if (context != null) 'context': context,
        };
        
        // Convert to JSON string for logging
        if (kDebugMode) {
          debugPrint('[SENTRY] Error details: $errorDetails');
        }
      },
    );
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

/// Extension to easily use the error handler on SupabaseClient
extension SupabaseClientErrorHandling on SupabaseClient {
  /// Safely execute a query with error handling and retry
  Future<List<Map<String, dynamic>>> safeSelect(
    String table, {
    String columns = '*',
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).select(columns),
      operation: 'select_$table',
      context: context,
      maxRetries: maxRetries,
    );
  }

  /// Safely insert data with error handling
  Future<List<Map<String, dynamic>>> safeInsert(
    String table,
    Map<String, dynamic> data, {
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).insert(data).select(),
      operation: 'insert_$table',
      context: context,
      maxRetries: 1, // Don't retry inserts by default
    );
  }

  /// Safely update data with error handling
  Future<List<Map<String, dynamic>>> safeUpdate(
    String table,
    Map<String, dynamic> data, {
    required Map<String, Object> match,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).update(data).match(match).select(),
      operation: 'update_$table',
      context: context,
      maxRetries: 1, // Don't retry updates by default
    );
  }

  /// Safely delete data with error handling
  Future<List<Map<String, dynamic>>> safeDelete(
    String table, {
    required Map<String, Object> match,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).delete().match(match).select(),
      operation: 'delete_$table',
      context: context,
      maxRetries: 1, // Don't retry deletes by default
    );
  }
  
  /// Safely execute RPC with retry for read operations
  Future<T> safeRpc<T>(
    String functionName, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? context,
    int maxRetries = 3,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => rpc(functionName, params: params),
      operation: 'rpc_$functionName',
      context: context,
      maxRetries: maxRetries,
    );
  }
}