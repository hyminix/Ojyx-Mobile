import 'optimistic_action.dart';
import 'game_state.dart';
import 'card.dart';
import 'action_card.dart';
import 'card_position.dart';

/// Action pour révéler une carte
class RevealCardAction extends OptimisticAction {
  final int row;
  final int col;
  final Card? expectedCard; // La carte attendue (si connue)
  
  RevealCardAction({
    required String playerId,
    required this.row,
    required this.col,
    this.expectedCard,
    String? id,
    DateTime? timestamp,
    int retryCount = 0,
  }) : super(
    id: id,
    timestamp: timestamp,
    type: 'reveal_card',
    playerId: playerId,
    retryCount: retryCount,
  );
  
  @override
  GameState apply(GameState currentState) {
    return currentState.copyWith(
      players: currentState.players.map((player) {
        if (player.id == playerId) {
          final newCards = List<Card>.from(player.grid.cards);
          newCards[row * 4 + col] = newCards[row * 4 + col].copyWith(
            isRevealed: true,
          );
          final newGrid = player.grid.copyWith(cards: newCards);
          return player.copyWith(grid: newGrid);
        }
        return player;
      }).toList(),
      lastAction: 'reveal_card',
      lastActionTimestamp: timestamp,
    );
  }
  
  @override
  bool canApply(GameState currentState) {
    // Vérifier que c'est le tour du joueur
    if (currentState.currentPlayer.id != playerId) return false;
    
    // Vérifier que la position est valide
    if (row < 0 || row >= 3 || col < 0 || col >= 4) return false;
    
    // Vérifier que la carte n'est pas déjà révélée
    final player = currentState.players.firstWhere((p) => p.id == playerId);
    final cardIndex = row * 4 + col;
    if (player.grid.cards[cardIndex].isRevealed) return false;
    
    return true;
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'playerId': playerId,
    'row': row,
    'col': col,
    'timestamp': timestamp.toIso8601String(),
    if (expectedCard != null) 'expectedCard': expectedCard!.toJson(),
  };
  
  @override
  OptimisticAction withRetry() => RevealCardAction(
    id: id,
    timestamp: timestamp,
    playerId: playerId,
    row: row,
    col: col,
    expectedCard: expectedCard,
    retryCount: retryCount + 1,
  );
  
  @override
  int get priority => 3; // Priorité moyenne
}

/// Action pour jouer une carte action
class PlayActionCardAction extends OptimisticAction {
  final ActionCard actionCard;
  final Map<String, dynamic> actionData;
  final String? targetPlayerId;
  
  PlayActionCardAction({
    required String playerId,
    required this.actionCard,
    required this.actionData,
    this.targetPlayerId,
    String? id,
    DateTime? timestamp,
    int retryCount = 0,
  }) : super(
    id: id,
    timestamp: timestamp,
    type: 'play_action_card',
    playerId: playerId,
    retryCount: retryCount,
  );
  
  @override
  GameState apply(GameState currentState) {
    // Appliquer l'effet de la carte action selon son type
    GameState newState = currentState;
    
    switch (actionCard.type) {
      case ActionCardType.swap:
        // Échanger deux cartes
        final source = CardPosition.fromJson(actionData['source']);
        final target = CardPosition.fromJson(actionData['target']);
        newState = _applySwap(newState, source, target);
        break;
        
      case ActionCardType.peek:
        // Regarder une carte (pas de changement d'état visible)
        break;
        
      case ActionCardType.reveal:
        // Révéler une carte d'un adversaire
        if (targetPlayerId != null && actionData['position'] != null) {
          final pos = CardPosition.fromJson(actionData['position']);
          newState = _applyRevealOpponent(newState, targetPlayerId!, pos);
        }
        break;
        
      case ActionCardType.turnDirection:
        // Inverser le sens du jeu
        newState = newState.copyWith(
          turnDirection: newState.turnDirection == TurnDirection.clockwise
              ? TurnDirection.counterClockwise
              : TurnDirection.clockwise,
        );
        break;
        
      default:
        break;
    }
    
    // Retirer la carte action du stock du joueur
    return newState.copyWith(
      players: newState.players.map((player) {
        if (player.id == playerId) {
          return player.copyWith(
            actionCards: player.actionCards.where((c) => c.id != actionCard.id).toList(),
          );
        }
        return player;
      }).toList(),
      lastAction: 'play_action_card',
      lastActionTimestamp: timestamp,
    );
  }
  
