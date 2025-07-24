import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';

class GetTopPlayersUseCase implements UseCase<List<PlayerStats>, GetTopPlayersParams> {
  final GlobalScoreRepository repository;

  GetTopPlayersUseCase(this.repository);

  @override
  Future<Either<Failure, List<PlayerStats>>> call(GetTopPlayersParams params) async {
    try {
      final topPlayers = await repository.getTopPlayers(limit: params.limit);
      return Right(topPlayers);
    } catch (e) {
      return Left(Failure.server(message: 'Failed to get top players: $e'));
    }
  }
}

class GetTopPlayersParams {
  final int limit;

  const GetTopPlayersParams({this.limit = 10});
}