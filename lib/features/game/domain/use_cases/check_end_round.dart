import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import '../entities/game_state.dart';
import '../entities/player.dart';

class CheckEndRoundParams {
  final GameState gameState;

  const CheckEndRoundParams({required this.gameState});
}

class CheckEndRound implements UseCase<GameState, CheckEndRoundParams> {
  @override
  Future<Either<Failure, GameState>> call(CheckEndRoundParams params) async {
    try {
      final gameState = params.gameState;

      // If not in last round, just continue playing
      if (gameState.status != GameStatus.lastRound) {
        return Right(gameState);
      }

      // Check if we're at the last player
      final isLastPlayer =
          gameState.currentPlayerIndex == gameState.players.length - 1;

      if (!isLastPlayer) {
        // Continue last round
        return Right(gameState);
      }

      // End of round - calculate final scores and apply penalty if needed
      var updatedPlayers = List<Player>.from(gameState.players);

      // Find the lowest score
      final scores = updatedPlayers.map((p) => p.currentScore).toList();
      final lowestScore = scores.reduce((a, b) => a < b ? a : b);

      // Check if initiator has the lowest score
      if (gameState.endRoundInitiator != null) {
        final initiatorIndex = updatedPlayers.indexWhere(
          (p) => p.id == gameState.endRoundInitiator,
        );

        if (initiatorIndex != -1) {
          final initiatorScore = updatedPlayers[initiatorIndex].currentScore;

          // Apply double penalty if initiator doesn't have the lowest score
          if (initiatorScore > lowestScore) {
            updatedPlayers[initiatorIndex] = updatedPlayers[initiatorIndex]
                .copyWith(scoreMultiplier: 2);
          }
        }
      }

      // Update game state to finished
      final newGameState = gameState.copyWith(
        players: updatedPlayers,
        status: GameStatus.finished,
        finishedAt: DateTime.now(),
      );

      return Right(newGameState);
    } catch (e) {
      return Left(
        Failure.unknown(message: 'Failed to check end round', error: e),
      );
    }
  }
}
