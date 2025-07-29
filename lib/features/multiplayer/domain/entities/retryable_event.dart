import 'dart:math';
import 'game_sync_event.dart';

/// Représente un événement qui peut être réessayé en cas d'échec
class RetryableEvent {
  final GameSyncEvent event;
  final int attemptCount;
  final DateTime firstAttempt;
  final DateTime lastAttempt;
  final String? lastError;
  
  RetryableEvent({
    required this.event,
    this.attemptCount = 0,
    DateTime? firstAttempt,
    DateTime? lastAttempt,
    this.lastError,
  }) : firstAttempt = firstAttempt ?? DateTime.now(),
       lastAttempt = lastAttempt ?? DateTime.now();
  
  /// Configuration du retry
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 30);
  static const double backoffMultiplier = 2.0;
  
  /// Calcule le délai avant le prochain retry avec backoff exponentiel
  Duration get nextRetryDelay {
    if (attemptCount >= maxRetries) {
      return Duration.zero; // Pas de retry
    }
    
    // Backoff exponentiel avec jitter
    final baseDelay = initialRetryDelay.inMilliseconds * pow(backoffMultiplier, attemptCount);
    final jitter = Random().nextDouble() * 0.3; // 30% de jitter
    final delayMs = baseDelay * (1 + jitter);
    
    // Limiter au délai maximum
    final delay = Duration(milliseconds: delayMs.toInt());
    return delay > maxRetryDelay ? maxRetryDelay : delay;
  }
  
  /// Indique si l'événement peut encore être réessayé
  bool get canRetry => attemptCount < maxRetries;
  
  /// Indique si l'événement a expiré (trop vieux pour être réessayé)
  bool get isExpired {
    final age = DateTime.now().difference(firstAttempt);
    return age > const Duration(minutes: 5); // Expire après 5 minutes
  }
  
  /// Crée une nouvelle instance avec un compteur d'essais incrémenté
  RetryableEvent retry({String? error}) {
    return RetryableEvent(
      event: event,
      attemptCount: attemptCount + 1,
      firstAttempt: firstAttempt,
      lastAttempt: DateTime.now(),
      lastError: error,
    );
  }
  
  /// Priorité pour l'ordonnancement des retries
  int get retryPriority {
    // Combiner la priorité de l'événement avec l'ancienneté
    final agePenalty = DateTime.now().difference(firstAttempt).inSeconds ~/ 10;
    return event.priority - agePenalty;
  }
  
  @override
  String toString() {
    return 'RetryableEvent('
        'type: ${event.eventType}, '
        'attempts: $attemptCount/$maxRetries, '
        'nextDelay: ${nextRetryDelay.inSeconds}s, '
        'canRetry: $canRetry, '
        'isExpired: $isExpired'
        ')';
  }
}