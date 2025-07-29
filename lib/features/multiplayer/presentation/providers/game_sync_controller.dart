import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/game_sync_service.dart';
import '../../domain/entities/game_sync_event.dart';
import '../../../game/domain/entities/card.dart';
import '../../../game/domain/entities/action_card.dart';
import '../../../game/domain/entities/game_state.dart';

part 'game_sync_controller.g.dart';

/// Controller pour gérer le GameSyncService unifié
@riverpod
class GameSyncController extends _$GameSyncController {
  late final GameSyncService _syncService;
  
  @override
  Future<void> build() async {
    _syncService = ref.watch(gameSyncServiceProvider.notifier);
  }
  
  /// Initialise le service pour une room
  Future<void> initializeForRoom(String roomId) async {
    debugPrint('GameSyncController: Initializing for room $roomId');
    await _syncService.initialize(roomId);
  }
  
  /// Révèle une carte
  Future<void> revealCard({
    required String playerId,
    required int row,
    required int col,
    required Card card,
  }) async {
    final event = GameSyncEvent.cardRevealed(
      playerId: playerId,
      row: row,
      col: col,
      card: card,
      timestamp: DateTime.now(),
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Joue une carte action
  Future<void> playActionCard({
    required String playerId,
    required ActionCard actionCard,
    required Map<String, dynamic> actionData,
  }) async {
    final event = GameSyncEvent.actionCardPlayed(
      playerId: playerId,
      actionCard: actionCard,
      actionData: actionData,
      timestamp: DateTime.now(),
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Envoie un message de chat
  Future<void> sendChatMessage({
    required String playerId,
    required String message,
  }) async {
    final event = GameSyncEvent.chatMessage(
      playerId: playerId,
      message: message,
      timestamp: DateTime.now(),
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Met à jour l'état du jeu
  Future<void> updateGameState({
    required GameState gameState,
    String? triggeredBy,
  }) async {
    final event = GameSyncEvent.gameStateUpdated(
      gameState: gameState,
      timestamp: DateTime.now(),
      triggeredBy: triggeredBy,
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Notifie un changement de tour
  Future<void> notifyTurnChange({
    required String previousPlayerId,
    required String currentPlayerId,
    required int turnNumber,
  }) async {
    final event = GameSyncEvent.turnChanged(
      previousPlayerId: previousPlayerId,
      currentPlayerId: currentPlayerId,
      turnNumber: turnNumber,
      timestamp: DateTime.now(),
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Démarre la partie
  Future<void> startGame({
    required String roomId,
    required String gameId,
    required List<String> playerIds,
  }) async {
    final event = GameSyncEvent.gameStarted(
      roomId: roomId,
      gameId: gameId,
      playerIds: playerIds,
      timestamp: DateTime.now(),
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Termine la partie
  Future<void> endGame({
    required String gameId,
    required Map<String, int> finalScores,
    required String winnerId,
  }) async {
    final event = GameSyncEvent.gameEnded(
      gameId: gameId,
      finalScores: finalScores,
      winnerId: winnerId,
      timestamp: DateTime.now(),
    );
    
    await _syncService.sendEvent(event);
  }
  
  /// Nombre d'événements en attente de retry
  int get pendingRetryCount => _syncService.pendingRetryCount;
  
  /// Est initialisé
  bool get isInitialized => _syncService.isInitialized;
}

/// Provider pour accéder au stream d'événements de synchronisation
@riverpod
Stream<GameSyncEvent> gameSyncEventStream(GameSyncEventStreamRef ref) {
  final service = ref.watch(gameSyncServiceProvider.notifier);
  return service.events;
}

/// Provider pour filtrer les événements par type
/// Note: Les providers génériques ne sont pas supportés par riverpod_annotation
/// On crée des providers spécifiques pour chaque type d'événement nécessaire

/// Provider pour les événements de chat uniquement
@riverpod
Stream<ChatMessageEvent> chatMessageStream(ChatMessageStreamRef ref) {
  final service = ref.watch(gameSyncServiceProvider.notifier);
  return service.events.where((event) => event is ChatMessageEvent).cast<ChatMessageEvent>();
}

/// Provider pour les événements de jeu critiques
@riverpod
Stream<GameSyncEvent> criticalGameEventsStream(CriticalGameEventsStreamRef ref) {
  final service = ref.watch(gameSyncServiceProvider.notifier);
  
  return service.events.where((event) {
    return event is GameStateUpdatedEvent ||
           event is TurnChangedEvent ||
           event is GameStartedEvent ||
           event is GameEndedEvent;
  });
}

/// Provider pour les événements d'erreur
@riverpod
Stream<SyncErrorEvent> syncErrorStream(SyncErrorStreamRef ref) {
  final service = ref.watch(gameSyncServiceProvider.notifier);
  return service.events.where((event) => event is SyncErrorEvent).cast<SyncErrorEvent>();
}