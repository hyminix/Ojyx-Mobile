import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockPostgrestClient extends Mock implements PostgrestClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder {}
class MockRealtimeClient extends Mock implements RealtimeClient {}
class MockRealtimeChannel extends Mock implements RealtimeChannel {}

void main() {
  late SupabaseRoomDatasource datasource;
  late MockSupabaseClient mockSupabaseClient;
  late MockPostgrestClient mockPostgrestClient;
  late MockRealtimeClient mockRealtimeClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockPostgrestClient = MockPostgrestClient();
    mockRealtimeClient = MockRealtimeClient();
    datasource = SupabaseRoomDatasource(mockSupabaseClient);

    when(() => mockSupabaseClient.rest).thenReturn(mockPostgrestClient);
    when(() => mockSupabaseClient.realtime).thenReturn(mockRealtimeClient);
  });

  setUpAll(() {
    registerFallbackValue(const Room(
      id: 'test-id',
      creatorId: 'test-creator',
      playerIds: ['test-creator'],
      status: RoomStatus.waiting,
      maxPlayers: 4,
    ));
  });

  group('createRoom', () {
    test('should create a room successfully', () async {
      // Arrange
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      
      when(() => mockPostgrestClient.from('rooms')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.insert(any())).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.select()).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.single()).thenAnswer(
        (_) async => room.toJson(),
      );

      // Act
      final result = await datasource.createRoom(room);

      // Assert
      expect(result, equals(room));
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });

    test('should throw ServerFailure on database error', () async {
      // Arrange
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      final mockQueryBuilder = MockSupabaseQueryBuilder();
      
      when(() => mockPostgrestClient.from('rooms')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.insert(any())).thenThrow(
        PostgrestException(message: 'Database error'),
      );

      // Act & Assert
      expect(
        () => datasource.createRoom(room),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('watchRoom', () {
    test('should return stream of room updates', () async {
      // Arrange
      final roomId = 'room-123';
      final room = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      final mockChannel = MockRealtimeChannel();
      final streamController = StreamController<Map<String, dynamic>>();

      when(() => mockRealtimeClient.channel(any())).thenReturn(mockChannel);
      when(() => mockChannel.onPostgresChanges(
        event: any(named: 'event'),
        schema: any(named: 'schema'),
        table: any(named: 'table'),
        filter: any(named: 'filter'),
      )).thenReturn(mockChannel);
      when(() => mockChannel.subscribe()).thenAnswer((_) async => mockChannel);
      
      // Simulate stream behavior
      when(() => mockChannel.stream).thenAnswer((_) => streamController.stream);

      // Act
      final stream = datasource.watchRoom(roomId);
      
      // Emit a room update
      streamController.add({
        'eventType': 'UPDATE',
        'new': room.toJson(),
      });

      // Assert
      await expectLater(stream, emits(room));
      
      // Cleanup
      await streamController.close();
    });
  });

  group('updateRoom', () {
    test('should update room successfully', () async {
      // Arrange
      final room = Room(
        id: 'room-123',
        creatorId: 'user-123',
        playerIds: ['user-123', 'user-456'],
        status: RoomStatus.inGame,
        maxPlayers: 4,
        currentGameId: 'game-123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      final mockTransformBuilder = MockPostgrestTransformBuilder();
      
      when(() => mockPostgrestClient.from('rooms')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.update(any())).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.eq('id', room.id)).thenReturn(mockTransformBuilder);
      when(() => mockTransformBuilder.select()).thenReturn(mockTransformBuilder);
      when(() => mockTransformBuilder.single()).thenAnswer(
        (_) async => room.toJson(),
      );

      // Act
      final result = await datasource.updateRoom(room);

      // Assert
      expect(result, equals(room));
      verify(() => mockQueryBuilder.update(any())).called(1);
    });
  });

  group('getAvailableRooms', () {
    test('should return list of available rooms', () async {
      // Arrange
      final rooms = [
        Room(
          id: 'room-1',
          creatorId: 'user-1',
          playerIds: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
        Room(
          id: 'room-2',
          creatorId: 'user-2',
          playerIds: ['user-2', 'user-3'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
          createdAt: DateTime.now(),
        ),
      ];

      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      final mockTransformBuilder = MockPostgrestTransformBuilder();
      
      when(() => mockPostgrestClient.from('rooms')).thenReturn(mockQueryBuilder);
      when(() => mockQueryBuilder.select()).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.eq('status', 'waiting')).thenReturn(mockTransformBuilder);
      when(() => mockTransformBuilder.order('created_at', ascending: false))
          .thenAnswer((_) async => rooms.map((r) => r.toJson()).toList());

      // Act
      final result = await datasource.getAvailableRooms();

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 'room-1');
      expect(result[1].id, 'room-2');
    });
  });
}