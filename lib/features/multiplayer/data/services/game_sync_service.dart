import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/errors/supabase_exceptions.dart';
import '../../../../core/errors/multiplayer_errors.dart';
import '../../../../core/monitoring/multiplayer_error_monitor.dart';
import '../../domain/entities/game_sync_event.dart';
import '../../domain/entities/retryable_event.dart';
import '../../domain/entities/room_event.dart';
import '../../../game/domain/entities/card.dart';
import '../../../game/domain/entities/action_card.dart';
import 'room_realtime_service.dart';

part 'game_sync_service.g.dart';

/// Service central unifié pour gérer toute la synchronisation du jeu
@riverpod
class GameSyncService extends _$GameSyncService {
  // Controllers et queues
  final _eventController = StreamController<GameSyncEvent>.broadcast();
  final _retryQueue = Queue<RetryableEvent>();
  final _processingEvents = <String, bool>{};
  
  Timer? _retryTimer;
  String? _currentRoomId;
  RoomRealtimeService? _realtimeService;
  StreamSubscription? _roomEventSubscription;
  StreamSubscription? _gameActionSubscription;
  
  @override
  Future<void> build() async {
    // Cleanup on dispose
    ref.onDispose(() {
      _cleanup();
    });
  }
  
  /// Initialise le service pour une room
  Future<void> initialize(String roomId) async {
    debugPrint('GameSyncService: Initializing for room $roomId');
    
    if (_currentRoomId == roomId) {
      debugPrint('GameSyncService: Already initialized for room $roomId');
      return;
    }
    
    // Nettoyer l'état précédent
    await dispose();
    
    _currentRoomId = roomId;
    
    try {
      // Obtenir le service realtime
      _realtimeService = ref.read(roomRealtimeServiceProvider.notifier);
      
      // S'abonner aux événements du service realtime
      _setupEventListeners();
      
      // Démarrer le timer de retry
      _startRetryTimer();
      
      debugPrint('GameSyncService: Successfully initialized');
    } catch (e) {
      debugPrint('GameSyncService: Initialization error - $e');
      _currentRoomId = null;
      rethrow;
    }
  }
  
  /// Configure les listeners d'événements
  void _setupEventListeners() {
    if (_realtimeService == null) return;
    
    // Écouter les événements de room
    _roomEventSubscription = _realtimeService!.roomEventStream.listen((roomEvent) {
      _handleRoomEvent(roomEvent);
    });
    
    // Écouter les actions de jeu
    _gameActionSubscription = _realtimeService!.gameActionStream.listen((action) {
      _handleGameAction(action);
    });
  }
  
  /// Traite les événements de room
  void _handleRoomEvent(RoomEvent roomEvent) {
    // Handle different RoomEvent types using union pattern
    final syncEvent = roomEvent.when<GameSyncEvent?>(
      playerJoined: (playerId, playerName) {
        // Player joined is handled by presence
        return null;
      },
      playerLeft: (playerId) {
        // Player left is handled by presence
        return null;
      },
      gameStarted: (gameId, initialState) {
        return GameSyncEvent.gameStarted(
          roomId: _currentRoomId!,
          gameId: gameId,
          playerIds: [], // Will be filled from game state
          timestamp: DateTime.now(),
        );
      },
      gameStateUpdated: (newState) {
        // Game state updates are handled separately
        return null;
      },
      playerAction: (playerId, actionType, actionData) {
        // Player actions are handled separately
        return null;
      },
    );
    
    if (syncEvent != null) {
      _emitEvent(syncEvent);
    }
  }
  
  /// Traite les actions de jeu
  void _handleGameAction(Map<String, dynamic> action) {
    final actionType = action['action_type'] as String;
    final playerId = action['player_id'] as String;
    final data = action['data'] as Map<String, dynamic>;
    final timestamp = DateTime.parse(action['timestamp'] as String);
    
    GameSyncEvent? syncEvent;
    
    switch (actionType) {
      case 'reveal_card':
        syncEvent = GameSyncEvent.cardRevealed(
          playerId: playerId,
          row: data['row'] as int,
          col: data['col'] as int,
          card: Card.fromJson(data['card'] as Map<String, dynamic>),
          timestamp: timestamp,
        );
        break;
        
      case 'play_action_card':
        syncEvent = GameSyncEvent.actionCardPlayed(
          playerId: playerId,
          actionCard: ActionCard.fromJson(data['action_card'] as Map<String, dynamic>),
          actionData: data['action_data'] as Map<String, dynamic>,
          timestamp: timestamp,
        );
        break;
        
      case 'chat':
        syncEvent = GameSyncEvent.chatMessage(
          playerId: playerId,
          message: data['message'] as String,
          timestamp: timestamp,
        );
        break;
        
      case 'turn_changed':
        syncEvent = GameSyncEvent.turnChanged(
          previousPlayerId: data['previous_player_id'] as String,
          currentPlayerId: data['current_player_id'] as String,
          turnNumber: data['turn_number'] as int,
          timestamp: timestamp,
        );
        break;
    }
    
    if (syncEvent != null) {
      _emitEvent(syncEvent);
    }
  }
  
