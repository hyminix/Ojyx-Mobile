import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/core/errors/supabase_error_handling.dart';

/// Service pour ajouter de la résilience aux appels Supabase
class ResilientSupabaseService {
  /// Execute une opération avec retry logic
  static Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(dynamic)? shouldRetry,
  }) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        return await operation();
      } on PostgrestException catch (e) {
        attempts++;
        if (attempts >= maxAttempts || !e.isRetriable) rethrow;

        // Exponential backoff
        await Future.delayed(delay * attempts);
      } on AuthException catch (e) {
        attempts++;
        if (attempts >= maxAttempts || !e.isRetriable) rethrow;

        await Future.delayed(delay * attempts);
      } catch (e) {
        // Pour d'autres erreurs, vérifier avec le callback personnalisé
        attempts++;
        if (attempts >= maxAttempts) rethrow;

        if (shouldRetry != null && !shouldRetry(e)) rethrow;

        await Future.delayed(delay * attempts);
      }
    }

    throw Exception('Max retry attempts reached');
  }

  /// Execute une opération avec timeout
  static Future<T> withTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      return await operation().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException(
            'Operation timed out after ${timeout.inSeconds} seconds',
            timeout,
          );
        },
      );
    } on TimeoutException {
      throw const AppException(
        message: 'L\'opération a pris trop de temps',
        code: 'TIMEOUT',
        isRetriable: true,
      );
    }
  }

  /// Execute avec retry et timeout combinés
  static Future<T> resilientExecute<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return withRetry(
      () => withTimeout(operation, timeout: timeout),
      maxAttempts: maxAttempts,
      delay: delay,
    );
  }

  /// Stream avec reconnexion automatique
  static Stream<T> resilientStream<T>(
    Stream<T> Function() streamFactory, {
    int maxReconnectAttempts = 5,
    Duration reconnectDelay = const Duration(seconds: 2),
  }) {
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;
    int reconnectAttempts = 0;
    Timer? reconnectTimer;

    // Déclaration forward pour résoudre le problème de référence
    late void Function() attemptReconnect;

    void connect() {
      try {
        final stream = streamFactory();
        subscription = stream.listen(
          (data) {
            controller?.add(data);
            // Reset attempts on successful data
            reconnectAttempts = 0;
          },
          onError: (error) {
            controller?.addError(error);
            attemptReconnect();
          },
          onDone: () {
            attemptReconnect();
          },
          cancelOnError: false,
        );
      } catch (e) {
        controller?.addError(e);
        attemptReconnect();
      }
    }

    attemptReconnect = () {
      if (reconnectAttempts >= maxReconnectAttempts) {
        if (controller != null && !controller.isClosed) {
          controller.addError(
            AppException(
              message:
                  'Connexion perdue après $maxReconnectAttempts tentatives',
              code: 'CONNECTION_LOST',
              isRetriable: false,
            ),
          );
          controller.close();
        }
        return;
      }

      reconnectAttempts++;
      reconnectTimer?.cancel();
      reconnectTimer = Timer(
        reconnectDelay * reconnectAttempts, // Exponential backoff
        () {
          subscription?.cancel();
          connect();
        },
      );
    };

    controller = StreamController<T>(
      onListen: connect,
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () {
        reconnectTimer?.cancel();
        subscription?.cancel();
      },
    );

    return controller.stream;
  }
}

/// Extension pour faciliter l'usage sur les builders Supabase
extension ResilientPostgrestBuilder on PostgrestBuilder {
  /// Execute avec retry automatique
  Future<T> executeWithRetry<T>({
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) {
    return ResilientSupabaseService.withRetry(
      () => this as Future<T>,
      maxAttempts: maxAttempts,
      delay: delay,
    );
  }
}

/// Extension pour les requêtes PostgrestQueryBuilder
extension ResilientPostgrestQueryBuilder<T> on PostgrestQueryBuilder<T> {
  /// Execute avec timeout et retry
  Future<T> executeResilient({
    int maxAttempts = 3,
    Duration timeout = const Duration(seconds: 30),
  }) {
    return ResilientSupabaseService.resilientExecute(
      () => this as Future<T>,
      maxAttempts: maxAttempts,
      timeout: timeout,
    );
  }
}
