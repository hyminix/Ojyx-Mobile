import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}

class FakeGlobalScore extends Fake implements GlobalScore {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGlobalScore());
  });

  group('GlobalScoreRepository', () {
    late GlobalScoreRepository repository;
    late GlobalScore testScore;
    late List<GlobalScore> testScores;

    setUp(() {
      repository = MockGlobalScoreRepository();

      testScore = GlobalScore(
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

      testScores = [
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
          playerId: 'player2',
          playerName: 'Bob',
          roomId: 'room1',
          totalScore: 120,
          roundNumber: 3,
          position: 2,
          isWinner: false,
          createdAt: DateTime(2025, 1, 20),
        ),
      ];
    });

    group('saveScore', () {
      test('should save a new score and return it with generated id', () async {
        final scoreToSave = GlobalScore(
          id: '',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room456',
          totalScore: 125,
          roundNumber: 5,
          position: 2,
          isWinner: false,
          createdAt: DateTime.now(),
          gameEndedAt: DateTime.now(),
        );

        when(
          () => repository.saveScore(scoreToSave),
        ).thenAnswer((_) async => scoreToSave.copyWith(id: 'generated123'));

        final result = await repository.saveScore(scoreToSave);

        expect(result.id, equals('generated123'));
        expect(result.playerId, equals(scoreToSave.playerId));
        expect(result.totalScore, equals(scoreToSave.totalScore));
        verify(() => repository.saveScore(scoreToSave)).called(1);
      });

      test('should throw exception when save fails', () async {
        when(
          () => repository.saveScore(any()),
        ).thenThrow(Exception('Failed to save score'));

        expect(() => repository.saveScore(testScore), throwsException);
      });
    });

    group('saveBatchScores', () {
      test('should save multiple scores in batch', () async {
        when(
          () => repository.saveBatchScores(testScores),
        ).thenAnswer((_) async => testScores);

        final result = await repository.saveBatchScores(testScores);

        expect(result.length, equals(3));
        expect(result, equals(testScores));
        verify(() => repository.saveBatchScores(testScores)).called(1);
      });

      test('should handle empty list', () async {
        when(() => repository.saveBatchScores([])).thenAnswer((_) async => []);

        final result = await repository.saveBatchScores([]);

        expect(result, isEmpty);
      });
    });

    group('getScoresByPlayer', () {
      test('should return all scores for a specific player', () async {
        final playerScores = testScores
            .where((s) => s.playerId == 'player1')
            .toList();

        when(
          () => repository.getScoresByPlayer('player1'),
        ).thenAnswer((_) async => playerScores);

        final result = await repository.getScoresByPlayer('player1');

        expect(result.length, equals(2));
        expect(result.every((s) => s.playerId == 'player1'), isTrue);
        verify(() => repository.getScoresByPlayer('player1')).called(1);
      });

      test('should return empty list when player has no scores', () async {
        when(
          () => repository.getScoresByPlayer('unknown'),
        ).thenAnswer((_) async => []);

        final result = await repository.getScoresByPlayer('unknown');

        expect(result, isEmpty);
      });
    });

    group('getScoresByRoom', () {
      test('should return all scores for a specific room', () async {
        final roomScores = testScores
            .where((s) => s.roomId == 'room1')
            .toList();

        when(
          () => repository.getScoresByRoom('room1'),
        ).thenAnswer((_) async => roomScores);

        final result = await repository.getScoresByRoom('room1');

        expect(result.length, equals(2));
        expect(result.every((s) => s.roomId == 'room1'), isTrue);
        verify(() => repository.getScoresByRoom('room1')).called(1);
      });
    });

    group('getPlayerStats', () {
      test('should return calculated stats for a player', () async {
        final playerScores = testScores
            .where((s) => s.playerId == 'player1')
            .toList();
        final expectedStats = PlayerStats.fromScores(playerScores);

        when(
          () => repository.getPlayerStats('player1'),
        ).thenAnswer((_) async => expectedStats);

        final result = await repository.getPlayerStats('player1');

        expect(result, isNotNull);
        expect(result!.playerId, equals('player1'));
        expect(result.totalGamesPlayed, equals(2));
        expect(result.totalWins, equals(1));
        verify(() => repository.getPlayerStats('player1')).called(1);
      });

      test('should return null when player not found', () async {
        when(
          () => repository.getPlayerStats('unknown'),
        ).thenAnswer((_) async => null);

        final result = await repository.getPlayerStats('unknown');

        expect(result, isNull);
      });
    });

    group('getTopPlayers', () {
      test('should return top players by win rate', () async {
        final topPlayers = [
          const PlayerStats(
            playerId: 'player1',
            playerName: 'Alice',
            totalGamesPlayed: 10,
            totalWins: 8,
            averageScore: 95,
            bestScore: 60,
            worstScore: 150,
            averagePosition: 1.5,
            totalRoundsPlayed: 45,
          ),
          const PlayerStats(
            playerId: 'player2',
            playerName: 'Bob',
            totalGamesPlayed: 15,
            totalWins: 10,
            averageScore: 105,
            bestScore: 70,
            worstScore: 180,
            averagePosition: 2.2,
            totalRoundsPlayed: 60,
          ),
        ];

        when(
          () => repository.getTopPlayers(limit: 10),
        ).thenAnswer((_) async => topPlayers);

        final result = await repository.getTopPlayers(limit: 10);

        expect(result.length, equals(2));
        expect(result.first.winRate, greaterThanOrEqualTo(result.last.winRate));
        verify(() => repository.getTopPlayers(limit: 10)).called(1);
      });

      test('should respect limit parameter', () async {
        final topPlayers = List.generate(
          5,
          (i) => PlayerStats(
            playerId: 'player$i',
            playerName: 'GamePlayer $i',
            totalGamesPlayed: 10,
            totalWins: 10 - i,
            averageScore: 100 + i * 10,
            bestScore: 60 + i * 5,
            worstScore: 150 + i * 10,
            averagePosition: 1 + i * 0.5,
            totalRoundsPlayed: 40 + i * 5,
          ),
        );

        when(
          () => repository.getTopPlayers(limit: 3),
        ).thenAnswer((_) async => topPlayers.take(3).toList());

        final result = await repository.getTopPlayers(limit: 3);

        expect(result.length, equals(3));
      });
    });

    group('getRecentGames', () {
      test('should return recent games for a player', () async {
        final recentGames =
            testScores.where((s) => s.playerId == 'player1').toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        when(
          () => repository.getRecentGames('player1', limit: 10),
        ).thenAnswer((_) async => recentGames);

        final result = await repository.getRecentGames('player1', limit: 10);

        expect(result.length, equals(2));
        expect(result.first.createdAt.isAfter(result.last.createdAt), isTrue);
        verify(() => repository.getRecentGames('player1', limit: 10)).called(1);
      });

      test('should return empty list when no games found', () async {
        when(
          () => repository.getRecentGames('unknown', limit: 10),
        ).thenAnswer((_) async => []);

        final result = await repository.getRecentGames('unknown', limit: 10);

        expect(result, isEmpty);
      });
    });

    group('deleteScore', () {
      test('should delete a score by id', () async {
        when(
          () => repository.deleteScore('score123'),
        ).thenAnswer((_) async => true);

        final result = await repository.deleteScore('score123');

        expect(result, isTrue);
        verify(() => repository.deleteScore('score123')).called(1);
      });

      test('should return false when score not found', () async {
        when(
          () => repository.deleteScore('unknown'),
        ).thenAnswer((_) async => false);

        final result = await repository.deleteScore('unknown');

        expect(result, isFalse);
      });
    });

    group('deletePlayerData', () {
      test('should delete all data for a player', () async {
        when(
          () => repository.deletePlayerData('player1'),
        ).thenAnswer((_) async => 2);

        final result = await repository.deletePlayerData('player1');

        expect(result, equals(2));
        verify(() => repository.deletePlayerData('player1')).called(1);
      });

      test('should return 0 when player has no data', () async {
        when(
          () => repository.deletePlayerData('unknown'),
        ).thenAnswer((_) async => 0);

        final result = await repository.deletePlayerData('unknown');

        expect(result, equals(0));
      });
    });
  });
}
