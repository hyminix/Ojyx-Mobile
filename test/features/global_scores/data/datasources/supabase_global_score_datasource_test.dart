import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/global_scores/data/datasources/supabase_global_score_datasource.dart';
import 'package:ojyx/features/global_scores/data/models/global_score_model.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder<dynamic> {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<dynamic> {}

void main() {
  group('SupabaseGlobalScoreDataSource', () {
    late SupabaseGlobalScoreDataSource dataSource;
    late MockSupabaseClient mockSupabase;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late MockPostgrestFilterBuilder mockFilterBuilder;
    late DateTime testDateTime;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      mockFilterBuilder = MockPostgrestFilterBuilder();
      dataSource = SupabaseGlobalScoreDataSource(mockSupabase);
      testDateTime = DateTime(2024, 1, 1, 12, 0, 0);
    });

    setUpAll(() {
      registerFallbackValue(<String, dynamic>{});
      registerFallbackValue(<Map<String, dynamic>>[]);
    });

    group('saveScore', () {
      test('should save score and return saved model', () async {
        final score = GlobalScoreModel(
          id: '',
          playerId: 'player123',
          playerName: 'Test Player',
          roomId: 'room123',
          totalScore: 42,
          roundNumber: 3,
          position: 1,
          isWinner: true,
          createdAt: testDateTime,
          gameEndedAt: testDateTime.add(const Duration(hours: 1)),
        );

        final response = {
          'id': 'generated-id',
          'player_id': 'player123',
          'player_name': 'Test Player',
          'room_id': 'room123',
          'total_score': 42,
          'round_number': 3,
          'position': 1,
          'is_winner': true,
          'created_at': testDateTime.toIso8601String(),
          'game_ended_at': testDateTime.add(const Duration(hours: 1)).toIso8601String(),
        };

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await dataSource.saveScore(score);

        expect(result.id, 'generated-id');
        expect(result.playerId, 'player123');
        expect(result.totalScore, 42);
        expect(result.isWinner, isTrue);

        // Verify that empty id is removed from insert data
        final capturedData = verify(() => mockQueryBuilder.insert(captureAny()))
            .captured.single as Map<String, dynamic>;
        expect(capturedData.containsKey('id'), isFalse);
      });
    });

    group('saveBatchScores', () {
      test('should save multiple scores and return saved models', () async {
        final scores = [
          GlobalScoreModel(
            id: '',
            playerId: 'player1',
            playerName: 'Player 1',
            roomId: 'room123',
            totalScore: 10,
            roundNumber: 1,
            position: 1,
            isWinner: true,
            createdAt: testDateTime,
            gameEndedAt: null,
          ),
          GlobalScoreModel(
            id: '',
            playerId: 'player2',
            playerName: 'Player 2',
            roomId: 'room123',
            totalScore: 20,
            roundNumber: 1,
            position: 2,
            isWinner: false,
            createdAt: testDateTime,
            gameEndedAt: null,
          ),
        ];

        final response = [
          {
            'id': 'id1',
            'player_id': 'player1',
            'player_name': 'Player 1',
            'room_id': 'room123',
            'total_score': 10,
            'round_number': 1,
            'position': 1,
            'is_winner': true,
            'created_at': testDateTime.toIso8601String(),
            'game_ended_at': null,
          },
          {
            'id': 'id2',
            'player_id': 'player2',
            'player_name': 'Player 2',
            'room_id': 'room123',
            'total_score': 20,
            'round_number': 1,
            'position': 2,
            'is_winner': false,
            'created_at': testDateTime.toIso8601String(),
            'game_ended_at': null,
          },
        ];

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenAnswer((_) async => response);

        final result = await dataSource.saveBatchScores(scores);

        expect(result.length, 2);
        expect(result[0].id, 'id1');
        expect(result[0].playerId, 'player1');
        expect(result[1].id, 'id2');
        expect(result[1].playerId, 'player2');
      });

      test('should return empty list when input is empty', () async {
        final result = await dataSource.saveBatchScores([]);

        expect(result, isEmpty);
        verifyNever(() => mockSupabase.from(any()));
      });
    });

    group('getScoresByPlayer', () {
      test('should return scores for player ordered by date descending', () async {
        final response = [
          {
            'id': 'score1',
            'player_id': 'player123',
            'player_name': 'Test Player',
            'room_id': 'room1',
            'total_score': 20,
            'round_number': 2,
            'position': 1,
            'is_winner': true,
            'created_at': testDateTime.toIso8601String(),
            'game_ended_at': null,
          },
          {
            'id': 'score2',
            'player_id': 'player123',
            'player_name': 'Test Player',
            'room_id': 'room2',
            'total_score': 30,
            'round_number': 3,
            'position': 2,
            'is_winner': false,
            'created_at': testDateTime.subtract(const Duration(days: 1)).toIso8601String(),
            'game_ended_at': null,
          },
        ];

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'player123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenAnswer((_) async => response);

        final result = await dataSource.getScoresByPlayer('player123');

        expect(result.length, 2);
        expect(result[0].id, 'score1');
        expect(result[1].id, 'score2');
        expect(result.every((score) => score.playerId == 'player123'), isTrue);
      });
    });

    group('getScoresByRoom', () {
      test('should return scores for room ordered by position ascending', () async {
        final response = [
          {
            'id': 'score1',
            'player_id': 'player1',
            'player_name': 'Player 1',
            'room_id': 'room123',
            'total_score': 10,
            'round_number': 1,
            'position': 1,
            'is_winner': true,
            'created_at': testDateTime.toIso8601String(),
            'game_ended_at': null,
          },
          {
            'id': 'score2',
            'player_id': 'player2',
            'player_name': 'Player 2',
            'room_id': 'room123',
            'total_score': 20,
            'round_number': 1,
            'position': 2,
            'is_winner': false,
            'created_at': testDateTime.toIso8601String(),
            'game_ended_at': null,
          },
        ];

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('room_id', 'room123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('position', ascending: true))
            .thenAnswer((_) async => response);

        final result = await dataSource.getScoresByRoom('room123');

        expect(result.length, 2);
        expect(result[0].position, 1);
        expect(result[1].position, 2);
        expect(result.every((score) => score.roomId == 'room123'), isTrue);
      });
    });

    group('getTopPlayersRaw', () {
      test('should call rpc function with default limit', () async {
        final response = [
          {'player_id': 'p1', 'player_name': 'Player 1', 'total_wins': 10},
          {'player_id': 'p2', 'player_name': 'Player 2', 'total_wins': 8},
        ];

        when(() => mockSupabase.rpc('get_top_players', params: any(named: 'params')))
            .thenAnswer((_) async => response);

        final result = await dataSource.getTopPlayersRaw();

        expect(result, equals(response));
        verify(() => mockSupabase.rpc('get_top_players', params: {
          'limit_count': 10,
        })).called(1);
      });

      test('should call rpc function with custom limit', () async {
        final response = [
          {'player_id': 'p1', 'player_name': 'Player 1', 'total_wins': 10},
        ];

        when(() => mockSupabase.rpc('get_top_players', params: any(named: 'params')))
            .thenAnswer((_) async => response);

        final result = await dataSource.getTopPlayersRaw(limit: 5);

        expect(result.length, 1);
        verify(() => mockSupabase.rpc('get_top_players', params: {
          'limit_count': 5,
        })).called(1);
      });
    });

    group('getRecentGames', () {
      test('should return recent games with default limit', () async {
        final response = List.generate(10, (i) => {
          'id': 'score$i',
          'player_id': 'player123',
          'player_name': 'Test Player',
          'room_id': 'room$i',
          'total_score': i * 10,
          'round_number': 1,
          'position': 1,
          'is_winner': i % 2 == 0,
          'created_at': testDateTime.subtract(Duration(days: i)).toIso8601String(),
          'game_ended_at': null,
        });

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'player123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.limit(10))
            .thenAnswer((_) async => response);

        final result = await dataSource.getRecentGames('player123');

        expect(result.length, 10);
        expect(result.every((score) => score.playerId == 'player123'), isTrue);
      });

      test('should return recent games with custom limit', () async {
        final response = List.generate(5, (i) => {
          'id': 'score$i',
          'player_id': 'player123',
          'player_name': 'Test Player',
          'room_id': 'room$i',
          'total_score': i * 10,
          'round_number': 1,
          'position': 1,
          'is_winner': true,
          'created_at': testDateTime.subtract(Duration(days: i)).toIso8601String(),
          'game_ended_at': null,
        });

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'player123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.limit(5))
            .thenAnswer((_) async => response);

        final result = await dataSource.getRecentGames('player123', limit: 5);

        expect(result.length, 5);
      });
    });

    group('deleteScore', () {
      test('should return true when score is deleted', () async {
        final response = [{
          'id': 'score123',
          'player_id': 'player123',
          'player_name': 'Test Player',
          'room_id': 'room123',
          'total_score': 42,
          'round_number': 3,
          'position': 1,
          'is_winner': true,
          'created_at': testDateTime.toIso8601String(),
          'game_ended_at': null,
        }];

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.delete())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'score123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenAnswer((_) async => response);

        final result = await dataSource.deleteScore('score123');

        expect(result, isTrue);
      });

      test('should return false when no score is deleted', () async {
        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.delete())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'nonexistent'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenAnswer((_) async => []);

        final result = await dataSource.deleteScore('nonexistent');

        expect(result, isFalse);
      });
    });

    group('deletePlayerData', () {
      test('should return count of deleted scores', () async {
        final response = [
          {'id': 'score1'},
          {'id': 'score2'},
          {'id': 'score3'},
        ];

        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.delete())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'player123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenAnswer((_) async => response);

        final result = await dataSource.deletePlayerData('player123');

        expect(result, 3);
      });

      test('should return 0 when no data deleted', () async {
        when(() => mockSupabase.from('global_scores'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.delete())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'nonexistent'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenAnswer((_) async => []);

        final result = await dataSource.deletePlayerData('nonexistent');

        expect(result, 0);
      });
    });
  });
}