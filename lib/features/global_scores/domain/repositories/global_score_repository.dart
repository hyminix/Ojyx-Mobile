import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';

abstract class GlobalScoreRepository {
  /// Save a single score to the repository
  /// Returns the saved score with generated ID if successful
  Future<GlobalScore> saveScore(GlobalScore score);

  /// Save multiple scores in batch
  /// Returns the list of saved scores
  Future<List<GlobalScore>> saveBatchScores(List<GlobalScore> scores);

  /// Get all scores for a specific player
  /// Returns empty list if no scores found
  Future<List<GlobalScore>> getScoresByPlayer(String playerId);

  /// Get all scores for a specific room/game
  /// Returns empty list if no scores found
  Future<List<GlobalScore>> getScoresByRoom(String roomId);

  /// Get aggregated statistics for a player
  /// Returns null if player not found
  Future<PlayerStats?> getPlayerStats(String playerId);

  /// Get top players ranked by win rate
  /// [limit] specifies the maximum number of players to return
  Future<List<PlayerStats>> getTopPlayers({int limit = 10});

  /// Get recent games for a player
  /// [limit] specifies the maximum number of games to return
  /// Results are ordered by date (most recent first)
  Future<List<GlobalScore>> getRecentGames(String playerId, {int limit = 10});

  /// Delete a specific score by ID
  /// Returns true if successful, false if not found
  Future<bool> deleteScore(String scoreId);

  /// Delete all scores for a specific player
  /// Returns the number of deleted records
  Future<int> deletePlayerData(String playerId);
}
