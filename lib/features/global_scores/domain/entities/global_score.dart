import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_score.freezed.dart';
part 'global_score.g.dart';

@freezed
class GlobalScore with _$GlobalScore {
  const GlobalScore._();

  const factory GlobalScore({
    required String id,
    required String playerId,
    required String playerName,
    required String roomId,
    required int totalScore,
    required int roundNumber,
    required int position,
    required bool isWinner,
    required DateTime createdAt,
    DateTime? gameEndedAt,
  }) = _GlobalScore;

  factory GlobalScore.fromJson(Map<String, dynamic> json) =>
      _$GlobalScoreFromJson(json);

  /// Calculate game duration if the game has ended
  Duration? get gameDuration {
    if (gameEndedAt == null) return null;
    return gameEndedAt!.difference(createdAt);
  }
}

@freezed
class PlayerStats with _$PlayerStats {
  const PlayerStats._();

  const factory PlayerStats({
    required String playerId,
    required String playerName,
    required int totalGamesPlayed,
    required int totalWins,
    required double averageScore,
    required int bestScore,
    required int worstScore,
    required double averagePosition,
    required int totalRoundsPlayed,
  }) = _PlayerStats;

  factory PlayerStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsFromJson(json);

  /// Create PlayerStats from a list of GlobalScores for a specific player
  factory PlayerStats.fromScores(List<GlobalScore> scores) {
    if (scores.isEmpty) {
      return const PlayerStats(
        playerId: '',
        playerName: '',
        totalGamesPlayed: 0,
        totalWins: 0,
        averageScore: 0,
        bestScore: 0,
        worstScore: 0,
        averagePosition: 0,
        totalRoundsPlayed: 0,
      );
    }

    final totalGames = scores.length;
    final totalWins = scores.where((s) => s.isWinner).length;
    final totalScore = scores.fold<int>(0, (sum, s) => sum + s.totalScore);
    final totalPositions = scores.fold<int>(0, (sum, s) => sum + s.position);
    final totalRounds = scores.fold<int>(0, (sum, s) => sum + s.roundNumber);

    final scoreValues = scores.map((s) => s.totalScore).toList()..sort();

    return PlayerStats(
      playerId: scores.first.playerId,
      playerName: scores.first.playerName,
      totalGamesPlayed: totalGames,
      totalWins: totalWins,
      averageScore: totalScore / totalGames,
      bestScore: scoreValues.first,
      worstScore: scoreValues.last,
      averagePosition: totalPositions / totalGames,
      totalRoundsPlayed: totalRounds,
    );
  }

  /// Calculate win rate as a percentage (0.0 to 1.0)
  double get winRate {
    if (totalGamesPlayed == 0) return 0;
    return totalWins / totalGamesPlayed;
  }
}
