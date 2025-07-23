import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource_impl.dart';
import 'package:ojyx/features/multiplayer/domain/datasources/room_datasource.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/create_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/join_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseRoomDatasource extends Mock
    implements SupabaseRoomDatasource {}

class MockRoomDatasource extends Mock implements RoomDatasource {}

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  late ProviderContainer container;
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseRoomDatasource mockSupabaseRoomDatasource;
  late MockRoomDatasource mockRoomDatasource;
  late MockRoomRepository mockRoomRepository;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseRoomDatasource = MockSupabaseRoomDatasource();
    mockRoomDatasource = MockRoomDatasource();
    mockRoomRepository = MockRoomRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('supabaseRoomDatasourceProvider', () {
    test('should provide SupabaseRoomDatasource instance', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockSupabaseClient),
        ],
      );

      // Act
      final datasource = container.read(supabaseRoomDatasourceProvider);

      // Assert
      expect(datasource, isA<SupabaseRoomDatasource>());
    });
  });

  group('roomDatasourceProvider', () {
    test('should provide RoomDatasource instance', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          supabaseRoomDatasourceProvider.overrideWithValue(
            mockSupabaseRoomDatasource,
          ),
        ],
      );

      // Act
      final datasource = container.read(roomDatasourceProvider);

      // Assert
      expect(datasource, isA<RoomDatasource>());
      expect(datasource, isA<SupabaseRoomDatasourceImpl>());
    });
  });

  group('roomRepositoryProvider', () {
    test('should provide RoomRepository instance', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          roomDatasourceProvider.overrideWithValue(mockRoomDatasource),
        ],
      );

      // Act
      final repository = container.read(roomRepositoryProvider);

      // Assert
      expect(repository, isA<RoomRepository>());
    });
  });

  group('createRoomUseCaseProvider', () {
    test('should provide CreateRoomUseCase instance', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final useCase = container.read(createRoomUseCaseProvider);

      // Assert
      expect(useCase, isA<CreateRoomUseCase>());
    });

    test('should create room using use case', () async {
      // Arrange
      const creatorId = 'creator123';
      const maxPlayers = 4;
      final expectedRoom = Room(
        id: 'room123',
        creatorId: creatorId,
        playerIds: [creatorId],
        status: RoomStatus.waiting,
        maxPlayers: maxPlayers,
      );

      when(
        () => mockRoomRepository.createRoom(
          creatorId: creatorId,
          maxPlayers: maxPlayers,
        ),
      ).thenAnswer((_) async => expectedRoom);

      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final useCase = container.read(createRoomUseCaseProvider);
      final result = await useCase.call(
        creatorId: creatorId,
        maxPlayers: maxPlayers,
      );

      // Assert
      expect(result, equals(expectedRoom));
    });
  });

  group('joinRoomUseCaseProvider', () {
    test('should provide JoinRoomUseCase instance', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final useCase = container.read(joinRoomUseCaseProvider);

      // Assert
      expect(useCase, isA<JoinRoomUseCase>());
    });
  });

  group('syncGameStateUseCaseProvider', () {
    test('should provide SyncGameStateUseCase instance', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final useCase = container.read(syncGameStateUseCaseProvider);

      // Assert
      expect(useCase, isA<SyncGameStateUseCase>());
    });
  });

  group('currentRoomProvider', () {
    test('should watch room stream', () async {
      // Arrange
      const roomId = 'room123';
      final expectedRoom = const Room(
        id: roomId,
        creatorId: 'creator123',
        playerIds: ['creator123'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );
      final roomStream = Stream<Room>.value(expectedRoom);

      when(
        () => mockRoomRepository.watchRoom(roomId),
      ).thenAnswer((_) => roomStream);

      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final asyncValue = await container.read(currentRoomProvider(roomId).future);

      // Assert
      expect(asyncValue, equals(expectedRoom));
      expect(asyncValue.id, equals(roomId));
    });

    test('should handle different room IDs', () async {
      // Arrange
      const roomId1 = 'room123';
      const roomId2 = 'room456';

      final expectedRoom1 = const Room(
        id: roomId1,
        creatorId: 'creator1',
        playerIds: ['creator1'],
        status: RoomStatus.waiting,
        maxPlayers: 4,
      );

      final expectedRoom2 = const Room(
        id: roomId2,
        creatorId: 'creator2',
        playerIds: ['creator2'],
        status: RoomStatus.inGame,
        maxPlayers: 6,
      );

      final roomStream1 = Stream<Room>.value(expectedRoom1);
      final roomStream2 = Stream<Room>.value(expectedRoom2);

      when(
        () => mockRoomRepository.watchRoom(roomId1),
      ).thenAnswer((_) => roomStream1);
      when(
        () => mockRoomRepository.watchRoom(roomId2),
      ).thenAnswer((_) => roomStream2);

      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final room1 = await container.read(currentRoomProvider(roomId1).future);
      final room2 = await container.read(currentRoomProvider(roomId2).future);

      // Assert
      expect(room1.id, equals(roomId1));
      expect(room2.id, equals(roomId2));
      expect(room1, isNot(equals(room2)));
    });
  });

  group('roomEventsProvider', () {
    test('should watch room events stream', () async {
      // Arrange
      const roomId = 'room123';
      final expectedEvent = RoomEvent.playerJoined(playerId: 'player456', playerName: 'Player 456');
      final eventStream = Stream<RoomEvent>.value(expectedEvent);

      when(
        () => mockRoomRepository.watchRoomEvents(roomId),
      ).thenAnswer((_) => eventStream);

      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final event = await container.read(roomEventsProvider(roomId).future);

      // Assert
      expect(event, equals(expectedEvent));
      expect(event, isA<PlayerJoined>());
      final playerJoinedEvent = event as PlayerJoined;
      expect(playerJoinedEvent.playerId, equals('player456'));
    });
  });

  group('availableRoomsProvider', () {
    test('should fetch available rooms', () async {
      // Arrange
      final expectedRooms = [
        const Room(
          id: 'room1',
          creatorId: 'creator1',
          playerIds: ['creator1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
        ),
        const Room(
          id: 'room2',
          creatorId: 'creator2',
          playerIds: ['creator2'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
        ),
      ];

      when(
        () => mockRoomRepository.getAvailableRooms(),
      ).thenAnswer((_) async => expectedRooms);

      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final result = await container.read(availableRoomsProvider.future);

      // Assert
      expect(result, equals(expectedRooms));
      expect(result.length, equals(2));
    });

    test('should handle empty room list', () async {
      // Arrange
      when(
        () => mockRoomRepository.getAvailableRooms(),
      ).thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [
          roomRepositoryProvider.overrideWithValue(mockRoomRepository),
        ],
      );

      // Act
      final result = await container.read(availableRoomsProvider.future);

      // Assert
      expect(result, isEmpty);
    });
  });

  group('currentRoomIdProvider', () {
    test('should have null initial value', () {
      // Arrange
      container = ProviderContainer();

      // Act
      final roomId = container.read(currentRoomIdProvider);

      // Assert
      expect(roomId, isNull);
    });

    test('should be overridable', () {
      // Arrange
      container = ProviderContainer(
        overrides: [currentRoomIdProvider.overrideWithValue('room123')],
      );

      // Act
      final roomId = container.read(currentRoomIdProvider);

      // Assert
      expect(roomId, equals('room123'));
    });
  });
}
