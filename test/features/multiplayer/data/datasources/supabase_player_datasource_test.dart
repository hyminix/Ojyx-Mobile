import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_player_datasource.dart';
import 'package:ojyx/features/multiplayer/data/models/player_model.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder<dynamic> {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<dynamic> {}

void main() {
  group('SupabasePlayerDataSource', () {
    late SupabasePlayerDataSource dataSource;
    late MockSupabaseClient mockSupabase;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late MockPostgrestFilterBuilder mockFilterBuilder;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      mockFilterBuilder = MockPostgrestFilterBuilder();
      dataSource = SupabasePlayerDataSource(mockSupabase);
    });

    setUpAll(() {
      registerFallbackValue(<String, dynamic>{});
    });

    group('createPlayer', () {
      test('should create player with all fields', () async {
        final response = {
          'id': 'player123',
          'name': 'Test Player',
          'avatar_url': 'https://example.com/avatar.png',
          'current_room_id': 'room123',
          'connection_status': 'online',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'last_seen_at': DateTime.now().toIso8601String(),
        };

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await dataSource.createPlayer(
          name: 'Test Player',
          avatarUrl: 'https://example.com/avatar.png',
          currentRoomId: 'room123',
        );

        expect(result.id, 'player123');
        expect(result.name, 'Test Player');
        expect(result.avatarUrl, 'https://example.com/avatar.png');
        expect(result.currentRoomId, 'room123');
        expect(result.connectionStatus, 'online');

        verify(() => mockQueryBuilder.insert({
          'name': 'Test Player',
          'avatar_url': 'https://example.com/avatar.png',
          'current_room_id': 'room123',
          'connection_status': 'online',
        })).called(1);
      });

      test('should create player with minimal fields', () async {
        final response = {
          'id': 'player123',
          'name': 'Test Player',
          'avatar_url': null,
          'current_room_id': null,
          'connection_status': 'online',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'last_seen_at': DateTime.now().toIso8601String(),
        };

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await dataSource.createPlayer(name: 'Test Player');

        expect(result.id, 'player123');
        expect(result.name, 'Test Player');
        expect(result.avatarUrl, isNull);
        expect(result.currentRoomId, isNull);
      });
    });

    group('getPlayer', () {
      test('should return player when found', () async {
        final response = {
          'id': 'player123',
          'name': 'Test Player',
          'avatar_url': 'https://example.com/avatar.png',
          'current_room_id': 'room123',
          'connection_status': 'online',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'last_seen_at': DateTime.now().toIso8601String(),
        };

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'player123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await dataSource.getPlayer('player123');

        expect(result, isNotNull);
        expect(result!.id, 'player123');
        expect(result.name, 'Test Player');
      });

      test('should return null when player not found', () async {
        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'nonexistent'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenThrow(Exception('No rows found'));

        final result = await dataSource.getPlayer('nonexistent');

        expect(result, isNull);
      });
    });

    group('updatePlayer', () {
      test('should update player successfully', () async {
        final player = PlayerModel(
          id: 'player123',
          name: 'Updated Player',
          avatarUrl: 'https://example.com/new-avatar.png',
          currentRoomId: 'room456',
          connectionStatus: 'online',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lastSeenAt: DateTime.now(),
        );

        final response = player.toJson();

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.update(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'player123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await dataSource.updatePlayer(player);

        expect(result.id, player.id);
        expect(result.name, player.name);
        expect(result.avatarUrl, player.avatarUrl);
        verify(() => mockQueryBuilder.update(player.toSupabaseJson())).called(1);
      });
    });

    group('deletePlayer', () {
      test('should delete player successfully', () async {
        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.delete())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'player123'))
            .thenAnswer((_) async => []);

        await dataSource.deletePlayer('player123');

        verify(() => mockQueryBuilder.delete()).called(1);
        verify(() => mockFilterBuilder.eq('id', 'player123')).called(1);
      });
    });

    group('getPlayersByRoom', () {
      test('should return list of players in room', () async {
        final response = [
          {
            'id': 'player1',
            'name': 'Player 1',
            'avatar_url': null,
            'current_room_id': 'room123',
            'connection_status': 'online',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'last_seen_at': DateTime.now().toIso8601String(),
          },
          {
            'id': 'player2',
            'name': 'Player 2',
            'avatar_url': null,
            'current_room_id': 'room123',
            'connection_status': 'online',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'last_seen_at': DateTime.now().toIso8601String(),
          },
        ];

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('current_room_id', 'room123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at'))
            .thenAnswer((_) async => response);

        final result = await dataSource.getPlayersByRoom('room123');

        expect(result.length, 2);
        expect(result[0].id, 'player1');
        expect(result[1].id, 'player2');
        expect(result.every((p) => p.currentRoomId == 'room123'), isTrue);
      });

      test('should return empty list when no players in room', () async {
        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('current_room_id', 'empty_room'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at'))
            .thenAnswer((_) async => []);

        final result = await dataSource.getPlayersByRoom('empty_room');

        expect(result, isEmpty);
      });
    });

    group('updateConnectionStatus', () {
      test('should update connection status with timestamp', () async {
        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.update(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'player123'))
            .thenAnswer((_) async => []);

        await dataSource.updateConnectionStatus(
          playerId: 'player123',
          status: 'offline',
        );

        final capturedData = verify(() => mockQueryBuilder.update(captureAny()))
            .captured.single as Map<String, dynamic>;

        expect(capturedData['connection_status'], 'offline');
        expect(capturedData['last_seen_at'], isNotNull);
        expect(DateTime.tryParse(capturedData['last_seen_at']), isNotNull);
      });
    });

    group('updateLastSeen', () {
      test('should update last seen timestamp', () async {
        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.update(any()))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'player123'))
            .thenAnswer((_) async => []);

        await dataSource.updateLastSeen('player123');

        final capturedData = verify(() => mockQueryBuilder.update(captureAny()))
            .captured.single as Map<String, dynamic>;

        expect(capturedData['last_seen_at'], isNotNull);
        expect(DateTime.tryParse(capturedData['last_seen_at']), isNotNull);
      });
    });

    group('watchPlayer', () {
      test('should stream player updates', () async {
        final playerData = {
          'id': 'player123',
          'name': 'Test Player',
          'avatar_url': null,
          'current_room_id': 'room123',
          'connection_status': 'online',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'last_seen_at': DateTime.now().toIso8601String(),
        };

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'player123'))
            .thenReturn(Stream.value([playerData]));

        final stream = dataSource.watchPlayer('player123');

        await expectLater(
          stream,
          emits(isA<PlayerModel>()
              .having((p) => p.id, 'id', 'player123')
              .having((p) => p.name, 'name', 'Test Player')),
        );
      });
    });

    group('watchPlayersInRoom', () {
      test('should stream list of players in room', () async {
        final playersData = [
          {
            'id': 'player1',
            'name': 'Player 1',
            'avatar_url': null,
            'current_room_id': 'room123',
            'connection_status': 'online',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'last_seen_at': DateTime.now().toIso8601String(),
          },
          {
            'id': 'player2',
            'name': 'Player 2',
            'avatar_url': null,
            'current_room_id': 'room123',
            'connection_status': 'online',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'last_seen_at': DateTime.now().toIso8601String(),
          },
        ];

        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('current_room_id', 'room123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at'))
            .thenReturn(Stream.value(playersData));

        final stream = dataSource.watchPlayersInRoom('room123');

        await expectLater(
          stream,
          emits(isA<List<PlayerModel>>()
              .having((list) => list.length, 'length', 2)
              .having((list) => list[0].id, 'first player id', 'player1')
              .having((list) => list[1].id, 'second player id', 'player2')),
        );
      });

      test('should handle empty room', () async {
        when(() => mockSupabase.from('players'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('current_room_id', 'empty_room'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at'))
            .thenReturn(Stream.value([]));

        final stream = dataSource.watchPlayersInRoom('empty_room');

        await expectLater(
          stream,
          emits(isEmpty),
        );
      });
    });
  });
}