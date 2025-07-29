import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../game/domain/entities/game_state.dart';
import '../../../game/domain/entities/player_state.dart';
import '../../../game/domain/entities/card.dart';
import '../../../game/domain/entities/action_card.dart';
import 'lobby_player.dart';
import 'room.dart';
import '../../data/converters/game_state_converter.dart';

part 'game_sync_event.freezed.dart';
part 'game_sync_event.g.dart';

/// Événements unifiés pour la synchronisation du jeu
@Freezed(unionKey: 'type')
abstract class GameSyncEvent with _$GameSyncEvent {
  const GameSyncEvent._();
  
  /// Un joueur rejoint la partie
  const factory GameSyncEvent.playerJoined({
    required LobbyPlayer player,
    required DateTime timestamp,
  }) = PlayerJoinedEvent;
  
  /// Un joueur quitte la partie
  const factory GameSyncEvent.playerLeft({
    required String playerId,
    required DateTime timestamp,
    @Default(false) bool isTimeout,
  }) = PlayerLeftEvent;
  
  /// L'état du jeu est mis à jour
  const factory GameSyncEvent.gameStateUpdated({
    @GameStateConverter() required GameState gameState,
    required DateTime timestamp,
    String? triggeredBy,
  }) = GameStateUpdatedEvent;
  
  /// Une carte est révélée
  const factory GameSyncEvent.cardRevealed({
    required String playerId,
    required int row,
    required int col,
    required Card card,
    required DateTime timestamp,
  }) = CardRevealedEvent;
  
  /// Une carte action est jouée
  const factory GameSyncEvent.actionCardPlayed({
    required String playerId,
    required ActionCard actionCard,
    required Map<String, dynamic> actionData,
    required DateTime timestamp,
  }) = ActionCardPlayedEvent;
  
  /// Le tour change
  const factory GameSyncEvent.turnChanged({
    required String previousPlayerId,
    required String currentPlayerId,
    required int turnNumber,
    required DateTime timestamp,
  }) = TurnChangedEvent;
  
  /// Les paramètres de la room changent
  const factory GameSyncEvent.roomSettingsChanged({
    required Map<String, dynamic> settings,
    required DateTime timestamp,
    required String changedBy,
  }) = RoomSettingsChangedEvent;
  
  /// La partie commence
  const factory GameSyncEvent.gameStarted({
    required String roomId,
    required String gameId,
    required List<String> playerIds,
    required DateTime timestamp,
  }) = GameStartedEvent;
  
  /// La partie se termine
  const factory GameSyncEvent.gameEnded({
    required String gameId,
    required Map<String, int> finalScores,
    required String winnerId,
    required DateTime timestamp,
  }) = GameEndedEvent;
  
  /// Un joueur se déconnecte temporairement
  const factory GameSyncEvent.playerDisconnected({
    required String playerId,
    required DateTime disconnectedAt,
    required DateTime timeoutAt,
  }) = PlayerDisconnectedEvent;
  
  /// Un joueur se reconnecte
  const factory GameSyncEvent.playerReconnected({
    required String playerId,
    required DateTime reconnectedAt,
  }) = PlayerReconnectedEvent;
  
  /// Message de chat
  const factory GameSyncEvent.chatMessage({
    required String playerId,
    required String message,
    required DateTime timestamp,
  }) = ChatMessageEvent;
  
  /// Erreur de synchronisation
  const factory GameSyncEvent.syncError({
    required String errorType,
    required String message,
    required DateTime timestamp,
    Map<String, dynamic>? context,
  }) = SyncErrorEvent;
  
  
  /// Type d'événement pour faciliter le filtrage
  String get eventType => when(
    playerJoined: (_,__) => 'player_joined',
    playerLeft: (_,__,___) => 'player_left',
    gameStateUpdated: (_,__,___) => 'game_state_updated',
    cardRevealed: (_,__,___,____,_____) => 'card_revealed',
    actionCardPlayed: (_,__,___,____) => 'action_card_played',
    turnChanged: (_,__,___,____) => 'turn_changed',
    roomSettingsChanged: (_,__,___) => 'room_settings_changed',
    gameStarted: (_,__,___,____) => 'game_started',
    gameEnded: (_,__,___,____) => 'game_ended',
    playerDisconnected: (_,__,___) => 'player_disconnected',
    playerReconnected: (_,__) => 'player_reconnected',
    chatMessage: (_,__,___) => 'chat_message',
    syncError: (_,__,___,____) => 'sync_error',
  );
  
  factory GameSyncEvent.fromJson(Map<String, dynamic> json) =>
      _$GameSyncEventFromJson(json);
  
