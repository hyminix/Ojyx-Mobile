import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';

abstract class GlobalScoreRemoteDataSource {
  Future<GlobalScoreModel> saveScore(GlobalScoreModel score);
  Future<List<GlobalScoreModel>> saveBatchScores(List<GlobalScoreModel> scores);
  Future<List<GlobalScoreModel>> getScoresByPlayer(String playerId);
  Future<List<GlobalScoreModel>> getScoresByRoom(String roomId);
  Future<List<Map<String, dynamic>>> getTopPlayersRaw({int limit = 10});
  Future<List<GlobalScoreModel>> getRecentGames(
    String playerId, {
    int limit = 10,
  });
  Future<bool> deleteScore(String scoreId);
  Future<int> deletePlayerData(String playerId);
}