  GameState _applySwap(GameState state, CardPosition source, CardPosition target) {
    return state.copyWith(
      players: state.players.map((player) {
        if (player.id == source.playerId) {
          final newCards = List<Card>.from(player.grid.cards);
          if (player.id == target.playerId) {
            // Swap dans la même grille
            final temp = newCards[source.index];
            newCards[source.index] = newCards[target.index];
            newCards[target.index] = temp;
          } else {
            // Swap entre deux joueurs
            final targetPlayer = state.players.firstWhere((p) => p.id == target.playerId);
            newCards[source.index] = targetPlayer.grid.cards[target.index];
          }
          return player.copyWith(
            grid: player.grid.copyWith(cards: newCards),
          );
        } else if (player.id == target.playerId && source.playerId != target.playerId) {
          // Deuxième partie du swap entre joueurs
          final sourcePlayer = state.players.firstWhere((p) => p.id == source.playerId);
          final newCards = List<Card>.from(player.grid.cards);
          newCards[target.index] = sourcePlayer.grid.cards[source.index];
          return player.copyWith(
            grid: player.grid.copyWith(cards: newCards),
          );
        }
        return player;
      }).toList(),
    );
  }
  
  GameState _applyRevealOpponent(GameState state, String targetPlayerId, CardPosition position) {
    return state.copyWith(
      players: state.players.map((player) {
        if (player.id == targetPlayerId) {
          final newCards = List<Card>.from(player.grid.cards);
          newCards[position.index] = newCards[position.index].copyWith(isRevealed: true);
          return player.copyWith(
            grid: player.grid.copyWith(cards: newCards),
          );
        }
        return player;
      }).toList(),
    );
  }
  
  @override
  bool canApply(GameState currentState) {
    // Vérifier que c'est le tour du joueur
    if (currentState.currentPlayer.id != playerId) return false;
    
    // Vérifier que le joueur possède la carte action
    final player = currentState.players.firstWhere((p) => p.id == playerId);
    if (!player.actionCards.any((c) => c.id == actionCard.id)) return false;
    
    return true;
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'playerId': playerId,
    'actionCard': actionCard.toJson(),
    'actionData': actionData,
    'targetPlayerId': targetPlayerId,
    'timestamp': timestamp.toIso8601String(),
  };
  
  @override
  OptimisticAction withRetry() => PlayActionCardAction(
    id: id,
    timestamp: timestamp,
    playerId: playerId,
    actionCard: actionCard,
    actionData: actionData,
    targetPlayerId: targetPlayerId,
    retryCount: retryCount + 1,
  );
  
  @override
  int get priority => 2; // Priorité élevée
}

/// Action pour terminer son tour
class EndTurnAction extends OptimisticAction {
  final bool hasDrawnCard;
  
  EndTurnAction({
    required String playerId,
    required this.hasDrawnCard,
    String? id,
    DateTime? timestamp,
    int retryCount = 0,
  }) : super(
    id: id,
    timestamp: timestamp,
    type: 'end_turn',
    playerId: playerId,
    retryCount: retryCount,
  );
  
  @override
  GameState apply(GameState currentState) {
    final nextPlayerIndex = currentState.getNextPlayerIndex();
    
    return currentState.copyWith(
      currentPlayerIndex: nextPlayerIndex,
      turnNumber: currentState.turnNumber + 1,
      lastAction: 'end_turn',
      lastActionTimestamp: timestamp,
    );
  }
  
  @override
  bool canApply(GameState currentState) {
    // Vérifier que c'est le tour du joueur
    if (currentState.currentPlayer.id != playerId) return false;
    
    // Vérifier que le joueur a pioché une carte (si en phase de pioche)
    if (currentState.status == GameStatus.drawPhase && !hasDrawnCard) return false;
    
    return true;
  }
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'playerId': playerId,
    'hasDrawnCard': hasDrawnCard,
    'timestamp': timestamp.toIso8601String(),
  };
  
  @override
  OptimisticAction withRetry() => EndTurnAction(
    id: id,
    timestamp: timestamp,
    playerId: playerId,
    hasDrawnCard: hasDrawnCard,
    retryCount: retryCount + 1,
  );
  
  @override
  int get priority => 1; // Priorité très élevée
}