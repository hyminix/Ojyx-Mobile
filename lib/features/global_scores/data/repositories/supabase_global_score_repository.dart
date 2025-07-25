import 'package:ojyx/features/global_scores/data/datasources/global_score_remote_datasource.dart';
import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';

class SupabaseGlobalScoreRepository implements GlobalScoreRepository {
  final GlobalScoreRemoteDataSource _dataSource;

  SupabaseGlobalScoreRepository(this._dataSource);

  @override
  Future<GlobalScore> saveScore(GlobalScore score) async {
    try {
      final model = GlobalScoreModel.fromDomain(score);
      final savedModel = await _dataSource.saveScore(model);
      return savedModel.toDomain();
    } catch (e) {
      throw Exception('Failed to save score: $e');
    }
  }

  @override
  Future<List<GlobalScore>> saveBatchScores(List<GlobalScore> scores) async {
    if (scores.isEmpty) return [];

    try {
      final models = scores.map((s) => GlobalScoreModel.fromDomain(s)).toList();
      final savedModels = await _dataSource.saveBatchScores(models);
      return savedModels.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to save batch scores: $e');
    }
  }

  @override
  Future<List<GlobalScore>> getScoresByPlayer(String playerId) async {
    try {
      final models = await _dataSource.getScoresByPlayer(playerId);
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get scores by player: $e');
    }
  }

  @override
  Future<List<GlobalScore>> getScoresByRoom(String roomId) async {
    try {
      final models = await _dataSource.getScoresByRoom(roomId);
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get scores by room: $e');
    }
  }

  @override
  Future<PlayerStats?> getPlayerStats(String playerId) async {
    try {
      final scores = await getScoresByPlayer(playerId);
      if (scores.isEmpty) return null;

      return PlayerStats.fromScores(scores);
    } catch (e) {
      throw Exception('Failed to get player stats: $e');
    }
  }

  @override
  Future<List<PlayerStats>> getTopPlayers({int limit = 10}) async {
    try {
      final response = await _dataSource.getTopPlayersRaw(limit: limit);

      return response
          .map(
            (data) => PlayerStats(
              playerId: data['player_id'],
              playerName: data['player_name'],
              totalGamesPlayed: data['total_games'],
              totalWins: data['total_wins'],
              averageScore: data['average_score'].toDouble(),
              bestScore: data['best_score'],
              worstScore: data['worst_score'],
              averagePosition: data['average_position'].toDouble(),
              totalRoundsPlayed: data['total_rounds'],
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get top players: $e');
    }
  }

  @override
  Future<List<GlobalScore>> getRecentGames(
    String playerId, {
    int limit = 10,
  }) async {
    try {
      final models = await _dataSource.getRecentGames(playerId, limit: limit);
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get recent games: $e');
    }
  }

  @override
  Future<bool> deleteScore(String scoreId) async {
    try {
      return await _dataSource.deleteScore(scoreId);
    } catch (e) {
      throw Exception('Failed to delete score: $e');
    }
  }

  @override
  Future<int> deletePlayerData(String playerId) async {
    try {
      return await _dataSource.deletePlayerData(playerId);
    } catch (e) {
      throw Exception('Failed to delete player data: $e');
    }
  }
}
