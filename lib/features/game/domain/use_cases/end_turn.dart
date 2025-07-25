import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../entities/game_state.dart';
import '../entities/game_player.dart';
import '../entities/player_grid.dart';
import '../entities/card.dart';

class EndTurnParams {
  final GameState gameState;
  final String playerId;

  const EndTurnParams({required this.gameState, required this.playerId});
}

class EndTurn implements UseCase<GameState, EndTurnParams> {
  @override
  Future<Either<Failure, GameState>> call(EndTurnParams params) async {
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

      // Process end of turn validations
      final updatedPlayers = List<GamePlayer>.from(gameState.players);
      final discardPile = List<Card>.from(gameState.discardPile);

      // Get current player index
      final playerIndex = gameState.players.indexWhere((p) => p.id == playerId);
      var player = updatedPlayers[playerIndex];

      // Check and clear completed columns
      final (updatedGrid, clearedCards) = _validateAndClearColumns(player.grid);

      // Add cleared cards to discard pile
      discardPile.insertAll(0, clearedCards);

      // Update player with new grid
      player = player.copyWith(grid: updatedGrid);
      updatedPlayers[playerIndex] = player;

      // Check if player has revealed all cards
      final allRevealed = _checkAllCardsRevealed(updatedGrid);

      GameStatus newStatus = gameState.status;
      String? endRoundInitiator = gameState.endRoundInitiator;

      if (allRevealed && gameState.status != GameStatus.lastRound) {
        // Trigger last round
        newStatus = GameStatus.lastRound;
        endRoundInitiator = playerId;
      }

      // Update game state
      final newGameState = gameState.copyWith(
        players: updatedPlayers,
        discardPile: discardPile,
        status: newStatus,
        endRoundInitiator: endRoundInitiator,
      );

      return Right(newGameState);
    } catch (e) {
      return Left(Failure.unknown(message: 'Failed to end turn', error: e));
    }
  }

  (PlayerGrid, List<Card>) _validateAndClearColumns(PlayerGrid grid) {
    var updatedGrid = grid;
    final clearedCards = <Card>[];

    // Check each column
    for (int col = 0; col < kGridColumns; col++) {
      final columnCards = [
        grid.cards[0][col],
        grid.cards[1][col],
        grid.cards[2][col],
      ];

      // Check if all cards exist, are revealed, and have same value
      if (columnCards.every((card) => card != null && card.isRevealed) &&
          columnCards[0]!.value == columnCards[1]!.value &&
          columnCards[1]!.value == columnCards[2]!.value) {
        // Clear the column
        for (int row = 0; row < kGridRows; row++) {
          clearedCards.add(grid.cards[row][col]!);
          updatedGrid = updatedGrid.clearPosition(row, col);
        }
      }
    }

    return (updatedGrid, clearedCards);
  }

  bool _checkAllCardsRevealed(PlayerGrid grid) {
    int revealedCount = 0;
    int totalCards = 0;

    for (final row in grid.cards) {
      for (final card in row) {
        if (card != null) {
          totalCards++;
          if (card.isRevealed) {
            revealedCount++;
          }
        }
      }
    }

    return totalCards > 0 && revealedCount == totalCards;
  }
}
