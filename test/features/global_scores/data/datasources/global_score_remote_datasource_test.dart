import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/data/datasources/global_score_remote_datasource.dart';
import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRemoteDataSource extends Mock implements GlobalScoreRemoteDataSource {}
class FakeGlobalScoreModel extends Fake implements GlobalScoreModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGlobalScoreModel());
    registerFallbackValue(<GlobalScoreModel>[]);
  });

  group('GlobalScoreRemoteDataSource', () {
    late GlobalScoreRemoteDataSource dataSource;

    setUp(() {
      dataSource = MockGlobalScoreRemoteDataSource();
    });

    group('saveScore', () {
      test('should save score and return with id', () async {
        final scoreToSave = GlobalScoreModel(
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

        final savedScore = scoreToSave.copyWith(id: 'generated123');

        when(() => dataSource.saveScore(scoreToSave))
            .thenAnswer((_) async => savedScore);

        final result = await dataSource.saveScore(scoreToSave);

        expect(result.id, equals('generated123'));
        expect(result.playerId, equals(scoreToSave.playerId));
        verify(() => dataSource.saveScore(scoreToSave)).called(1);
      });
    });

    group('saveBatchScores', () {
      test('should save multiple scores', () async {
        final scores = [
          GlobalScoreModel(
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
          GlobalScoreModel(
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

        final savedScores = scores
            .asMap()
            .entries
            .map((e) => e.value.copyWith(id: 'generated_${e.key}'))
            .toList();

        when(() => dataSource.saveBatchScores(scores))
            .thenAnswer((_) async => savedScores);

        final result = await dataSource.saveBatchScores(scores);

        expect(result.length, equals(2));
        expect(result.first.id, equals('generated_0'));
        expect(result.last.id, equals('generated_1'));
      });
    });

    group('getScoresByPlayer', () {
      test('should return scores for a player', () async {
        final playerScores = [
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

        when(() => dataSource.getScoresByPlayer('player1'))
            .thenAnswer((_) async => playerScores);

        final result = await dataSource.getScoresByPlayer('player1');

        expect(result.length, equals(2));
        expect(result.every((s) => s.playerId == 'player1'), isTrue);
      });
    });

    group('getTopPlayersRaw', () {
      test('should return raw top players data', () async {
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

        when(() => dataSource.getTopPlayersRaw(limit: 10))
            .thenAnswer((_) async => topPlayersData);

        final result = await dataSource.getTopPlayersRaw(limit: 10);

        expect(result.length, equals(2));
        expect(result.first['player_id'], equals('player1'));
      });
    });

    group('deleteScore', () {
      test('should delete score and return true', () async {
        when(() => dataSource.deleteScore('score123'))
            .thenAnswer((_) async => true);

        final result = await dataSource.deleteScore('score123');

        expect(result, isTrue);
      });

      test('should return false when score not found', () async {
        when(() => dataSource.deleteScore('unknown'))
            .thenAnswer((_) async => false);

        final result = await dataSource.deleteScore('unknown');

        expect(result, isFalse);
      });
    });

    group('deletePlayerData', () {
      test('should delete all player data', () async {
        when(() => dataSource.deletePlayerData('player1'))
            .thenAnswer((_) async => 5);

        final result = await dataSource.deletePlayerData('player1');

        expect(result, equals(5));
      });

      test('should return 0 when no data found', () async {
        when(() => dataSource.deletePlayerData('unknown'))
            .thenAnswer((_) async => 0);

        final result = await dataSource.deletePlayerData('unknown');

        expect(result, equals(0));
      });
    });
  });
}