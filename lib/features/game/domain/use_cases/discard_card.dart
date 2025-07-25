import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../entities/game_state.dart';
import '../entities/card.dart';
import '../entities/game_player.dart';
import '../entities/player_grid.dart';

class GridPosition {
  final int row;
  final int col;

  const GridPosition({required this.row, required this.col});
}

class DiscardCardParams {
  final GameState gameState;
  final String playerId;
  final GridPosition? gridPosition;

  const DiscardCardParams({
    required this.gameState,
    required this.playerId,
    this.gridPosition,
  });
}

class DiscardCard implements UseCase<GameState, DiscardCardParams> {
  @override
  Future<Either<Failure, GameState>> call(DiscardCardParams params) async {
    try {
      final gameState = params.gameState;
      final playerId = params.playerId;

      // Validate it's player's turn
      final currentPlayer = gameState.currentPlayer;
      if (currentPlayer.id != playerId) {
        return const Left(
          Failure.gameLogic(message: 'Not your turn', code: 'NOT_YOUR_TURN'),
        );
      }

      // Check if has drawn card
      if (gameState.drawnCard == null) {
        return const Left(
          Failure.gameLogic(
            message: 'No card to discard',
            code: 'NO_DRAWN_CARD',
          ),
        );
      }

      // Validate game status
      if (gameState.status != GameStatus.drawPhase) {
        return const Left(
          Failure.gameLogic(
            message: 'Must draw a card first',
            code: 'INVALID_STATUS',
          ),
        );
      }

      final drawnCard = gameState.drawnCard!;
      final discardPile = List<Card>.from(gameState.discardPile);
      final updatedPlayers = List<GamePlayer>.from(gameState.players);
      Card cardToDiscard = drawnCard;

      // If grid position provided, exchange with grid card
      if (params.gridPosition != null) {
        final position = params.gridPosition!;

        // Validate position
        if (position.row < 0 ||
            position.row >= kGridRows ||
            position.col < 0 ||
            position.col >= kGridColumns) {
          return const Left(
            Failure.gameLogic(
              message: 'Invalid grid position',
              code: 'INVALID_POSITION',
            ),
          );
        }

        // Get current player
        final playerIndex = gameState.players.indexWhere(
          (p) => p.id == playerId,
        );
        final player = updatedPlayers[playerIndex];

        // Check if position has a card
        final gridCard = player.grid.cards[position.row][position.col];
        if (gridCard == null) {
          return const Left(
            Failure.gameLogic(
              message: 'No card at specified position',
              code: 'EMPTY_POSITION',
            ),
          );
        }

        // Exchange cards
        var updatedGrid = player.grid.placeCard(
          drawnCard.reveal(),
          position.row,
          position.col,
        );

        // Check for column completion
        updatedGrid = _checkAndRevealCompletedColumn(updatedGrid, position.col);

        updatedPlayers[playerIndex] = player.copyWith(grid: updatedGrid);
        cardToDiscard = gridCard;
      }

      // Add card to discard pile
      discardPile.insert(0, cardToDiscard.reveal());

      // Advance to next player
      final nextPlayerIndex =
          (gameState.currentPlayerIndex + 1) % gameState.players.length;

      // Update game state
      final newGameState = gameState.copyWith(
        players: updatedPlayers,
        discardPile: discardPile,
        drawnCard: null,
        currentPlayerIndex: nextPlayerIndex,
        status: GameStatus.playing,
      );

      return Right(newGameState);
    } catch (e) {
      return Left(Failure.unknown(message: 'Failed to discard card', error: e));
    }
  }

  PlayerGrid _checkAndRevealCompletedColumn(PlayerGrid grid, int col) {
    // Check if all 3 cards in the column are the same value
    final cards = [grid.cards[0][col], grid.cards[1][col], grid.cards[2][col]];

    // All must be non-null and have same value
    if (cards.every((card) => card != null) &&
        cards[0]!.value == cards[1]!.value &&
        cards[1]!.value == cards[2]!.value) {
      // Reveal all cards in the column
      var updatedGrid = grid;
      for (int row = 0; row < kGridRows; row++) {
        updatedGrid = updatedGrid.revealCard(row, col);
      }
      return updatedGrid;
    }

    return grid;
  }
}
