import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/providers/direction_observer_provider.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

class MockGameAnimationNotifier extends Mock implements GameAnimationNotifier {}

void main() {
  setUpAll(() {
    registerFallbackValue(PlayDirection.forward);
  });

  group('directionObserverProvider', () {
    late ProviderContainer container;
    late MockGameAnimationNotifier mockAnimationNotifier;
    late GameState initialGameState;
    late GameState updatedGameState;

    setUp(() {
      mockAnimationNotifier = MockGameAnimationNotifier();
      
      // Set up default stub for showDirectionChange
      when(() => mockAnimationNotifier.showDirectionChange(any())).thenReturn(null);

      final mockPlayerGrid = PlayerGrid.empty();

      initialGameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(id: 'p1', name: 'Player 1', grid: mockPlayerGrid, actionCards: []),
          GamePlayer(id: 'p2', name: 'Player 2', grid: mockPlayerGrid, actionCards: []),
        ],
        currentPlayerIndex: 0,
        deck: [Card(value: 5), Card(value: 3)],
        discardPile: [Card(value: 2)],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        createdAt: DateTime.now(),
      );

      updatedGameState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );

      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(() => GameStateNotifier()),
          gameAnimationProvider.overrideWith((ref) => mockAnimationNotifier),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize without error', () {
      expect(
        () => container.read(directionObserverProvider),
        returnsNormally,
      );
    });

    test('should not trigger animation on first state update', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Update game state for the first time
      container.read(gameStateNotifierProvider.notifier).loadState(initialGameState);

      await Future.delayed(Duration.zero);

      verifyNever(() => mockAnimationNotifier.showDirectionChange(any()));
    });

    test('should trigger animation when direction changes from clockwise to counterclockwise', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).loadState(initialGameState);
      await Future.delayed(Duration.zero);

      // First update to same state to set previousDirection
      container.read(gameStateNotifierProvider.notifier).updateState((state) => state.copyWith(
        currentPlayerIndex: 0, // Same state to initialize previousDirection
      ));
      await Future.delayed(Duration.zero);

      // Update to state with different direction
      container.read(gameStateNotifierProvider.notifier).updateState((_) => updatedGameState);
      await Future.delayed(Duration.zero);

      // Should trigger animation with backward direction
      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.backward)).called(1);
    });

    test('should trigger animation when direction changes from counterclockwise to clockwise', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state with counterclockwise
      final counterClockwiseState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );
      container.read(gameStateNotifierProvider.notifier).loadState(counterClockwiseState);
      await Future.delayed(Duration.zero);

      // First update to same state to set previousDirection
      container.read(gameStateNotifierProvider.notifier).updateState((state) => state.copyWith(
        currentPlayerIndex: 0, // Same state to initialize previousDirection
      ));
      await Future.delayed(Duration.zero);

      // Update to clockwise
      final clockwiseState = counterClockwiseState.copyWith(
        turnDirection: TurnDirection.clockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState((_) => clockwiseState);
      await Future.delayed(Duration.zero);

      // Should trigger animation with forward direction
      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.forward)).called(1);
    });

    test('should not trigger animation when direction stays the same', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).loadState(initialGameState);
      await Future.delayed(Duration.zero);

      // Update with same direction but different current player
      final sameDirectionState = initialGameState.copyWith(
        currentPlayerIndex: 1,
      );
      container.read(gameStateNotifierProvider.notifier).updateState((_) => sameDirectionState);
      await Future.delayed(Duration.zero);

      // Should not trigger animation
      verifyNever(() => mockAnimationNotifier.showDirectionChange(any()));
    });

    test('should handle multiple direction changes', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).loadState(initialGameState);
      await Future.delayed(Duration.zero);

      // First update to same state to set previousDirection
      container.read(gameStateNotifierProvider.notifier).updateState((state) => state.copyWith(
        currentPlayerIndex: 0, // Same state to initialize previousDirection
      ));
      await Future.delayed(Duration.zero);

      // First change: clockwise to counterclockwise
      final counterClockwiseState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState((_) => counterClockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.backward)).called(1);

      // Second change: back to clockwise
      final backToClockwiseState = counterClockwiseState.copyWith(
        turnDirection: TurnDirection.clockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState((_) => backToClockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.forward)).called(1);
    });

    test('should handle null previous state', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Directly update to a state (simulating initial load)
      container.read(gameStateNotifierProvider.notifier).loadState(initialGameState);
      await Future.delayed(Duration.zero);

      // Should not crash and should not trigger animation
      verifyNever(() => mockAnimationNotifier.showDirectionChange(any()));
    });

    test('should convert TurnDirection to PlayDirection correctly', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).loadState(initialGameState);
      await Future.delayed(Duration.zero);

      // First update to same state to set previousDirection
      container.read(gameStateNotifierProvider.notifier).updateState((state) => state.copyWith(
        currentPlayerIndex: 0, // Same state to initialize previousDirection
      ));
      await Future.delayed(Duration.zero);

      // Test clockwise to counterclockwise conversion
      final counterClockwiseState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState((_) => counterClockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.backward)).called(1);

      // Test counterclockwise to clockwise conversion
      final clockwiseState = counterClockwiseState.copyWith(
        turnDirection: TurnDirection.clockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState((_) => clockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.forward)).called(1);
    });
  });
}