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
import 'package:ojyx/features/game/presentation/providers/game_providers.dart';

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

      when(() => mockSyncUseCase.watchGameEvents(roomId))
          .thenAnswer((_) => eventStream);

      // Act
      await container.read(
        multiplayerGameNotifierProvider(roomId).future,
      );

      // Assert
      verify(() => mockSyncUseCase.watchGameEvents(roomId)).called(1);
    });

    test('should update game state when gameStarted event received', () async {
      // Arrange
      const roomId = 'room-123';
      final initialState = GameState.initial(
        roomId: roomId,
        players: [
          Player(id: 'user-123', name: 'John', isHost: true),
          Player(id: 'user-456', name: 'Jane', isHost: false),
        ],
      );
      
      final gameStartedEvent = RoomEvent.gameStarted(
        gameId: 'game-123',
        initialState: initialState,
      );

      final eventController = StreamController<RoomEvent>();
      when(() => mockSyncUseCase.watchGameEvents(roomId))
          .thenAnswer((_) => eventController.stream);

      // Act
      await container.read(
        multiplayerGameNotifierProvider(roomId).future,
      );
      
      // Add event
      eventController.add(gameStartedEvent);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final gameState = container.read(gameStateNotifierProvider);
      expect(gameState, equals(initialState));

      // Cleanup
      await eventController.close();
    });

    test('should update game state when gameStateUpdated event received', () async {
      // Arrange
      const roomId = 'room-123';
      final updatedState = GameState.initial(
        roomId: roomId,
        players: [
          Player(id: 'user-123', name: 'John', isHost: true),
          Player(id: 'user-456', name: 'Jane', isHost: false),
        ],
      ).copyWith(currentPlayerIndex: 1);
      
      final updateEvent = RoomEvent.gameStateUpdated(newState: updatedState);
      
      final eventController = StreamController<RoomEvent>();
      when(() => mockSyncUseCase.watchGameEvents(roomId))
          .thenAnswer((_) => eventController.stream);

      // Act
      await container.read(
        multiplayerGameNotifierProvider(roomId).future,
      );
      
      // Add event
      eventController.add(updateEvent);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      final gameState = container.read(gameStateNotifierProvider);
      expect(gameState?.currentPlayerIndex, 1);

      // Cleanup
      await eventController.close();
    });

    test('should send player action through sync use case', () async {
      // Arrange
      const roomId = 'room-123';
      const playerId = 'user-123';
      final actionData = {'source': 'deck'};

      when(() => mockSyncUseCase.watchGameEvents(roomId))
          .thenAnswer((_) => Stream.empty());
      when(() => mockSyncUseCase.sendPlayerAction(
        roomId: roomId,
        playerId: playerId,
        actionType: PlayerActionType.drawCard,
        actionData: actionData,
      )).thenAnswer((_) async {});

      // Act
      final notifier = await container.read(
        multiplayerGameNotifierProvider(roomId).notifier.future,
      );
      
      await notifier.drawFromDeck(playerId);

      // Assert
      verify(() => mockSyncUseCase.sendPlayerAction(
        roomId: roomId,
        playerId: playerId,
        actionType: PlayerActionType.drawCard,
        actionData: {'source': 'deck'},
      )).called(1);
    });

    test('should handle player action events', () async {
      // Arrange
      const roomId = 'room-123';
      final actionEvent = const RoomEvent.playerAction(
        playerId: 'user-123',
        actionType: PlayerActionType.endTurn,
        actionData: null,
      );

      final eventController = StreamController<RoomEvent>();
      when(() => mockSyncUseCase.watchGameEvents(roomId))
          .thenAnswer((_) => eventController.stream);

      // Act
      await container.read(
        multiplayerGameNotifierProvider(roomId).future,
      );
      
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