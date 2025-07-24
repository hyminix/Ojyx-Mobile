import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/game_player.dart';
import '../../domain/entities/player_grid.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/action_card.dart';

part 'game_state_model.freezed.dart';
part 'game_state_model.g.dart';

@freezed
class GameStateModel with _$GameStateModel {
  const factory GameStateModel({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    required String status,
    @JsonKey(name: 'current_player_id') required String currentPlayerId,
    @JsonKey(name: 'turn_number') required int turnNumber,
    @JsonKey(name: 'round_number') required int roundNumber,
    @JsonKey(name: 'game_data') required Map<String, dynamic> gameData,
    @JsonKey(name: 'winner_id') String? winnerId,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _GameStateModel;

  const GameStateModel._();

  factory GameStateModel.fromJson(Map<String, dynamic> json) => _$GameStateModelFromJson(json);

  factory GameStateModel.fromDomainComplete(
    GameState gameState, {
    required String id,
    required int turnNumber,
    required int roundNumber,
    required DateTime updatedAt,
  }) {
    final currentPlayerId = gameState.players[gameState.currentPlayerIndex].id;
    
    final gameData = {
      'players': gameState.players.map((p) => {
        'id': p.id,
        'name': p.name,
        'grid': {
          'cards': p.grid.cards.map((row) => 
            row.map((c) => c != null ? {
              'value': c.value,
              'isRevealed': c.isRevealed,
            } : null).toList()
          ).toList(),
        },
        'actionCards': p.actionCards.map((a) => {
          'id': a.id,
          'type': a.type.name,
          'name': a.name,
          'description': a.description,
          'timing': a.timing.name,
          'target': a.target.name,
          'parameters': a.parameters,
        }).toList(),
        'isConnected': p.isConnected,
        'isHost': p.isHost,
        'hasFinishedRound': p.hasFinishedRound,
        'scoreMultiplier': p.scoreMultiplier,
      }).toList(),
      'currentPlayerIndex': gameState.currentPlayerIndex,
      'deck': gameState.deck.map((c) => {
        'value': c.value,
        'isRevealed': c.isRevealed,
      }).toList(),
      'discardPile': gameState.discardPile.map((c) => {
        'value': c.value,
        'isRevealed': c.isRevealed,
      }).toList(),
      'actionDeck': gameState.actionDeck.map((a) => {
        'id': a.id,
        'type': a.type.name,
        'name': a.name,
        'description': a.description,
        'timing': a.timing.name,
        'target': a.target.name,
        'parameters': a.parameters,
      }).toList(),
      'actionDiscard': gameState.actionDiscard.map((a) => {
        'id': a.id,
        'type': a.type.name,
        'name': a.name,
        'description': a.description,
        'timing': a.timing.name,
        'target': a.target.name,
        'parameters': a.parameters,
      }).toList(),
      'turnDirection': gameState.turnDirection.name,
      'lastRound': gameState.lastRound,
      'initiatorPlayerId': gameState.initiatorPlayerId,
      'endRoundInitiator': gameState.endRoundInitiator,
      'drawnCard': gameState.drawnCard != null ? {
        'value': gameState.drawnCard!.value,
        'isRevealed': gameState.drawnCard!.isRevealed,
      } : null,
      'startedAt': gameState.startedAt?.toIso8601String(),
    };

    return GameStateModel(
      id: id,
      roomId: gameState.roomId,
      status: gameState.status.name,
      currentPlayerId: currentPlayerId,
      turnNumber: turnNumber,
      roundNumber: roundNumber,
      gameData: gameData,
      winnerId: null, // Set from gameState.finishedAt logic if needed
      endedAt: gameState.finishedAt,
      createdAt: gameState.createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
    );
  }

  GameState toDomainComplete() {
    // Reconstruct players from gameData
    final playersData = gameData['players'] as List<dynamic>;
    final players = playersData.map((playerJson) {
      final gridData = playerJson['grid'] as Map<String, dynamic>;
      final cardsData = gridData['cards'] as List<dynamic>;
      
      final gridCards = cardsData.map((rowData) {
        final row = rowData as List<dynamic>;
        return row.map((cardData) {
          if (cardData == null) return null;
          final cardMap = cardData as Map<String, dynamic>;
          return Card(
            value: cardMap['value'] as int,
            isRevealed: cardMap['isRevealed'] as bool? ?? false,
          );
        }).toList();
      }).toList();

      final grid = PlayerGrid(cards: List<List<Card?>>.from(gridCards));

      final actionCardsData = playerJson['actionCards'] as List<dynamic>;
      final actionCards = actionCardsData.map((cardData) {
        final cardMap = cardData as Map<String, dynamic>;
        return ActionCard(
          id: cardMap['id'] as String,
          type: ActionCardType.values.firstWhere(
            (t) => t.name == cardMap['type'],
            orElse: () => ActionCardType.teleport,
          ),
          name: cardMap['name'] as String,
          description: cardMap['description'] as String,
          timing: ActionTiming.values.firstWhere(
            (t) => t.name == cardMap['timing'],
            orElse: () => ActionTiming.optional,
          ),
          target: ActionTarget.values.firstWhere(
            (t) => t.name == cardMap['target'],
            orElse: () => ActionTarget.none,
          ),
          parameters: Map<String, dynamic>.from(cardMap['parameters'] as Map? ?? {}),
        );
      }).toList();

      return GamePlayer(
        id: playerJson['id'] as String,
        name: playerJson['name'] as String,
        grid: grid,
        actionCards: actionCards,
        isConnected: playerJson['isConnected'] as bool? ?? true,
        isHost: playerJson['isHost'] as bool? ?? false,
        hasFinishedRound: playerJson['hasFinishedRound'] as bool? ?? false,
        scoreMultiplier: playerJson['scoreMultiplier'] as int? ?? 1,
      );
    }).toList();

    // Reconstruct deck
    final deckData = gameData['deck'] as List<dynamic>;
    final deck = deckData.map((cardData) {
      final cardMap = cardData as Map<String, dynamic>;
      return Card(
        value: cardMap['value'] as int,
        isRevealed: cardMap['isRevealed'] as bool? ?? false,
      );
    }).toList();

    // Reconstruct discard pile
    final discardData = gameData['discardPile'] as List<dynamic>;
    final discardPile = discardData.map((cardData) {
      final cardMap = cardData as Map<String, dynamic>;
      return Card(
        value: cardMap['value'] as int,
        isRevealed: cardMap['isRevealed'] as bool? ?? false,
      );
    }).toList();

    // Reconstruct action deck
    final actionDeckData = gameData['actionDeck'] as List<dynamic>;
    final actionDeck = actionDeckData.map((cardData) {
      final cardMap = cardData as Map<String, dynamic>;
      return ActionCard(
        id: cardMap['id'] as String,
        type: ActionCardType.values.firstWhere(
          (t) => t.name == cardMap['type'],
          orElse: () => ActionCardType.teleport,
        ),
        name: cardMap['name'] as String,
        description: cardMap['description'] as String,
        timing: ActionTiming.values.firstWhere(
          (t) => t.name == cardMap['timing'],
          orElse: () => ActionTiming.optional,
        ),
        target: ActionTarget.values.firstWhere(
          (t) => t.name == cardMap['target'],
          orElse: () => ActionTarget.none,
        ),
        parameters: Map<String, dynamic>.from(cardMap['parameters'] as Map? ?? {}),
      );
    }).toList();

    // Reconstruct action discard
    final actionDiscardData = gameData['actionDiscard'] as List<dynamic>;
    final actionDiscard = actionDiscardData.map((cardData) {
      final cardMap = cardData as Map<String, dynamic>;
      return ActionCard(
        id: cardMap['id'] as String,
        type: ActionCardType.values.firstWhere(
          (t) => t.name == cardMap['type'],
          orElse: () => ActionCardType.teleport,
        ),
        name: cardMap['name'] as String,
        description: cardMap['description'] as String,
        timing: ActionTiming.values.firstWhere(
          (t) => t.name == cardMap['timing'],
          orElse: () => ActionTiming.optional,
        ),
        target: ActionTarget.values.firstWhere(
          (t) => t.name == cardMap['target'],
          orElse: () => ActionTarget.none,
        ),
        parameters: Map<String, dynamic>.from(cardMap['parameters'] as Map? ?? {}),
      );
    }).toList();

    // Parse other fields
    final turnDirection = TurnDirection.values.firstWhere(
      (dir) => dir.name == gameData['turnDirection'],
      orElse: () => TurnDirection.clockwise,
    );

    final drawnCardData = gameData['drawnCard'] as Map<String, dynamic>?;
    final drawnCard = drawnCardData != null ? Card(
      value: drawnCardData['value'] as int,
      isRevealed: drawnCardData['isRevealed'] as bool? ?? false,
    ) : null;

    final startedAtStr = gameData['startedAt'] as String?;
    final startedAt = startedAtStr != null ? DateTime.parse(startedAtStr) : null;

    return GameState(
      roomId: roomId,
      players: players,
      currentPlayerIndex: gameData['currentPlayerIndex'] as int,
      deck: deck,
      discardPile: discardPile,
      actionDeck: actionDeck,
      actionDiscard: actionDiscard,
      status: GameStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => GameStatus.waitingToStart,
      ),
      turnDirection: turnDirection,
      lastRound: gameData['lastRound'] as bool,
      initiatorPlayerId: gameData['initiatorPlayerId'] as String?,
      endRoundInitiator: gameData['endRoundInitiator'] as String?,
      drawnCard: drawnCard,
      createdAt: createdAt,
      startedAt: startedAt,
      finishedAt: endedAt,
    );
  }

  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'room_id': roomId,
      'status': status,
      'current_player_id': currentPlayerId,
      'turn_number': turnNumber,
      'round_number': roundNumber,
      'game_data': gameData,
      'winner_id': winnerId,
      'ended_at': endedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
