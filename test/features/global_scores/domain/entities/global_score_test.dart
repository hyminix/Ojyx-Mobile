import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';

void main() {
  group('GlobalScore', () {
    test('should create GlobalScore with correct properties', () {
      final globalScore = GlobalScore(
        id: 'score123',
        playerId: 'player1',
        playerName: 'Alice',
        roomId: 'room456',
        totalScore: 125,
        roundNumber: 5,
        position: 2,
        isWinner: false,
        createdAt: DateTime(2025, 1, 24, 10, 30),
        gameEndedAt: DateTime(2025, 1, 24, 11, 45),
      );

      expect(globalScore.id, equals('score123'));
      expect(globalScore.playerId, equals('player1'));
      expect(globalScore.playerName, equals('Alice'));
      expect(globalScore.roomId, equals('room456'));
      expect(globalScore.totalScore, equals(125));
      expect(globalScore.roundNumber, equals(5));
      expect(globalScore.position, equals(2));
      expect(globalScore.isWinner, isFalse);
      expect(globalScore.createdAt, equals(DateTime(2025, 1, 24, 10, 30)));
      expect(globalScore.gameEndedAt, equals(DateTime(2025, 1, 24, 11, 45)));
    });

    test('should calculate game duration correctly', () {
      final globalScore = GlobalScore(
        id: 'score123',
        playerId: 'player1',
        playerName: 'Alice',
        roomId: 'room456',
        totalScore: 125,
        roundNumber: 5,
        position: 2,
        isWinner: false,
        createdAt: DateTime(2025, 1, 24, 10, 30),
        gameEndedAt: DateTime(2025, 1, 24, 11, 45),
      );

      expect(globalScore.gameDuration, equals(const Duration(hours: 1, minutes: 15)));
    });

    test('should support null gameEndedAt for ongoing games', () {
      final globalScore = GlobalScore(
        id: 'score123',
        playerId: 'player1',
        playerName: 'Alice',
        roomId: 'room456',
        totalScore: 125,
        roundNumber: 5,
        position: 2,
        isWinner: false,
        createdAt: DateTime(2025, 1, 24, 10, 30),
        gameEndedAt: null,
      );

      expect(globalScore.gameEndedAt, isNull);
      expect(globalScore.gameDuration, isNull);
    });

    test('should be immutable with Freezed', () {
      final globalScore = GlobalScore(
        id: 'score123',
        playerId: 'player1',
        playerName: 'Alice',
        roomId: 'room456',
        totalScore: 125,
        roundNumber: 5,
        position: 2,
        isWinner: false,
        createdAt: DateTime(2025, 1, 24, 10, 30),
      );

      final updatedScore = globalScore.copyWith(totalScore: 150);

      expect(globalScore.totalScore, equals(125));
      expect(updatedScore.totalScore, equals(150));
      expect(identical(globalScore, updatedScore), isFalse);
    });

    test('should support json serialization', () {
      final globalScore = GlobalScore(
        id: 'score123',
        playerId: 'player1',
        playerName: 'Alice',
        roomId: 'room456',
        totalScore: 125,
        roundNumber: 5,
        position: 2,
        isWinner: false,
        createdAt: DateTime(2025, 1, 24, 10, 30),
        gameEndedAt: DateTime(2025, 1, 24, 11, 45),
      );

      final json = globalScore.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], equals('score123'));
      expect(json['player_id'], equals('player1'));
      expect(json['player_name'], equals('Alice'));
      expect(json['room_id'], equals('room456'));
      expect(json['total_score'], equals(125));
      expect(json['round_number'], equals(5));
      expect(json['position'], equals(2));
      expect(json['is_winner'], equals(false));

      final fromJson = GlobalScore.fromJson(json);
      expect(fromJson.id, equals(globalScore.id));
      expect(fromJson.playerId, equals(globalScore.playerId));
      expect(fromJson.totalScore, equals(globalScore.totalScore));
    });
  });

  group('PlayerStats', () {
    test('should create PlayerStats from list of GlobalScores', () {
      final scores = [
        GlobalScore(
          id: '1',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room1',
          totalScore: 100,
          roundNumber: 3,
          position: 1,
          isWinner: true,
          createdAt: DateTime(2025, 1, 20),
        ),
        GlobalScore(
          id: '2',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room2',
          totalScore: 150,
          roundNumber: 4,
          position: 2,
          isWinner: false,
          createdAt: DateTime(2025, 1, 21),
        ),
        GlobalScore(
          id: '3',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room3',
          totalScore: 80,
          roundNumber: 2,
          position: 1,
          isWinner: true,
          createdAt: DateTime(2025, 1, 22),
        ),
      ];

      final stats = PlayerStats.fromScores(scores);

      expect(stats.playerId, equals('player1'));
      expect(stats.playerName, equals('Alice'));
      expect(stats.totalGamesPlayed, equals(3));
      expect(stats.totalWins, equals(2));
      expect(stats.averageScore, equals(110)); // (100 + 150 + 80) / 3
      expect(stats.bestScore, equals(80));
      expect(stats.worstScore, equals(150));
      expect(stats.averagePosition, equals(4/3)); // (1 + 2 + 1) / 3
      expect(stats.totalRoundsPlayed, equals(9)); // 3 + 4 + 2
    });

    test('should calculate win rate correctly', () {
      final scores = [
        GlobalScore(
          id: '1',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room1',
          totalScore: 100,
          roundNumber: 3,
          position: 1,
          isWinner: true,
          createdAt: DateTime(2025, 1, 20),
        ),
        GlobalScore(
          id: '2',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room2',
          totalScore: 150,
          roundNumber: 4,
          position: 2,
          isWinner: false,
          createdAt: DateTime(2025, 1, 21),
        ),
      ];

      final stats = PlayerStats.fromScores(scores);
      expect(stats.winRate, equals(0.5)); // 1 win out of 2 games
    });

    test('should handle empty scores list', () {
      final stats = PlayerStats.fromScores([]);

      expect(stats.playerId, equals(''));
      expect(stats.playerName, equals(''));
      expect(stats.totalGamesPlayed, equals(0));
      expect(stats.totalWins, equals(0));
      expect(stats.averageScore, equals(0));
      expect(stats.bestScore, equals(0));
      expect(stats.worstScore, equals(0));
      expect(stats.averagePosition, equals(0));
      expect(stats.totalRoundsPlayed, equals(0));
      expect(stats.winRate, equals(0));
    });

    test('should support json serialization', () {
      final stats = PlayerStats(
        playerId: 'player1',
        playerName: 'Alice',
        totalGamesPlayed: 10,
        totalWins: 4,
        averageScore: 95.5,
        bestScore: 60,
        worstScore: 180,
        averagePosition: 2.3,
        totalRoundsPlayed: 45,
      );

      final json = stats.toJson();
      expect(json['player_id'], equals('player1'));
      expect(json['player_name'], equals('Alice'));
      expect(json['total_games_played'], equals(10));
      expect(json['total_wins'], equals(4));
      expect(json['average_score'], equals(95.5));
      expect(json['best_score'], equals(60));
      expect(json['worst_score'], equals(180));
      expect(json['average_position'], equals(2.3));
      expect(json['total_rounds_played'], equals(45));

      final fromJson = PlayerStats.fromJson(json);
      expect(fromJson.playerId, equals(stats.playerId));
      expect(fromJson.totalGamesPlayed, equals(stats.totalGamesPlayed));
      expect(fromJson.winRate, equals(0.4));
    });
  });
}