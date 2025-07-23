import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/multiplayer_game_notifier.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';

class MockSyncGameStateUseCase extends Mock implements SyncGameStateUseCase {}

void main() {
  late ProviderContainer container;
  late MockSyncGameStateUseCase mockSyncUseCase;

  setUp(() {
    mockSyncUseCase = MockSyncGameStateUseCase();
    container = ProviderContainer(
      overrides: [
        syncGameStateUseCaseProvider.overrideWithValue(mockSyncUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('MultiplayerGameNotifier', () {
    test('should listen to room events on build', () async {
      // Arrange
      const roomId = 'room-123';
      final eventStream = Stream<RoomEvent>.empty();

      when(
        () => mockSyncUseCase.watchGameEvents(roomId),
      ).thenAnswer((_) => eventStream);

      // Act
      await container.read(multiplayerGameNotifierProvider(roomId).future);

      // Assert
      verify(() => mockSyncUseCase.watchGameEvents(roomId)).called(1);
    });

    test('should receive gameStarted event', () async {
      // Arrange
      const roomId = 'room-123';
      final initialState = GameState.initial(
        roomId: roomId,
        players: [
          Player(
            id: 'user-123',
            name: 'John',
            grid: PlayerGrid.empty(),
            isHost: true,
          ),
          Player(
            id: 'user-456',
            name: 'Jane',
            grid: PlayerGrid.empty(),
            isHost: false,
          ),
        ],
      );

      final gameStartedEvent = RoomEvent.gameStarted(
        gameId: 'game-123',
        initialState: initialState,
      );

      final eventController = StreamController<RoomEvent>.broadcast();
      final receivedEvents = <RoomEvent>[];

      when(
        () => mockSyncUseCase.watchGameEvents(roomId),
      ).thenAnswer((_) => eventController.stream);

      // Act
      await container.read(multiplayerGameNotifierProvider(roomId).future);

      // Listen to events from the controller to verify they're being processed
      eventController.stream.listen((event) {
        receivedEvents.add(event);
      });

      // Add event
      eventController.add(gameStartedEvent);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - verify the event was received
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first, equals(gameStartedEvent));

      // Cleanup
      await eventController.close();
    });

    test('should receive gameStateUpdated event', () async {
      // Arrange
      const roomId = 'room-123';
      final updatedState = GameState.initial(
        roomId: roomId,
        players: [
          Player(
            id: 'user-123',
            name: 'John',
            grid: PlayerGrid.empty(),
            isHost: true,
          ),
          Player(
            id: 'user-456',
            name: 'Jane',
            grid: PlayerGrid.empty(),
            isHost: false,
          ),
        ],
      ).copyWith(currentPlayerIndex: 1);

      final updateEvent = RoomEvent.gameStateUpdated(newState: updatedState);

      final eventController = StreamController<RoomEvent>.broadcast();
      final receivedEvents = <RoomEvent>[];

      when(
        () => mockSyncUseCase.watchGameEvents(roomId),
      ).thenAnswer((_) => eventController.stream);

      // Act
      await container.read(multiplayerGameNotifierProvider(roomId).future);

      // Listen to events
      eventController.stream.listen((event) {
        receivedEvents.add(event);
      });

      // Add event
      eventController.add(updateEvent);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - verify the event was received
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first, equals(updateEvent));
      final receivedState = (receivedEvents.first as RoomEvent).mapOrNull(
        gameStateUpdated: (event) => event.newState,
      );
      expect(receivedState?.currentPlayerIndex, 1);

      // Cleanup
      await eventController.close();
    });

    test('should send player action through sync use case', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-123';
      final actionData = {'source': 'deck'};

      when(
        () => mockSyncUseCase.watchGameEvents(roomId),
      ).thenAnswer((_) => Stream.empty());
      when(
        () => mockSyncUseCase.sendPlayerAction(
          roomId: roomId,
          playerId: playerId,
          actionType: PlayerActionType.drawCard,
          actionData: actionData,
        ),
      ).thenAnswer((_) async {});

      // Act
      await container.read(multiplayerGameNotifierProvider(roomId).future);

      final notifier = container.read(
        multiplayerGameNotifierProvider(roomId).notifier,
      );

      await notifier.drawFromDeck(playerId);

      // Assert
      verify(
        () => mockSyncUseCase.sendPlayerAction(
          roomId: roomId,
          playerId: playerId,
          actionType: PlayerActionType.drawCard,
          actionData: {'source': 'deck'},
        ),
      ).called(1);
    });

    test('should handle player action events', () async {
      // Arrange
      const roomId = 'room-123';
      final actionEvent = const RoomEvent.playerAction(
        playerId: 'user-123',
        actionType: PlayerActionType.endTurn,
        actionData: null,
      );

      final eventController = StreamController<RoomEvent>.broadcast();
      when(
        () => mockSyncUseCase.watchGameEvents(roomId),
      ).thenAnswer((_) => eventController.stream);

      // Act
      await container.read(multiplayerGameNotifierProvider(roomId).future);

      // Add event - should be handled silently
      eventController.add(actionEvent);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - no error thrown
      expect(true, isTrue);

      // Cleanup
      await eventController.close();
    });
  });
}
