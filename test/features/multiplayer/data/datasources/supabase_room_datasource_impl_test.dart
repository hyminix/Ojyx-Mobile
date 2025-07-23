import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource_impl.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model.dart';
import 'package:ojyx/features/multiplayer/data/models/room_model_extensions.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import '../../../../mocks/mock_room_datasource.dart';

class MockSupabaseRoomDatasource extends Mock
    implements SupabaseRoomDatasource {}

void main() {
  late SupabaseRoomDatasourceImpl datasource;
  late MockSupabaseRoomDatasource mockSupabaseDatasource;

  setUp(() {
    mockSupabaseDatasource = MockSupabaseRoomDatasource();
    datasource = SupabaseRoomDatasourceImpl(mockSupabaseDatasource);
  });

  setUpAll(() {
    registerRoomFallbackValues();
  });

  group('createRoom', () {
    test('should create a room successfully', () async {
      // Arrange
      const creatorId = 'user-123';
      const maxPlayers = 4;
      final room = Room(
        id: 'room-123',
        creatorId: creatorId,
        playerIds: [creatorId],
        status: RoomStatus.waiting,
        maxPlayers: maxPlayers,
        createdAt: DateTime.now(),
      );

      when(
        () => mockSupabaseDatasource.createRoom(
          creatorId: any(named: 'creatorId'),
          maxPlayers: any(named: 'maxPlayers'),
        ),
      ).thenAnswer((_) async => room.toModel());

      // Act
      final result = await datasource.createRoom(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      );

      // Assert
      expect(result, equals(room));
      verify(
        () => mockSupabaseDatasource.createRoom(
          creatorId: creatorId,
          maxPlayers: maxPlayers,
        ),
      ).called(1);
    });

    test('should throw exception on database error', () async {
      // Arrange
      const creatorId = 'user-123';
      const maxPlayers = 4;

      when(
        () => mockSupabaseDatasource.createRoom(
          creatorId: any(named: 'creatorId'),
          maxPlayers: any(named: 'maxPlayers'),
        ),
      ).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () =>
            datasource.createRoom(creatorId: creatorId, maxPlayers: maxPlayers),
        throwsException,
      );
    });
  });

  group('watchRoom', () {
    test('should return stream of room updates', () async {
      // Arrange
      const roomId = 'room-123';
      final room = Room(
        id: roomId,
        creatorId: 'user-123',
        playerIds: ['user-123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(
        () => mockSupabaseDatasource.watchRoom(roomId),
      ).thenAnswer((_) => Stream.value(room.toModel()));

      // Act
      final stream = datasource.watchRoom(roomId);

      // Assert
      await expectLater(stream, emits(room));
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

      when(
        () => mockSupabaseDatasource.updateRoomStatus(
          roomId: any(named: 'roomId'),
          status: any(named: 'status'),
          gameId: any(named: 'gameId'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockSupabaseDatasource.getRoom(room.id),
      ).thenAnswer((_) async => room.toModel());

      // Act
      final result = await datasource.updateRoom(room);

      // Assert
      expect(result, equals(room));
      verify(
        () => mockSupabaseDatasource.updateRoomStatus(
          roomId: room.id,
          status: 'in_game',
          gameId: room.currentGameId,
        ),
      ).called(1);
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

      when(
        () => mockSupabaseDatasource.getAvailableRooms(),
      ).thenAnswer((_) async => rooms.map((r) => r.toModel()).toList());

      // Act
      final result = await datasource.getAvailableRooms();

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 'room-1');
      expect(result[1].id, 'room-2');
    });
  });
}
