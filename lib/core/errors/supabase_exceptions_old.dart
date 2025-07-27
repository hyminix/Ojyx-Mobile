import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Simple wrapper to catch and log Supabase errors
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
    bool Function(Exception)? shouldRetry,
  }) async {
    int attempts = 0;
    Exception? lastException;
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
        
        // Don't retry database errors - they're usually logical errors, not transient
        _logError(
          type: 'PostgrestException',
          operation: operation,
          code: e.code ?? '',
          message: e.message,
          details: e.details,
          hint: e.hint,
          attempt: attempts,
          maxRetries: maxRetries,
        );
        
        // Send to Sentry on final attempt
        if (attempts >= maxRetries) {
          await _sendToSentry(e, stackTrace, operation, context, attempts, maxRetries);
        }
        
        // Transform and throw immediately - no retry for DB errors
        throw _transformPostgrestError(e, operation);
    } on AuthException catch (e, stackTrace) {
      // Log to console
      _logError(
        type: 'AuthException',
        operation: operation,
        message: e.message,
      );

      // Send to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('error.type', 'auth');
          scope.setTag('operation', operation);
          scope.level = SentryLevel.warning;
          
          scope.setExtra('auth_error', {
            'operation': operation,
            'message': e.message,
            if (context != null) 'context': context,
          });
        },
      );

      // Transform to user-friendly message
      throw _transformAuthError(e, operation);
    } on StorageException catch (e, stackTrace) {
      // Log to console
      _logError(
        type: 'StorageException',
        operation: operation,
        message: e.message,
      );

      // Send to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('error.type', 'storage');
          scope.setTag('operation', operation);
          scope.level = SentryLevel.error;
          
          scope.setExtra('storage_error', {
            'operation': operation,
            'message': e.message,
            'statusCode': e.statusCode,
            if (context != null) 'context': context,
          });
        },
      );

      rethrow;
    } catch (e, stackTrace) {
      // Log any other error
      _logError(
        type: e.runtimeType.toString(),
        operation: operation,
        message: e.toString(),
      );

      // Send to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('error.type', 'unknown');
          scope.setTag('operation', operation);
          scope.level = SentryLevel.error;
          
          scope.setExtra('unknown_error', {
            'operation': operation,
            'type': e.runtimeType.toString(),
            'message': e.toString(),
            if (context != null) 'context': context,
          });
        },
      );

      rethrow;
    }
  }

  /// Logs error to console with structured format
  static void _logError({
    required String type,
    required String operation,
    String? code,
    required String message,
    String? details,
    String? hint,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer();
    
    if (kDebugMode) {
      // ANSI colors for debug mode
      const red = '\x1B[31m';
      const yellow = '\x1B[33m';
      const blue = '\x1B[34m';
      const reset = '\x1B[0m';
      
      buffer.write('$blue[$timestamp]$reset ');
      buffer.write('$red[SUPABASE ERROR]$reset ');
      buffer.write('$yellow[$type]$reset ');
      buffer.write('$operation: $message');
      
      if (code != null) buffer.write(' | code=$code');
      if (details != null) buffer.write(' | details=$details');
      if (hint != null) buffer.write(' | hint=$hint');
    } else {
      buffer.write('[$timestamp] [SUPABASE ERROR] [$type] $operation: $message');
      if (code != null) buffer.write(' | code=$code');
      if (details != null) buffer.write(' | details=$details');
    }
    
    debugPrint(buffer.toString());
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
  /// Safely execute a query with error handling
  Future<List<Map<String, dynamic>>> safeSelect(
    String table, {
    String columns = '*',
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).select(columns),
      operation: 'select_$table',
      context: context,
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
    );
  }

  /// Safely update data with error handling
  Future<List<Map<String, dynamic>>> safeUpdate(
    String table,
    Map<String, dynamic> data, {
    required Map<String, dynamic> match,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).update(data).match(match).select(),
      operation: 'update_$table',
      context: context,
    );
  }

  /// Safely delete data with error handling
  Future<List<Map<String, dynamic>>> safeDelete(
    String table, {
    required Map<String, dynamic> match,
    Map<String, dynamic>? context,
  }) async {
    return SupabaseExceptionHandler.handleSupabaseCall(
      call: () => from(table).delete().match(match).select(),
      operation: 'delete_$table',
      context: context,
    );
  }
}