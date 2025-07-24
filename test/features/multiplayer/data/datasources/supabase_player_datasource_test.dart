import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_player_datasource.dart';
import 'package:ojyx/features/multiplayer/data/models/player_model.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockSupabaseStreamBuilder extends Mock implements SupabaseStreamBuilder {}

void main() {
  group('SupabasePlayerDataSource', () {
    late MockSupabaseClient mockSupabase;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late MockSupabaseStreamBuilder mockStreamBuilder;
    late SupabasePlayerDataSource dataSource;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      mockStreamBuilder = MockSupabaseStreamBuilder();
      dataSource = SupabasePlayerDataSource(mockSupabase);
    });

    group('createPlayer', () {
      test('should create player successfully', () async {
        // Given
        const name = 'TestPlayer';
        const avatarUrl = 'http://example.com/avatar.png';
        const roomId = 'room-123';

        final expectedData = {
          'name': name,
          'avatar_url': avatarUrl,
          'current_room_id': roomId,
          'connection_status': 'online',
        };

        final responseData = {
          'id': 'player-123',
          'name': name,
          'avatar_url': avatarUrl,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
          'last_seen_at': '2024-01-01T00:00:00.000Z',
          'connection_status': 'online',
          'current_room_id': roomId,
        };

        when(() => mockSupabase.from('players')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select()).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.single()).thenAnswer((_) async => responseData);

        // When
        final result = await dataSource.createPlayer(
          name: name,
          avatarUrl: avatarUrl,
          currentRoomId: roomId,
        );

        // Then
        expect(result.id, equals('player-123'));
        expect(result.name, equals(name));
        expect(result.avatarUrl, equals(avatarUrl));
        expect(result.currentRoomId, equals(roomId));
        expect(result.connectionStatus, equals('online'));

        verify(() => mockSupabase.from('players')).called(1);
        verify(() => mockQueryBuilder.insert(any())).called(1);
        verify(() => mockQueryBuilder.select()).called(1);
        verify(() => mockQueryBuilder.single()).called(1);
      });

      test('should handle null optional parameters', () async {
        // Given
        const name = 'TestPlayer';

        final responseData = {
          'id': 'player-123',
          'name': name,
          'avatar_url': null,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
          'last_seen_at': '2024-01-01T00:00:00.000Z',
          'connection_status': 'online',
          'current_room_id': null,
        };

        when(() => mockSupabase.from('players')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.insert(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select()).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.single()).thenAnswer((_) async => responseData);

        // When
        final result = await dataSource.createPlayer(
          name: name,
        );

        // Then
        expect(result.avatarUrl, isNull);
        expect(result.currentRoomId, isNull);
      });
    });

    group('getPlayer', () {
      test('should get player by id successfully', () async {
        // Given
        const playerId = 'player-123';
        final responseData = {
          'id': playerId,
          'name': 'TestPlayer',
          'avatar_url': null,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
          'last_seen_at': '2024-01-01T00:00:00.000Z',
          'connection_status': 'offline',
          'current_room_id': null,
        };

        when(() => mockSupabase.from('players')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select()).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.eq('id', playerId)).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.single()).thenAnswer((_) async => responseData);

        // When
        final result = await dataSource.getPlayer(playerId);

        // Then
        expect(result, isNotNull);
        expect(result!.id, equals(playerId));
        expect(result.name, equals('TestPlayer'));
        expect(result.connectionStatus, equals('offline'));
      });

      test('should return null when player not found', () async {
        // Given
        const playerId = 'nonexistent-player';

        when(() => mockSupabase.from('players')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select()).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.eq('id', playerId)).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.single()).thenThrow(Exception('Not found'));

        // When
        final result = await dataSource.getPlayer(playerId);

        // Then
        expect(result, isNull);
      });
    });

    group('updateConnectionStatus', () {
      test('should update connection status successfully', () async {
        // Given
        const playerId = 'player-123';
        const status = 'away';

        when(() => mockSupabase.from('players')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.update(any())).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.eq('id', playerId)).thenReturn(mockQueryBuilder);

        // When
        await dataSource.updateConnectionStatus(
          playerId: playerId,
          status: status,
        );

        // Then
        verify(() => mockSupabase.from('players')).called(1);
        verify(() => mockQueryBuilder.update(any())).called(1);
        verify(() => mockQueryBuilder.eq('id', playerId)).called(1);
      });
    });

    group('getPlayersByRoom', () {
      test('should get all players in a room', () async {
        // Given
        const roomId = 'room-123';
        final responseData = [
          {
            'id': 'player-1',
            'name': 'Player1',
            'avatar_url': null,
            'created_at': '2024-01-01T00:00:00.000Z',
            'updated_at': '2024-01-01T00:00:00.000Z',
            'last_seen_at': '2024-01-01T00:00:00.000Z',
            'connection_status': 'online',
            'current_room_id': roomId,
          },
          {
            'id': 'player-2',
            'name': 'Player2',
            'avatar_url': null,
            'created_at': '2024-01-01T00:00:00.000Z',
            'updated_at': '2024-01-01T00:00:00.000Z',
            'last_seen_at': '2024-01-01T00:00:00.000Z',
            'connection_status': 'online',
            'current_room_id': roomId,
          },
        ];

        when(() => mockSupabase.from('players')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select()).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.eq('current_room_id', roomId)).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.order('created_at')).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.then(any())).thenAnswer((_) async => responseData);

        // When
        final result = await dataSource.getPlayersByRoom(roomId);

        // Then
        expect(result, hasLength(2));
        expect(result[0].id, equals('player-1'));
        expect(result[1].id, equals('player-2'));
        expect(result.every((p) => p.currentRoomId == roomId), isTrue);
      });
    });
  });
}