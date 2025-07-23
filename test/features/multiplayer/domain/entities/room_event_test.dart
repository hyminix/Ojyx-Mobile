import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('RoomEvent Entity', () {
    test('should create playerJoined event', () {
      // Arrange & Act
      final event = const RoomEvent.playerJoined(
        playerId: 'user-123',
        playerName: 'John Doe',
      );

      // Assert
      event.when(
        playerJoined: (playerId, playerName) {
          expect(playerId, 'user-123');
          expect(playerName, 'John Doe');
        },
        playerLeft: (playerId) => fail('Wrong event type'),
        gameStarted: (gameId, initialState) => fail('Wrong event type'),
        gameStateUpdated: (newState) => fail('Wrong event type'),
        playerAction: (playerId, actionType, actionData) => fail('Wrong event type'),
      );
    });

    test('should create playerLeft event', () {
      // Arrange & Act
      final event = const RoomEvent.playerLeft(playerId: 'user-123');

      // Assert
      event.when(
        playerJoined: (playerId, playerName) => fail('Wrong event type'),
        playerLeft: (playerId) {
          expect(playerId, 'user-123');
        },
        gameStarted: (gameId, initialState) => fail('Wrong event type'),
        gameStateUpdated: (newState) => fail('Wrong event type'),
        playerAction: (playerId, actionType, actionData) => fail('Wrong event type'),
      );
    });

    test('should create gameStarted event with initial state', () {
      // Arrange
      final initialState = GameState.initial(
        roomId: 'room-123',
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

      // Act
      final event = RoomEvent.gameStarted(
        gameId: 'game-123',
        initialState: initialState,
      );

      // Assert
      event.when(
        playerJoined: (playerId, playerName) => fail('Wrong event type'),
        playerLeft: (playerId) => fail('Wrong event type'),
        gameStarted: (gameId, gameState) {
          expect(gameId, 'game-123');
          expect(gameState, equals(initialState));
        },
        gameStateUpdated: (newState) => fail('Wrong event type'),
        playerAction: (playerId, actionType, actionData) => fail('Wrong event type'),
      );
    });

    test('should create playerAction event with data', () {
      // Arrange
      final actionData = {'cardIndex': 5, 'source': 'deck'};

      // Act
      final event = RoomEvent.playerAction(
        playerId: 'user-123',
        actionType: PlayerActionType.drawCard,
        actionData: actionData,
      );

      // Assert
      event.when(
        playerJoined: (playerId, playerName) => fail('Wrong event type'),
        playerLeft: (playerId) => fail('Wrong event type'),
        gameStarted: (gameId, initialState) => fail('Wrong event type'),
        gameStateUpdated: (newState) => fail('Wrong event type'),
        playerAction: (playerId, actionType, data) {
          expect(playerId, 'user-123');
          expect(actionType, PlayerActionType.drawCard);
          expect(data, equals(actionData));
        },
      );
    });

    test('should serialize to/from JSON', () {
      // Arrange
      final event = const RoomEvent.playerJoined(
        playerId: 'user-123',
        playerName: 'John Doe',
      );

      // Act
      final json = event.toJson();
      final deserializedEvent = RoomEvent.fromJson(json);

      // Assert
      expect(deserializedEvent, equals(event));
    });

    test('should handle all PlayerActionType values', () {
      // Test each action type
      for (final actionType in PlayerActionType.values) {
        final event = RoomEvent.playerAction(
          playerId: 'user-123',
          actionType: actionType,
          actionData: null,
        );

        expect(event, isA<RoomEvent>());
      }
    });
  });
}