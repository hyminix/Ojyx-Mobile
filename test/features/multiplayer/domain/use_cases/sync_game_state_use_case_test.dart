import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';

class MockGameStateRepository extends Mock implements GameStateRepository {}

void main() {
  late SyncGameStateUseCase syncGameStateUseCase;
  late MockGameStateRepository mockRepository;

  setUp(() {
    mockRepository = MockGameStateRepository();
    syncGameStateUseCase = SyncGameStateUseCase(mockRepository);
  });

  group('SyncGameStateUseCase', () {
    test('should watch game state changes', () async {
      // Arrange
      const gameStateId = 'game123';
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
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        status: GameStatus.playing,
        actionDeck: [],
        actionDiscard: [],
      );

      when(
        () => mockRepository.watchGameState(gameStateId),
      ).thenAnswer((_) => Stream.value(gameState));

      // Act
      final stream = syncGameStateUseCase.watchGameState(gameStateId);

      // Assert
      expect(await stream.first, equals(gameState));
      verify(() => mockRepository.watchGameState(gameStateId)).called(1);
    });

    test('should get current game state', () async {
      // Arrange
      const gameStateId = 'game123';
      final gameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'GamePlayer 1',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isConnected: true,
            isHost: false,
            hasFinishedRound: false,
            scoreMultiplier: 1,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        status: GameStatus.playing,
        actionDeck: [],
        actionDiscard: [],
      );

      when(
        () => mockRepository.getGameState(gameStateId),
      ).thenAnswer((_) async => gameState);

      // Act
      final result = await syncGameStateUseCase.getCurrentGameState(
        gameStateId,
      );

      // Assert
      expect(result, equals(gameState));
      verify(() => mockRepository.getGameState(gameStateId)).called(1);
    });

    test('should watch player grid changes', () async {
      // Arrange
      const gameStateId = 'game123';
      const playerId = 'player1';
      final playerGrid = PlayerGrid.fromCards(
        List.generate(12, (_) => const Card(value: 5, isRevealed: false)),
      );

      when(
        () => mockRepository.watchPlayerGrid(
          gameStateId: gameStateId,
          playerId: playerId,
        ),
      ).thenAnswer((_) => Stream.value(playerGrid));

      // Act
      final stream = syncGameStateUseCase.watchPlayerGrid(
        gameStateId: gameStateId,
        playerId: playerId,
      );

      // Assert
      expect(await stream.first, equals(playerGrid));
      verify(
        () => mockRepository.watchPlayerGrid(
          gameStateId: gameStateId,
          playerId: playerId,
        ),
      ).called(1);
    });

    test('should watch game actions', () async {
      // Arrange
      const gameStateId = 'game123';
      final action = {'type': 'draw_card', 'player_id': 'player1'};

      when(
        () => mockRepository.watchGameActions(gameStateId),
      ).thenAnswer((_) => Stream.value(action));

      // Act
      final stream = syncGameStateUseCase.watchGameActions(gameStateId);

      // Assert
      expect(await stream.first, equals(action));
      verify(() => mockRepository.watchGameActions(gameStateId)).called(1);
    });

    test('should reveal card', () async {
      // Arrange
      const gameStateId = 'game123';
      const playerId = 'player1';
      const position = 5;
      final result = {
        'success': true,
        'card': {'value': 7},
      };

      when(
        () => mockRepository.revealCard(
          gameStateId: gameStateId,
          playerId: playerId,
          position: position,
        ),
      ).thenAnswer((_) async => result);

      // Act
      final response = await syncGameStateUseCase.revealCard(
        gameStateId: gameStateId,
        playerId: playerId,
        position: position,
      );

      // Assert
      expect(response, equals(result));
      verify(
        () => mockRepository.revealCard(
          gameStateId: gameStateId,
          playerId: playerId,
          position: position,
        ),
      ).called(1);
    });

    test('should check if player can act', () async {
      // Arrange
      const gameStateId = 'game123';
      const playerId = 'player1';
      final gameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'GamePlayer 1',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isConnected: true,
            isHost: false,
            hasFinishedRound: false,
            scoreMultiplier: 1,
          ),
          GamePlayer(
            id: 'player2',
            name: 'GamePlayer 2',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isConnected: true,
            isHost: false,
            hasFinishedRound: false,
            scoreMultiplier: 1,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        status: GameStatus.playing,
        actionDeck: [],
        actionDiscard: [],
      );

      when(
        () => mockRepository.getGameState(gameStateId),
      ).thenAnswer((_) async => gameState);

      // Act
      final canAct = await syncGameStateUseCase.canPlayerAct(
        gameStateId: gameStateId,
        playerId: playerId,
      );

      // Assert
      expect(canAct, isTrue);
      verify(() => mockRepository.getGameState(gameStateId)).called(1);
    });
  });
}