  /// Émet un événement dans le stream
  void _emitEvent(GameSyncEvent event) {
    debugPrint('GameSyncService: Emitting event ${event.eventType}');
    _eventController.add(event);
  }
  
  /// Envoie un événement avec retry en cas d'échec
  Future<void> sendEvent(GameSyncEvent event) async {
    final eventId = '${event.eventType}_${DateTime.now().millisecondsSinceEpoch}';
    final stopwatch = Stopwatch()..start();
    
    // Éviter les doublons
    if (_processingEvents[eventId] == true) {
      debugPrint('GameSyncService: Event $eventId already processing');
      return;
    }
    
    _processingEvents[eventId] = true;
    
    // Ajouter breadcrumb pour tracer le contexte
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'Sending event: ${event.eventType}',
        category: 'sync',
        data: {
          'event_id': eventId,
          'room_id': _currentRoomId,
          'event_type': event.eventType,
        },
      ),
    );
    
    try {
      await _sendEventInternal(event);
      stopwatch.stop();
      
      // Capturer métriques de performance si l'opération est lente
      if (stopwatch.elapsedMilliseconds > 1000) {
        MultiplayerErrorMonitor.capturePerformanceMetric(
          operation: 'send_event_${event.eventType}',
          duration: stopwatch.elapsed,
          context: 'sync_service',
          roomId: _currentRoomId,
          isSlowOperation: true,
          metadata: {
            'event_id': eventId,
            'retry_queue_size': _retryQueue.length,
          },
        );
      }
      
      _processingEvents.remove(eventId);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _processingEvents.remove(eventId);
      
      // Capturer l'erreur de synchronisation avec contexte détaillé
      _handleSyncError(event, e, stackTrace, stopwatch.elapsed);
      
      // Ajouter à la queue de retry si l'événement doit persister
      if (event.shouldPersist) {
        debugPrint('GameSyncService: Adding event to retry queue - ${event.eventType}');
        _retryQueue.add(RetryableEvent(event: event));
      } else {
        debugPrint('GameSyncService: Event ${event.eventType} failed and won\'t be retried');
        _emitEvent(GameSyncEvent.syncError(
          errorType: 'send_failed',
          message: 'Failed to send event: ${event.eventType}',
          timestamp: DateTime.now(),
          context: {'originalError': e.toString()},
        ));
      }
    }
  }
  
  /// Envoie l'événement via le service realtime
  Future<void> _sendEventInternal(GameSyncEvent event) async {
    if (_realtimeService == null || !_realtimeService!.isConnected) {
      throw Exception('Not connected to room');
    }
    
    // Mapper l'événement vers une action realtime
    final actionType = event.eventType;
    final actionData = event.toJson();
    
    await _realtimeService!.sendGameAction(
      actionType: actionType,
      actionData: actionData,
    );
  }
  
  /// Démarre le timer de retry
  void _startRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _processRetryQueue();
    });
  }
  
  /// Traite la queue de retry
  Future<void> _processRetryQueue() async {
    if (_retryQueue.isEmpty) return;
    
    debugPrint('GameSyncService: Processing retry queue (${_retryQueue.length} events)');
    
    // Trier par priorité
    final sortedEvents = _retryQueue.toList()
      ..sort((a, b) => b.retryPriority.compareTo(a.retryPriority));
    
    _retryQueue.clear();
    
    for (final retryable in sortedEvents) {
      // Ignorer les événements expirés
      if (retryable.isExpired) {
        debugPrint('GameSyncService: Event expired - ${retryable.event.eventType}');
        continue;
      }
      
      // Vérifier si on peut réessayer
      if (!retryable.canRetry) {
        debugPrint('GameSyncService: Max retries reached for ${retryable.event.eventType}');
        _handleEventFailure(retryable);
        continue;
      }
      
      // Vérifier le délai
      final timeSinceLastAttempt = DateTime.now().difference(retryable.lastAttempt);
      if (timeSinceLastAttempt < retryable.nextRetryDelay) {
        // Remettre dans la queue pour plus tard
        _retryQueue.add(retryable);
        continue;
      }
      
      // Réessayer
      try {
        debugPrint('GameSyncService: Retrying ${retryable.event.eventType} (attempt ${retryable.attemptCount + 1})');
        await _sendEventInternal(retryable.event);
        debugPrint('GameSyncService: Retry successful for ${retryable.event.eventType}');
      } catch (e) {
        debugPrint('GameSyncService: Retry failed for ${retryable.event.eventType} - $e');
        _retryQueue.add(retryable.retry(error: e.toString()));
      }
    }
  }
  
  /// Gère une erreur de synchronisation
  void _handleSyncError(GameSyncEvent event, dynamic error, StackTrace? stackTrace, Duration elapsed) {
    final currentUser = ref.read(supabaseClientProvider).auth.currentUser;
    final playerId = currentUser?.id ?? 'unknown';
    
    MultiplayerErrorMonitor.captureSyncError(
      error,
      roomId: _currentRoomId ?? 'unknown',
      playerId: playerId,
      action: event.eventType,
      phase: 'send_event',
      attemptNumber: 1,
      elapsed: elapsed,
      stackTrace: stackTrace,
      gameState: _buildGameStateSnapshot(event),
    );
  }
  
  /// Construit un snapshot de l'état du jeu pour le monitoring
  Map<String, dynamic>? _buildGameStateSnapshot(GameSyncEvent event) {
    try {
      return {
        'event_type': event.eventType,
        'room_id': _currentRoomId,
        'retry_queue_size': _retryQueue.length,
        'processing_events_count': _processingEvents.length,
        'is_connected': _realtimeService?.isConnected ?? false,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return null;
    }
  }
  
  /// Valide la cohérence de l'état après un événement
  void _validateStateConsistency(Map<String, dynamic> localState, Map<String, dynamic> remoteState) {
    // Vérifier cohérence player_ids
    final localPlayerIds = localState['player_ids'] as List<dynamic>?;
    final remotePlayerIds = remoteState['player_ids'] as List<dynamic>?;
    
    if (localPlayerIds != null && remotePlayerIds != null) {
      if (!_listEquals(localPlayerIds, remotePlayerIds)) {
        MultiplayerErrorMonitor.captureInconsistency(
          type: 'player_list_mismatch',
          expected: {'player_ids': localPlayerIds},
          actual: {'player_ids': remotePlayerIds},
          context: 'room_${_currentRoomId}',
          roomId: _currentRoomId,
          description: 'Player lists do not match between local and remote state',
        );
      }
    }
    
    // Vérifier cohérence des scores
    final localScores = localState['scores'] as Map<String, dynamic>?;
    final remoteScores = remoteState['scores'] as Map<String, dynamic>?;
    
    if (localScores != null && remoteScores != null) {
      if (!_mapEquals(localScores, remoteScores)) {
        MultiplayerErrorMonitor.captureInconsistency(
          type: 'score_mismatch',
          expected: localScores,
          actual: remoteScores,
          context: 'room_${_currentRoomId}',
          roomId: _currentRoomId,
          description: 'Score values do not match between local and remote state',
        );
      }
    }
    
    // Vérifier cohérence du statut de la partie
    final localStatus = localState['status'] as String?;
    final remoteStatus = remoteState['status'] as String?;
    
    if (localStatus != null && remoteStatus != null && localStatus != remoteStatus) {
      MultiplayerErrorMonitor.captureInconsistency(
        type: 'game_status_mismatch',
        expected: {'status': localStatus},
        actual: {'status': remoteStatus},
        context: 'room_${_currentRoomId}',
        roomId: _currentRoomId,
        description: 'Game status does not match between local and remote state',
      );
    }
  }
  
  /// Helper pour comparer des listes
  bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
  
  /// Helper pour comparer des maps
  bool _mapEquals<K, V>(Map<K, V> map1, Map<K, V> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
    }
    return true;
  }
  
  /// Gère l'échec définitif d'un événement
  void _handleEventFailure(RetryableEvent retryable) {
    debugPrint('GameSyncService: Event permanently failed - ${retryable.event.eventType}');
    
    // Capturer l'échec permanent
    final currentUser = ref.read(supabaseClientProvider).auth.currentUser;
    final playerId = currentUser?.id ?? 'unknown';
    
    MultiplayerErrorMonitor.captureSyncError(
      MultiplayerSyncException(
        message: 'Event failed permanently after ${retryable.attemptCount} attempts',
        roomId: _currentRoomId,
        playerId: playerId,
        metadata: {
          'event_type': retryable.event.eventType,
          'attempts': retryable.attemptCount,
          'last_error': retryable.lastError,
          'total_duration_ms': DateTime.now().difference(retryable.firstAttempt).inMilliseconds,
        },
      ),
      roomId: _currentRoomId ?? 'unknown',
      playerId: playerId,
      action: retryable.event.eventType,
      phase: 'permanent_failure',
      attemptNumber: retryable.attemptCount,
    );
    
    _emitEvent(GameSyncEvent.syncError(
      errorType: 'permanent_failure',
      message: 'Event failed after ${retryable.attemptCount} attempts',
      timestamp: DateTime.now(),
      context: {
        'eventType': retryable.event.eventType,
        'attempts': retryable.attemptCount,
        'lastError': retryable.lastError,
      },
    ));
  }
  
  /// Nettoie le service
  Future<void> dispose() async {
    _cleanup();
  }
  
  void _cleanup() {
    debugPrint('GameSyncService: Cleaning up');
    
    _retryTimer?.cancel();
    _retryTimer = null;
    
    _roomEventSubscription?.cancel();
    _gameActionSubscription?.cancel();
    
    _eventController.close();
    _retryQueue.clear();
    _processingEvents.clear();
    
    _currentRoomId = null;
    _realtimeService = null;
  }
  
  // Getters publics
  
  /// Stream d'événements de synchronisation
  Stream<GameSyncEvent> get events => _eventController.stream;
  
  /// Nombre d'événements en attente de retry
  int get pendingRetryCount => _retryQueue.length;
  
  /// ID de la room actuelle
  String? get currentRoomId => _currentRoomId;
  
  /// Est initialisé et connecté
  bool get isInitialized => _currentRoomId != null && _realtimeService != null;
}