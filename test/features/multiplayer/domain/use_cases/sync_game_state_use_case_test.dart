import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  late SyncGameStateUseCase syncGameStateUseCase;
  late MockRoomRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(
      const RoomEvent.playerJoined(playerId: 'test', playerName: 'Test'),
    );
  });

  setUp(() {
    mockRepository = MockRoomRepository();
    syncGameStateUseCase = SyncGameStateUseCase(mockRepository);
  });

  group('SyncGameStateUseCase', () {
    test('should sync game state successfully', () async {
      // Arrange
      const roomId = 'room123';
      final gameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'GamePlayer 1',
            grid: PlayerGrid.fromCards(
              List.generate(12, (_) => const Card(value: 5, isRevealed: false)),
            ),
            actionCards: [],
            isConnected: true,
            isHost: false,
            hasFinishedRound: false,
            scoreMultiplier: 1,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [
          const Card(value: 1, isRevealed: false),
          const Card(value: 2, isRevealed: false),
        ],
        discardPile: [const Card(value: 3, isRevealed: true)],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        drawnCard: null,
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepository.sendEvent(
          roomId: roomId,
          event: any(named: 'event'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await syncGameStateUseCase.syncGameState(
        roomId: roomId,
        gameState: gameState,
      );

      // Assert
      verify(
        () => mockRepository.sendEvent(
          roomId: roomId,
          event: any(named: 'event'),
        ),
      ).called(1);
    });

    test('should send player action successfully', () async {
      // Arrange
      const roomId = 'room123';
      const playerId = 'player1';
      const actionType = PlayerActionType.drawCard;
      final actionData = {'source': 'deck'};

      when(
        () => mockRepository.sendEvent(
          roomId: roomId,
          event: any(named: 'event'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await syncGameStateUseCase.sendPlayerAction(
        roomId: roomId,
        playerId: playerId,
        actionType: actionType,
        actionData: actionData,
      );

      // Assert
      verify(
        () => mockRepository.sendEvent(
          roomId: roomId,
          event: any(named: 'event'),
        ),
      ).called(1);
    });

    test('should watch game events', () {
      // Arrange
      const roomId = 'room123';
      final events = [
        const RoomEvent.playerJoined(
          playerId: 'player1',
          playerName: 'GamePlayer 1',
        ),
        const RoomEvent.playerAction(
          playerId: 'player1',
          actionType: PlayerActionType.drawCard,
          actionData: {'source': 'deck'},
        ),
      ];

      when(
        () => mockRepository.watchRoomEvents(roomId),
      ).thenAnswer((_) => Stream.fromIterable(events));

      // Act
      final stream = syncGameStateUseCase.watchGameEvents(roomId);

      // Assert
      expect(stream, emitsInOrder(events));
    });
  });
}
