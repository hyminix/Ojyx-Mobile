import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/use_cases/game_initialization_use_case.dart';

void main() {
  group('GameStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have null initial state', () {
      // Act
      final initialState = container.read(gameStateNotifierProvider);

      // Assert
      expect(initialState, isNull);
    });

    test('should load game state', () {
      // Arrange
      final notifier = container.read(gameStateNotifierProvider.notifier);
      final testState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'Test GamePlayer',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isHost: true,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [
          const Card(value: 5, isRevealed: false),
          const Card(value: 10, isRevealed: false),
        ],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Act
      notifier.loadState(testState);
      final loadedState = container.read(gameStateNotifierProvider);

      // Assert
      expect(loadedState, equals(testState));
      expect(loadedState!.roomId, equals('room123'));
      expect(loadedState.players.length, equals(1));
    });

    test('should update state with function', () {
      // Arrange
      final notifier = container.read(gameStateNotifierProvider.notifier);
      final initialState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'Test GamePlayer',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isHost: true,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Load initial state
      notifier.loadState(initialState);

      // Act
      notifier.updateState(
        (state) =>
            state.copyWith(status: GameStatus.playing, currentPlayerIndex: 1),
      );

      final updatedState = container.read(gameStateNotifierProvider);

      // Assert
      expect(updatedState!.status, equals(GameStatus.playing));
      expect(updatedState.currentPlayerIndex, equals(1));
      // Other properties should remain unchanged
      expect(updatedState.roomId, equals('room123'));
      expect(updatedState.turnDirection, equals(TurnDirection.clockwise));
    });

    test('should not update state if current state is null', () {
      // Arrange
      final notifier = container.read(gameStateNotifierProvider.notifier);

      // Act
      notifier.updateState(
        (state) => state.copyWith(status: GameStatus.playing),
      );

      final state = container.read(gameStateNotifierProvider);

      // Assert
      expect(state, isNull);
    });

    test('should handle multiple state updates', () {
      // Arrange
      final notifier = container.read(gameStateNotifierProvider.notifier);
      final initialState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'GamePlayer 1',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isHost: true,
          ),
          GamePlayer(
            id: 'player2',
            name: 'GamePlayer 2',
            grid: PlayerGrid.empty(),
            actionCards: [],
            isHost: false,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Act
      notifier.loadState(initialState);

      // First update
      notifier.updateState(
        (state) => state.copyWith(status: GameStatus.playing),
      );

      // Second update
      notifier.updateState((state) => state.copyWith(currentPlayerIndex: 1));

      // Third update
      notifier.updateState(
        (state) =>
            state.copyWith(turnDirection: TurnDirection.counterClockwise),
      );

      final finalState = container.read(gameStateNotifierProvider);

      // Assert
      expect(finalState!.status, equals(GameStatus.playing));
      expect(finalState.currentPlayerIndex, equals(1));
      expect(finalState.turnDirection, equals(TurnDirection.counterClockwise));
    });

    test('should have placeholder methods for game actions', () {
      // Arrange
      final notifier = container.read(gameStateNotifierProvider.notifier);

      // Act & Assert - These methods should not throw
      expect(() => notifier.drawFromDeck('player1'), returnsNormally);
      expect(() => notifier.drawFromDiscard('player1'), returnsNormally);
      expect(() => notifier.discardCard('player1', 0), returnsNormally);
      expect(() => notifier.revealCard('player1', 3), returnsNormally);
      expect(() => notifier.endTurn(), returnsNormally);
    });
  });

  group('gameInitializationUseCaseProvider', () {
    test('should provide GameInitializationUseCase instance', () {
      // Arrange
      final container = ProviderContainer();

      // Act
      final useCase = container.read(gameInitializationUseCaseProvider);

      // Assert
      expect(useCase, isA<GameInitializationUseCase>());

      // Cleanup
      container.dispose();
    });

    test('should provide same instance on multiple reads', () {
      // Arrange
      final container = ProviderContainer();

      // Act
      final useCase1 = container.read(gameInitializationUseCaseProvider);
      final useCase2 = container.read(gameInitializationUseCaseProvider);

      // Assert
      expect(identical(useCase1, useCase2), isTrue);

      // Cleanup
      container.dispose();
    });

    test('should initialize game using provided use case', () {
      // Arrange
      final container = ProviderContainer();
      final useCase = container.read(gameInitializationUseCaseProvider);

      // Act
      final gameState = useCase.initializeGame(
        playerIds: ['player1', 'player2'],
        roomId: 'room123',
      );

      // Assert
      expect(gameState.roomId, equals('room123'));
      expect(gameState.players.length, equals(2));
      expect(gameState.players[0].id, equals('player1'));
      expect(gameState.players[1].id, equals('player2'));
      expect(gameState.currentPlayerIndex, equals(0));

      // Cleanup
      container.dispose();
    });
  });
}
