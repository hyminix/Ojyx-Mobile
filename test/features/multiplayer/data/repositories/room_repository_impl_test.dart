import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/data/repositories/room_repository_impl.dart';
import 'package:ojyx/features/multiplayer/domain/datasources/room_datasource.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/use_cases/game_initialization_use_case.dart';
import '../../../../mocks/mock_room_datasource.dart';

class MockGameInitializationUseCase extends Mock
    implements GameInitializationUseCase {}

void main() {
  group('Room Repository Behavior for Multiplayer Game Coordination', () {
    late RoomRepositoryImpl repository;
    late MockRoomDatasource mockDatasource;
    late MockGameInitializationUseCase mockGameInitializationUseCase;

    setUpAll(() {
      registerRoomFallbackValues();
    });

    setUp(() {
      mockDatasource = MockRoomDatasource();
      mockGameInitializationUseCase = MockGameInitializationUseCase();
      repository = RoomRepositoryImpl(
        mockDatasource,
        mockGameInitializationUseCase,
      );
    });

    test('should enable competitive room creation and participant management for strategic multiplayer gaming', () async {
      // Test behavior: repository coordinates room lifecycle to support fair competitive multiplayer experiences
      
      const strategicHostId = 'competitive-host-789';
      const competitiveCapacity = 6;
      final newCompetitiveRoom = Room(
        id: 'strategic-competitive-arena-456',
        creatorId: strategicHostId,
        playerIds: [strategicHostId],
        status: RoomStatus.waiting,
        maxPlayers: competitiveCapacity,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.createRoom(
        creatorId: strategicHostId,
        maxPlayers: competitiveCapacity,
      )).thenAnswer((_) async => newCompetitiveRoom);

      // Repository should create rooms ready for competitive participants
      final createdRoom = await repository.createRoom(
        creatorId: strategicHostId,
        maxPlayers: competitiveCapacity,
      );
      
      expect(createdRoom.creatorId, strategicHostId, reason: 'Room should establish proper host authority for competitive control');
      expect(createdRoom.maxPlayers, competitiveCapacity, reason: 'Capacity should support strategic group competitive gameplay');
      expect(createdRoom.status, RoomStatus.waiting, reason: 'New rooms should be ready to accept competitive participants');
      expect(createdRoom.playerIds, [strategicHostId], reason: 'Host should be initial participant in competitive room');
      
      // Repository should handle creation failures gracefully
      when(() => mockDatasource.createRoom(
        creatorId: any(named: 'creatorId'),
        maxPlayers: any(named: 'maxPlayers'),
      )).thenThrow(Exception('Competitive room creation failed'));

      expect(
        () => repository.createRoom(creatorId: 'failed-host', maxPlayers: 4),
        throwsException,
        reason: 'Repository should propagate creation failures for proper error handling'
      );
    });

    test('should coordinate competitive participant joining for balanced multiplayer room composition', () async {
      // Test behavior: repository manages room joining to ensure fair competitive participation
      
      const competitiveRoomId = 'tactical-arena-789';
      const newCompetitorId = 'strategic-participant-456';
      final expandedCompetitiveRoom = Room(
        id: competitiveRoomId,
        creatorId: 'room-host-123',
        playerIds: ['room-host-123', newCompetitorId],
        status: RoomStatus.waiting,
        maxPlayers: 4,
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.joinRoom(
        roomId: competitiveRoomId,
        playerId: newCompetitorId,
      )).thenAnswer((_) async => expandedCompetitiveRoom);

      // Repository should successfully add competitive participants
      final joinedRoom = await repository.joinRoom(
        roomId: competitiveRoomId,
        playerId: newCompetitorId,
      );
      
      expect(joinedRoom, isNotNull, reason: 'Join operation should return valid room');
      expect(joinedRoom!.playerIds.length, 2, reason: 'Room should expand to include new competitive participant');
      expect(joinedRoom.playerIds.contains(newCompetitorId), true, reason: 'New competitor should be properly registered in room roster');
      expect(joinedRoom.status, RoomStatus.waiting, reason: 'Room should remain open for additional competitive participants');
      
      // Repository should handle joining failures appropriately
      when(() => mockDatasource.joinRoom(
        roomId: any(named: 'roomId'),
        playerId: any(named: 'playerId'),
      )).thenThrow(Exception('Competitive room capacity exceeded'));

      expect(
        () => repository.joinRoom(roomId: 'full-room', playerId: 'rejected-player'),
        throwsException,
        reason: 'Repository should handle capacity limits and joining conflicts properly'
      );
    });

    test('should provide real-time room monitoring for synchronized competitive multiplayer coordination', () async {
      // Test behavior: repository enables live room state tracking for competitive gameplay coordination
      
      const liveCompetitiveRoomId = 'monitored-arena-555';
      final monitoredRoom = Room(
        id: liveCompetitiveRoomId,
        creatorId: 'tactical-host-789',
        playerIds: ['tactical-host-789', 'competitive-player-123'],
        status: RoomStatus.inGame,
        maxPlayers: 6,
        currentGameId: 'live-competitive-match-999',
        createdAt: DateTime.now(),
      );

      when(() => mockDatasource.watchRoom(liveCompetitiveRoomId))
          .thenAnswer((_) => Stream.value(monitoredRoom));

      final roomMonitoringStream = repository.watchRoom(liveCompetitiveRoomId);
      
      await expectLater(
        roomMonitoringStream,
        emits(monitoredRoom),
        reason: 'Repository should provide real-time room updates for competitive coordination'
      );
    });

    test('should track competitive room events for real-time multiplayer participant coordination', () async {
      // Test behavior: repository monitors room events to enable responsive competitive interactions
      
      const eventMonitoredRoomId = 'event-tracked-arena-456';
      const competitiveJoinEvent = RoomEvent.playerJoined(
        playerId: 'strategic-new-competitor-789',
        playerName: 'Elite Strategic Player',
      );

      when(() => mockDatasource.watchRoomEvents(eventMonitoredRoomId))
          .thenAnswer((_) => Stream.value(competitiveJoinEvent));

      final roomEventStream = repository.watchRoomEvents(eventMonitoredRoomId);
      
      await expectLater(
        roomEventStream,
        emits(competitiveJoinEvent),
        reason: 'Repository should provide real-time competitive event tracking for participant coordination'
      );
    });

    test('should coordinate competitive game initialization and room state transition for organized multiplayer matches', () async {
      // Test behavior: repository orchestrates game launch to ensure proper competitive match setup
      
      const competitiveRoomId = 'tournament-launch-room-789';
      const competitiveGameId = 'strategic-match-555';
      final readyCompetitiveRoom = Room(
        id: competitiveRoomId,
        creatorId: 'tournament-organizer-123',
        playerIds: ['tournament-organizer-123', 'competitive-player-456', 'strategic-participant-789'],
        status: RoomStatus.waiting,
        maxPlayers: 6,
        createdAt: DateTime.now(),
      );
      final launchedCompetitiveRoom = readyCompetitiveRoom.copyWith(
        status: RoomStatus.inGame,
        currentGameId: competitiveGameId,
      );

      when(() => mockDatasource.getRoom(competitiveRoomId))
          .thenAnswer((_) async => readyCompetitiveRoom);
      when(() => mockDatasource.updateRoom(any()))
          .thenAnswer((_) async => launchedCompetitiveRoom);
      when(() => mockGameInitializationUseCase.execute(
        roomId: competitiveRoomId,
        playerIds: readyCompetitiveRoom.playerIds,
        creatorId: readyCompetitiveRoom.creatorId,
      )).thenAnswer((_) async => GameState(
        roomId: competitiveRoomId,
        players: [],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        drawnCard: null,
        createdAt: DateTime.now(),
        startedAt: null,
        finishedAt: null,
        initiatorPlayerId: null,
        endRoundInitiator: null,
      ));

      // Repository should coordinate complete game launch process
      await repository.startGame(roomId: competitiveRoomId, gameId: competitiveGameId);
      
      verify(() => mockDatasource.getRoom(competitiveRoomId)).called(1);
      verify(() => mockDatasource.updateRoom(any())).called(1);
      verify(() => mockGameInitializationUseCase.execute(
        roomId: competitiveRoomId,
        playerIds: readyCompetitiveRoom.playerIds,
        creatorId: readyCompetitiveRoom.creatorId,
      )).called(1);
    });

    test('should discover competitive rooms for strategic multiplayer matchmaking opportunities', () async {
      // Test behavior: repository provides room discovery to enable strategic competitive matchmaking
      
      final availableCompetitiveRooms = [
        Room(
          id: 'strategic-arena-alpha-456',
          creatorId: 'competitive-host-1',
          playerIds: ['competitive-host-1'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          createdAt: DateTime.now(),
        ),
        Room(
          id: 'tactical-arena-beta-789',
          creatorId: 'competitive-host-2',
          playerIds: ['competitive-host-2', 'experienced-player-123'],
          status: RoomStatus.waiting,
          maxPlayers: 6,
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockDatasource.getAvailableRooms())
          .thenAnswer((_) async => availableCompetitiveRooms);

      final discoveredRooms = await repository.getAvailableRooms();
      
      expect(discoveredRooms.length, 2, reason: 'Repository should discover multiple competitive room options for strategic matchmaking');
      expect(discoveredRooms[0].id, 'strategic-arena-alpha-456', reason: 'First competitive room should be properly accessible');
      expect(discoveredRooms[1].id, 'tactical-arena-beta-789', reason: 'Second competitive room should offer alternative strategic gameplay');
      expect(discoveredRooms.every((room) => room.status == RoomStatus.waiting), true, reason: 'All discovered rooms should be accepting new competitive participants');
    });
  });
}
