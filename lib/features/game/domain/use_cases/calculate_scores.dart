import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import '../entities/game_state.dart';

class CalculateScoresParams {
  final GameState gameState;
  final bool onlyRevealed;
  final bool sorted;

  const CalculateScoresParams({
    required this.gameState,
    this.onlyRevealed = false,
    this.sorted = false,
  });
}

class CalculateScores
    implements UseCase<Map<String, int>, CalculateScoresParams> {
  @override
  Future<Either<Failure, Map<String, int>>> call(
    CalculateScoresParams params,
  ) async {
    try {
      final gameState = params.gameState;
      final scores = <String, int>{};

      // Calculate score for each player
      for (final player in gameState.players) {
        int score = 0;

        // Sum up card values
        for (final row in player.grid.cards) {
          for (final card in row) {
            if (card != null) {
              // Only count revealed cards if specified
              if (!params.onlyRevealed || card.isRevealed) {
                score += card.value;
              }
            }
          }
        }

        // Apply multiplier
        scores[player.id] = score * player.scoreMultiplier;
      }

      // Sort if requested
      if (params.sorted) {
        final sortedEntries = scores.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));

        final sortedScores = <String, int>{};
        for (final entry in sortedEntries) {
          sortedScores[entry.key] = entry.value;
        }

        return Right(sortedScores);
      }

      return Right(scores);
    } catch (e) {
      return Left(
        Failure.unknown(message: 'Failed to calculate scores', error: e),
      );
    }
  }
}
