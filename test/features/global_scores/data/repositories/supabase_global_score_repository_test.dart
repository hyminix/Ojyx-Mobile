import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/data/datasources/global_score_remote_datasource.dart';
import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';
import 'package:ojyx/features/global_scores/data/repositories/supabase_global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRemoteDataSource extends Mock
    implements GlobalScoreRemoteDataSource {}

class FakeGlobalScoreModel extends Fake implements GlobalScoreModel {}

class FakeGlobalScore extends Fake implements GlobalScore {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGlobalScoreModel());
    registerFallbackValue(FakeGlobalScore());
    registerFallbackValue(<GlobalScoreModel>[]);
  });

  group('SupabaseGlobalScoreRepository', () {
    late SupabaseGlobalScoreRepository repository;
    late MockGlobalScoreRemoteDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockGlobalScoreRemoteDataSource();
      repository = SupabaseGlobalScoreRepository(mockDataSource);
    });

    group('saveScore', () {
      test('should save score via datasource and convert to domain', () async {
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

        final savedModel = GlobalScoreModel(
          id: 'generated123',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room456',
          totalScore: 125,
          roundNumber: 5,
          position: 2,
          isWinner: false,
          createdAt: scoreToSave.createdAt,
          gameEndedAt: scoreToSave.gameEndedAt,
        );

        when(
          () => mockDataSource.saveScore(any()),
        ).thenAnswer((_) async => savedModel);

        final result = await repository.saveScore(scoreToSave);

        expect(result.id, equals('generated123'));
        expect(result.playerId, equals(scoreToSave.playerId));
        expect(result.totalScore, equals(scoreToSave.totalScore));
      });

      test('should throw exception when datasource fails', () async {
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
        );

        when(
          () => mockDataSource.saveScore(any()),
        ).thenThrow(Exception('Datasource error'));

        expect(() => repository.saveScore(scoreToSave), throwsException);
      });
    });

    group('saveBatchScores', () {
      test('should save multiple scores and convert to domain', () async {
        final scores = [
          GlobalScore(
            id: '',
            playerId: 'player1',
            playerName: 'Alice',
            roomId: 'room1',
            totalScore: 100,
            roundNumber: 3,
            position: 1,
            isWinner: true,
            createdAt: DateTime.now(),
          ),
          GlobalScore(
            id: '',
            playerId: 'player2',
            playerName: 'Bob',
            roomId: 'room1',
            totalScore: 120,
            roundNumber: 3,
            position: 2,
            isWinner: false,
            createdAt: DateTime.now(),
          ),
        ];

        final savedModels = [
          GlobalScoreModel(
            id: 'generated_1',
            playerId: 'player1',
            playerName: 'Alice',
            roomId: 'room1',
            totalScore: 100,
            roundNumber: 3,
            position: 1,
            isWinner: true,
            createdAt: scores[0].createdAt,
          ),
          GlobalScoreModel(
            id: 'generated_2',
            playerId: 'player2',
            playerName: 'Bob',
            roomId: 'room1',
            totalScore: 120,
            roundNumber: 3,
            position: 2,
            isWinner: false,
            createdAt: scores[1].createdAt,
          ),
        ];

        when(
          () => mockDataSource.saveBatchScores(any()),
        ).thenAnswer((_) async => savedModels);

        final result = await repository.saveBatchScores(scores);

        expect(result.length, equals(2));
        expect(result.first.id, equals('generated_1'));
        expect(result.last.id, equals('generated_2'));
      });

      test('should handle empty list', () async {
        final result = await repository.saveBatchScores([]);
        expect(result, isEmpty);
      });
    });

    group('getScoresByPlayer', () {
      test('should get scores from datasource and convert to domain', () async {
        final playerModels = [
          GlobalScoreModel(
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
          GlobalScoreModel(
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

        when(
          () => mockDataSource.getScoresByPlayer('player1'),
        ).thenAnswer((_) async => playerModels);

        final result = await repository.getScoresByPlayer('player1');

        expect(result.length, equals(2));
        expect(result.every((s) => s.playerId == 'player1'), isTrue);
      });
    });

    group('getPlayerStats', () {
      test('should calculate stats from player scores', () async {
        final playerModels = [
          GlobalScoreModel(
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
          GlobalScoreModel(
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

        when(
          () => mockDataSource.getScoresByPlayer('player1'),
        ).thenAnswer((_) async => playerModels);

        final result = await repository.getPlayerStats('player1');

        expect(result, isNotNull);
        expect(result!.playerId, equals('player1'));
        expect(result.totalGamesPlayed, equals(2));
        expect(result.totalWins, equals(1));
        expect(result.averageScore, equals(125)); // (100 + 150) / 2
      });

      test('should return null when player has no scores', () async {
        when(
          () => mockDataSource.getScoresByPlayer('unknown'),
        ).thenAnswer((_) async => []);

        final result = await repository.getPlayerStats('unknown');

        expect(result, isNull);
      });
    });

    group('getTopPlayers', () {
      test(
        'should get top players from datasource and convert to PlayerStats',
        () async {
          final topPlayersData = [
            {
              'player_id': 'player1',
              'player_name': 'Alice',
              'total_games': 10,
              'total_wins': 8,
              'average_score': 95.0,
              'best_score': 60,
              'worst_score': 150,
              'average_position': 1.5,
              'total_rounds': 45,
            },
            {
              'player_id': 'player2',
              'player_name': 'Bob',
              'total_games': 15,
              'total_wins': 10,
              'average_score': 105.0,
              'best_score': 70,
              'worst_score': 180,
              'average_position': 2.2,
              'total_rounds': 60,
            },
          ];

          when(
            () => mockDataSource.getTopPlayersRaw(limit: 10),
          ).thenAnswer((_) async => topPlayersData);

          final result = await repository.getTopPlayers(limit: 10);

          expect(result.length, equals(2));
          expect(result.first.winRate, equals(0.8)); // 8/10
          expect(result.last.winRate, equals(10 / 15)); // 10/15
        },
      );
    });

    group('deleteScore', () {
      test('should delete score via datasource', () async {
        when(
          () => mockDataSource.deleteScore('score123'),
        ).thenAnswer((_) async => true);

        final result = await repository.deleteScore('score123');

        expect(result, isTrue);
        verify(() => mockDataSource.deleteScore('score123')).called(1);
      });

      test('should return false when score not found', () async {
        when(
          () => mockDataSource.deleteScore('unknown'),
        ).thenAnswer((_) async => false);

        final result = await repository.deleteScore('unknown');

        expect(result, isFalse);
      });
    });

    group('deletePlayerData', () {
      test('should delete all player data via datasource', () async {
        when(
          () => mockDataSource.deletePlayerData('player1'),
        ).thenAnswer((_) async => 5);

        final result = await repository.deletePlayerData('player1');

        expect(result, equals(5));
        verify(() => mockDataSource.deletePlayerData('player1')).called(1);
      });

      test('should return 0 when player has no data', () async {
        when(
          () => mockDataSource.deletePlayerData('unknown'),
        ).thenAnswer((_) async => 0);

        final result = await repository.deletePlayerData('unknown');

        expect(result, equals(0));
      });
    });
  });
}
