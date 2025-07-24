import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';

class GetPlayerStatsUseCase implements UseCase<PlayerStats?, GetPlayerStatsParams> {
  final GlobalScoreRepository repository;

  GetPlayerStatsUseCase(this.repository);

  @override
  Future<Either<Failure, PlayerStats?>> call(GetPlayerStatsParams params) async {
    try {
      final stats = await repository.getPlayerStats(params.playerId);
      return Right(stats);
    } catch (e) {
      return Left(Failure.server(message: 'Failed to get player stats: $e'));
    }
  }
}

class GetPlayerStatsParams {
  final String playerId;

  const GetPlayerStatsParams({required this.playerId});
}