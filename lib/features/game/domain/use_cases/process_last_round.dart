import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../entities/game_state.dart';
import '../entities/game_player.dart';

class ProcessLastRoundParams {
  final GameState gameState;

  const ProcessLastRoundParams({required this.gameState});
}

class ProcessLastRound implements UseCase<GameState, ProcessLastRoundParams> {
  @override
  Future<Either<Failure, GameState>> call(ProcessLastRoundParams params) async {
    try {
      final gameState = params.gameState;

      // Only process if in last round
      if (gameState.status != GameStatus.lastRound) {
        return Right(gameState);
      }

      var updatedPlayers = List<GamePlayer>.from(gameState.players);

      // Reveal all cards for all players except the initiator
      for (int i = 0; i < updatedPlayers.length; i++) {
        final player = updatedPlayers[i];

        // Skip the initiator
        if (player.id == gameState.endRoundInitiator) {
          continue;
        }

        // Reveal all cards in the grid
        var updatedGrid = player.grid;
        for (int row = 0; row < kGridRows; row++) {
          for (int col = 0; col < kGridColumns; col++) {
            if (updatedGrid.cards[row][col] != null) {
              updatedGrid = updatedGrid.revealCard(row, col);
            }
          }
        }

        updatedPlayers[i] = player.copyWith(grid: updatedGrid);
      }

      // Update game state with revealed cards
      final newGameState = gameState.copyWith(players: updatedPlayers);

      return Right(newGameState);
    } catch (e) {
      return Left(
        Failure.unknown(message: 'Failed to process last round', error: e),
      );
    }
  }
}
