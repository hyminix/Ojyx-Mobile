import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/action_card.dart';
import '../entities/game_state.dart';
import '../entities/player.dart';
import '../entities/player_grid.dart';
import '../entities/card.dart' as game;
import '../repositories/action_card_repository.dart';

class UseActionCardParams {
  final String playerId;
  final ActionCard actionCard;
  final GameState gameState;
  final Map<String, dynamic>? targetData;
  
  UseActionCardParams({
    required this.playerId,
    required this.actionCard,
    required this.gameState,
    this.targetData,
  });
}

class UseActionCardUseCase extends UseCase<GameState, UseActionCardParams> {
  final ActionCardRepository _repository;
  
  UseActionCardUseCase(this._repository);
  
  @override
  Future<Either<Failure, GameState>> call(UseActionCardParams params) async {
    try {
      // Verify player has the action card
      final playerCards = _repository.getPlayerActionCards(params.playerId);
      if (!playerCards.contains(params.actionCard)) {
        return Left(Failure.gameLogic(
          message: 'Player does not have this action card',
          code: 'CARD_NOT_OWNED',
        ));
      }
      
      // Check if it's the player's turn (except for reaction cards)
      final currentPlayer = params.gameState.currentPlayer;
      if (currentPlayer.id != params.playerId && 
          params.actionCard.timing != ActionTiming.reactive) {
        return Left(Failure.gameLogic(
          message: 'It is not your turn',
          code: 'NOT_YOUR_TURN',
        ));
      }
      
      // Validate target data if required
      if (_requiresTargetData(params.actionCard) && params.targetData == null) {
        return Left(Failure.validation(
          message: 'This action card requires target data',
          errors: {'target': 'Target data is required'},
        ));
      }
      
      // Apply the action card effect
      final updatedGameState = _applyActionEffect(
        params.actionCard,
        params.gameState,
        params.playerId,
        params.targetData,
      );
      
      // Remove card from player and discard it
      _repository.removeActionCardFromPlayer(params.playerId, params.actionCard);
      _repository.discardActionCard(params.actionCard);
      
      return Right(updatedGameState);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to use action card',
        error: e,
      ));
    }
  }
  
  bool _requiresTargetData(ActionCard card) {
    switch (card.type) {
      case ActionCardType.teleport:
      case ActionCardType.swap:
      case ActionCardType.steal:
      case ActionCardType.peek:
      case ActionCardType.reveal:
      case ActionCardType.curse:
      case ActionCardType.gift:
        return true;
      default:
        return false;
    }
  }
  
  GameState _applyActionEffect(
    ActionCard card,
    GameState gameState,
    String playerId,
    Map<String, dynamic>? targetData,
  ) {
    switch (card.type) {
      case ActionCardType.turnAround:
        return gameState.copyWith(
          turnDirection: gameState.turnDirection == TurnDirection.clockwise
              ? TurnDirection.counterClockwise
              : TurnDirection.clockwise,
        );
        
      case ActionCardType.teleport:
        return _applyTeleportEffect(gameState, playerId, targetData!);
        
      case ActionCardType.skip:
        return _applySkipEffect(gameState);
        
      case ActionCardType.shield:
        // Shield effect would be handled when other players try to target this player
        return gameState;
        
      default:
        // For now, return unchanged state for unimplemented cards
        return gameState;
    }
  }
  
  GameState _applyTeleportEffect(
    GameState gameState,
    String playerId,
    Map<String, dynamic> targetData,
  ) {
    final position1 = targetData['position1'] as Map<String, dynamic>;
    final position2 = targetData['position2'] as Map<String, dynamic>;
    
    final row1 = position1['row'] as int;
    final col1 = position1['col'] as int;
    final row2 = position2['row'] as int;
    final col2 = position2['col'] as int;
    
    final playerIndex = gameState.players.indexWhere((p) => p.id == playerId);
    if (playerIndex == -1) return gameState;
    
    final player = gameState.players[playerIndex];
    final grid = player.grid;
    
    // Swap the cards
    final card1 = grid.getCard(row1, col1);
    final card2 = grid.getCard(row2, col2);
    
    if (card1 == null || card2 == null) return gameState;
    
    var updatedGrid = grid.setCard(row1, col1, card2);
    updatedGrid = updatedGrid.setCard(row2, col2, card1);
    
    final updatedPlayer = player.updateGrid(updatedGrid);
    final updatedPlayers = List<Player>.from(gameState.players);
    updatedPlayers[playerIndex] = updatedPlayer;
    
    return gameState.copyWith(players: updatedPlayers);
  }
  
  GameState _applySkipEffect(GameState gameState) {
    // Move to next player twice (skip one player)
    var nextIndex = gameState.currentPlayerIndex;
    for (int i = 0; i < 2; i++) {
      if (gameState.turnDirection == TurnDirection.clockwise) {
        nextIndex = (nextIndex + 1) % gameState.players.length;
      } else {
        nextIndex = (nextIndex - 1 + gameState.players.length) % gameState.players.length;
      }
    }
    
    return gameState.copyWith(currentPlayerIndex: nextIndex);
  }
}