import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/foundation.dart';
import '../errors/multiplayer_errors.dart';
import '../../features/game/domain/entities/game_state.dart';

/// Monitor pour capturer et tracker les erreurs spécifiques au multijoueur
class MultiplayerErrorMonitor {
  static const String syncErrorTag = 'multiplayer.sync';
  static const String inconsistencyTag = 'multiplayer.inconsistency';
  static const String connectionTag = 'multiplayer.connection';
  static const String performanceTag = 'multiplayer.performance';
  
  /// Capture une erreur de synchronisation avec contexte détaillé
  static void captureSyncError(
    dynamic error, {
    required String roomId,
    required String playerId,
    Map<String, dynamic>? gameState,
    String? action,
    String? phase,
    int? attemptNumber,
    Duration? elapsed,
    StackTrace? stackTrace,
  }) {
    try {
      Sentry.captureException(
        MultiplayerSyncException(
          message: error.toString(),
          roomId: roomId,
          playerId: playerId,
          metadata: {
            'action': action,
            'phase': phase,
            'attempt_number': attemptNumber,
            'elapsed_ms': elapsed?.inMilliseconds,
            'game_state_snapshot': gameState,
          },
        ),
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('error.type', syncErrorTag);
          scope.setTag('multiplayer.room_id', roomId);
          scope.setTag('multiplayer.player_id', playerId);
          
          if (action != null) {
            scope.setTag('multiplayer.action', action);
          }
          
          if (phase != null) {
            scope.setTag('multiplayer.phase', phase);
          }
          
          scope.setContexts('multiplayer', {
            'room_id': roomId,
            'player_id': playerId,
            'action': action,
            'phase': phase,
            'attempt_number': attemptNumber,
            'timestamp': DateTime.now().toIso8601String(),
            'device_info': {
              'platform': defaultTargetPlatform.name,
              'debug_mode': kDebugMode,
            },
          });
          
          if (gameState != null) {
            scope.setContexts('game_state', {
              'status': gameState['status'],
              'player_count': gameState['player_count'],
              'current_player': gameState['current_player'],
              'turn_number': gameState['turn_number'],
              'round_number': gameState['round_number'],
            });
          }
          
          // Fingerprint pour regrouper les erreurs similaires
          scope.fingerprint = [
            'multiplayer',
            'sync_error',
            action ?? 'unknown',
            error.runtimeType.toString(),
          ];
          
          scope.level = SentryLevel.error;
        },
      );
      
      // Ajouter breadcrumb pour le contexte
      _addBreadcrumb(
        message: 'Sync error occurred: ${error.toString()}',
        category: 'sync',
        level: SentryLevel.error,
        data: {
          'room_id': roomId,
          'player_id': playerId,
          'action': action,
          'attempt': attemptNumber,
        },
      );
    } catch (e) {
      // Éviter les erreurs en cascade si Sentry échoue
      debugPrint('Failed to capture sync error: $e');
    }
  }
  
  /// Capture une incohérence de données détectée
  static void captureInconsistency({
    required String type,
    required Map<String, dynamic> expected,
    required Map<String, dynamic> actual,
    required String context,
    String? roomId,
    String? playerId,
    String? description,
    SentryLevel level = SentryLevel.warning,
  }) {
    try {
      final inconsistency = MultiplayerInconsistency(
        type: type,
        expected: expected,
        actual: actual,
        context: context,
        roomId: roomId,
        playerId: playerId,
        description: description,
      );
      
      Sentry.captureMessage(
        'Incohérence détectée: $type${description != null ? ' - $description' : ''}',
        level: level,
        withScope: (scope) {
          scope.setTag('error.type', inconsistencyTag);
          scope.setTag('inconsistency.type', type);
          
          if (roomId != null) {
            scope.setTag('multiplayer.room_id', roomId);
          }
          
          if (playerId != null) {
            scope.setTag('multiplayer.player_id', playerId);
          }
          
          scope.setContexts('inconsistency', inconsistency.toJson());
          
          scope.fingerprint = [
            'multiplayer',
            'inconsistency',
            type,
            context,
          ];
        },
      );
      
      _addBreadcrumb(
        message: 'Data inconsistency detected: $type',
        category: 'inconsistency',
        level: level,
        data: {
          'type': type,
          'context': context,
          'room_id': roomId,
          'delta_count': inconsistency.deltaCount,
        },
      );
    } catch (e) {
      debugPrint('Failed to capture inconsistency: $e');
    }
  }
  
  /// Capture les erreurs de connexion réseau
  static void captureConnectionError(
    dynamic error, {
    required String context,
    String? roomId,
    String? playerId,
    String? endpoint,
    int? statusCode,
    Duration? timeout,
    int? retryCount,
  }) {
    try {
      Sentry.captureException(
        error,
        withScope: (scope) {
          scope.setTag('error.type', connectionTag);
          scope.setTag('network.context', context);
          
          if (statusCode != null) {
            scope.setTag('network.status_code', statusCode.toString());
          }
          
          if (roomId != null) {
            scope.setTag('multiplayer.room_id', roomId);
          }
          
          scope.setContexts('network', {
            'context': context,
            'endpoint': endpoint,
            'status_code': statusCode,
            'timeout_ms': timeout?.inMilliseconds,
            'retry_count': retryCount,
            'timestamp': DateTime.now().toIso8601String(),
          });
          
          scope.fingerprint = [
            'multiplayer',
            'connection',
            context,
            statusCode?.toString() ?? 'unknown',
          ];
          
          scope.level = _getConnectionErrorLevel(statusCode);
        },
      );
      
      _addBreadcrumb(
        message: 'Connection error: $context',
        category: 'connection',
        level: _getConnectionErrorLevel(statusCode),
        data: {
          'context': context,
          'endpoint': endpoint,
          'status_code': statusCode,
          'retry_count': retryCount,
        },
      );
    } catch (e) {
      debugPrint('Failed to capture connection error: $e');
    }
  }
  
  /// Capture les métriques de performance
  static void capturePerformanceMetric({
    required String operation,
    required Duration duration,
    required String context,
    String? roomId,
    String? playerId,
    Map<String, dynamic>? metadata,
    bool isSlowOperation = false,
  }) {
    try {
      final level = isSlowOperation ? SentryLevel.warning : SentryLevel.info;
      
      Sentry.captureMessage(
        'Performance metric: $operation (${duration.inMilliseconds}ms)',
        level: level,
        withScope: (scope) {
          scope.setTag('error.type', performanceTag);
          scope.setTag('performance.operation', operation);
          scope.setTag('performance.slow', isSlowOperation.toString());
          
          if (roomId != null) {
            scope.setTag('multiplayer.room_id', roomId);
          }
          
          scope.setContexts('performance', {
            'operation': operation,
            'duration_ms': duration.inMilliseconds,
            'context': context,
            'is_slow': isSlowOperation,
            'metadata': metadata,
            'timestamp': DateTime.now().toIso8601String(),
          });
          
          scope.fingerprint = [
            'multiplayer',
            'performance',
            operation,
            isSlowOperation ? 'slow' : 'normal',
          ];
        },
      );
      
      if (isSlowOperation) {
        _addBreadcrumb(
          message: 'Slow operation detected: $operation (${duration.inMilliseconds}ms)',
          category: 'performance',
          level: SentryLevel.warning,
          data: {
            'operation': operation,
            'duration_ms': duration.inMilliseconds,
            'context': context,
            'room_id': roomId,
          },
        );
      }
    } catch (e) {
      debugPrint('Failed to capture performance metric: $e');
    }
  }
  
  /// Helper pour ajouter des breadcrumbs
  static void _addBreadcrumb({
    required String message,
    required String category,
    SentryLevel? level,
    Map<String, dynamic>? data,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: 'multiplayer.$category',
        data: data,
        level: level ?? SentryLevel.info,
        timestamp: DateTime.now(),
      ),
    );
  }
  
  /// Détermine le niveau d'erreur selon le code de statut
  static SentryLevel _getConnectionErrorLevel(int? statusCode) {
    if (statusCode == null) return SentryLevel.error;
    
    if (statusCode >= 500) return SentryLevel.error;
    if (statusCode >= 400) return SentryLevel.warning;
    return SentryLevel.info;
  }
  
  /// Capture le contexte complet d'une session multijoueur
  static void captureSessionContext({
    required String roomId,
    required List<String> playerIds,
    required String gameStatus,
    required int turnNumber,
    required String currentPlayerId,
    Map<String, dynamic>? additionalContext,
  }) {
    try {
      Sentry.configureScope((scope) {
        scope.setContexts('multiplayer_session', {
          'room_id': roomId,
          'player_count': playerIds.length,
          'player_ids': playerIds,
          'game_status': gameStatus,
          'turn_number': turnNumber,
          'current_player_id': currentPlayerId,
          'session_start': DateTime.now().toIso8601String(),
          ...?additionalContext,
        });
        
        scope.setTag('multiplayer.active_session', 'true');
        scope.setTag('multiplayer.room_id', roomId);
        scope.setUser(SentryUser(
          id: currentPlayerId,
          data: {
            'room_id': roomId,
            'player_count': playerIds.length,
          },
        ));
      });
      
      _addBreadcrumb(
        message: 'Multiplayer session context captured',
        category: 'session',
        data: {
          'room_id': roomId,
          'player_count': playerIds.length,
          'game_status': gameStatus,
        },
      );
    } catch (e) {
      debugPrint('Failed to capture session context: $e');
    }
  }
  
  /// Nettoie le contexte de session
  static void clearSessionContext() {
    try {
      Sentry.configureScope((scope) {
        // Clear multiplayer session context
        scope.setContexts('multiplayer_session', {});
        scope.removeTag('multiplayer.active_session');
        scope.removeTag('multiplayer.room_id');
        scope.setUser(null);
      });
      
      _addBreadcrumb(
        message: 'Multiplayer session context cleared',
        category: 'session',
      );
    } catch (e) {
      debugPrint('Failed to clear session context: $e');
    }
  }
}