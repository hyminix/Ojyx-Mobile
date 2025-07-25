import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';

class SaveGlobalScoreUseCase
    implements UseCase<List<GlobalScore>, SaveGlobalScoreParams> {
  final GlobalScoreRepository repository;

  SaveGlobalScoreUseCase(this.repository);

  @override
  Future<Either<Failure, List<GlobalScore>>> call(
    SaveGlobalScoreParams params,
  ) async {
    try {
      final gameEndedAt = DateTime.now();

      // Sort players by score (ascending - lowest score first)
      final sortedPlayers = List<GamePlayer>.from(params.gameState.players)
        ..sort((a, b) => a.currentScore.compareTo(b.currentScore));

      // Check if round initiator needs penalty
      final lowestScore = sortedPlayers.first.currentScore;
      final roundInitiatorId = params.gameState.initiatorPlayerId;

      // Create scores with positions
      final scores = <GlobalScore>[];
      for (int i = 0; i < sortedPlayers.length; i++) {
        final player = sortedPlayers[i];
        var totalScore = player.currentScore;

        // Apply penalty if player initiated round but didn't win
        if (player.id == roundInitiatorId &&
            player.currentScore > lowestScore) {
          totalScore = player.currentScore * 2;
        }

        scores.add(
          GlobalScore(
            id: '',
            playerId: player.id,
            playerName: player.name,
            roomId: params.gameState.roomId,
            totalScore: totalScore,
            roundNumber:
                params.roundNumber ??
                1, // Round number should be passed as parameter
            position: i + 1,
            isWinner: i == 0, // First position is winner
            createdAt: params.gameState.createdAt ?? DateTime.now(),
            gameEndedAt: gameEndedAt,
          ),
        );
      }

      // Save all scores in batch
      final savedScores = await repository.saveBatchScores(scores);
      return Right(savedScores);
    } catch (e) {
      return Left(Failure.server(message: 'Failed to save scores: $e'));
    }
  }
}

class SaveGlobalScoreParams {
  final GameState gameState;
  final int? roundNumber;

  SaveGlobalScoreParams({required this.gameState, this.roundNumber});
}