  /// Manual toJson implementation because of freezed union type
  Map<String, dynamic> toJson() {
    return when(
      playerJoined: (player, timestamp) => {
        'type': 'playerJoined',
        'player': player.toJson(),
        'timestamp': timestamp.toIso8601String(),
      },
      playerLeft: (playerId, timestamp, isTimeout) => {
        'type': 'playerLeft',
        'playerId': playerId,
        'timestamp': timestamp.toIso8601String(),
        'isTimeout': isTimeout,
      },
      gameStateUpdated: (gameState, timestamp, triggeredBy) => {
        'type': 'gameStateUpdated',
        'gameState': const GameStateConverter().toJson(gameState),
        'timestamp': timestamp.toIso8601String(),
        'triggeredBy': triggeredBy,
      },
      cardRevealed: (playerId, row, col, card, timestamp) => {
        'type': 'cardRevealed',
        'playerId': playerId,
        'row': row,
        'col': col,
        'card': card.toJson(),
        'timestamp': timestamp.toIso8601String(),
      },
      actionCardPlayed: (playerId, actionCard, actionData, timestamp) => {
        'type': 'actionCardPlayed',
        'playerId': playerId,
        'actionCard': actionCard.toJson(),
        'actionData': actionData,
        'timestamp': timestamp.toIso8601String(),
      },
      turnChanged: (previousPlayerId, currentPlayerId, turnNumber, timestamp) => {
        'type': 'turnChanged',
        'previousPlayerId': previousPlayerId,
        'currentPlayerId': currentPlayerId,
        'turnNumber': turnNumber,
        'timestamp': timestamp.toIso8601String(),
      },
      roomSettingsChanged: (settings, timestamp, changedBy) => {
        'type': 'roomSettingsChanged',
        'settings': settings,
        'timestamp': timestamp.toIso8601String(),
        'changedBy': changedBy,
      },
      gameStarted: (roomId, gameId, playerIds, timestamp) => {
        'type': 'gameStarted',
        'roomId': roomId,
        'gameId': gameId,
        'playerIds': playerIds,
        'timestamp': timestamp.toIso8601String(),
      },
      gameEnded: (gameId, finalScores, winnerId, timestamp) => {
        'type': 'gameEnded',
        'gameId': gameId,
        'finalScores': finalScores,
        'winnerId': winnerId,
        'timestamp': timestamp.toIso8601String(),
      },
      playerDisconnected: (playerId, disconnectedAt, timeoutAt) => {
        'type': 'playerDisconnected',
        'playerId': playerId,
        'disconnectedAt': disconnectedAt.toIso8601String(),
        'timeoutAt': timeoutAt.toIso8601String(),
      },
      playerReconnected: (playerId, reconnectedAt) => {
        'type': 'playerReconnected',
        'playerId': playerId,
        'reconnectedAt': reconnectedAt.toIso8601String(),
      },
      chatMessage: (playerId, message, timestamp) => {
        'type': 'chatMessage',
        'playerId': playerId,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      },
      syncError: (errorType, message, timestamp, context) => {
        'type': 'syncError',
        'errorType': errorType,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'context': context,
      },
    );
  }
  
  /// Priorité de l'événement pour le retry
  int get priority => when(
    playerJoined: (_,__) => 3,
    playerLeft: (_,__,___) => 3,
    gameStateUpdated: (_,__,___) => 1, // Plus haute priorité
    cardRevealed: (_,__,___,____,_____) => 2,
    actionCardPlayed: (_,__,___,____) => 2,
    turnChanged: (_,__,___,____) => 1,
    roomSettingsChanged: (_,__,___) => 3,
    gameStarted: (_,__,___,____) => 1,
    gameEnded: (_,__,___,____) => 1,
    playerDisconnected: (_,__,___) => 2,
    playerReconnected: (_,__) => 2,
    chatMessage: (_,__,___) => 4, // Plus basse priorité
    syncError: (_,__,___,____) => 1,
  );
  
  /// Indique si l'événement doit être persisté en cas d'échec
  bool get shouldPersist => when(
    playerJoined: (_,__) => true,
    playerLeft: (_,__,___) => true,
    gameStateUpdated: (_,__,___) => true,
    cardRevealed: (_,__,___,____,_____) => true,
    actionCardPlayed: (_,__,___,____) => true,
    turnChanged: (_,__,___,____) => true,
    roomSettingsChanged: (_,__,___) => true,
    gameStarted: (_,__,___,____) => true,
    gameEnded: (_,__,___,____) => true,
    playerDisconnected: (_,__,___) => true,
    playerReconnected: (_,__) => true,
    chatMessage: (_,__,___) => false, // Pas critique
    syncError: (_,__,___,____) => false,
  );
}