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
import 'package:ojyx/features/game/domain/entities/grid_card.dart';
import 'package:ojyx/features/game/domain/entities/deck.dart';
import 'package:ojyx/features/game/domain/entities/game_card.dart';

class MockGameAnimationNotifier extends Mock implements GameAnimationNotifier {}

void main() {
  group('directionObserverProvider', () {
    late ProviderContainer container;
    late MockGameAnimationNotifier mockAnimationNotifier;
    late GameState initialGameState;
    late GameState updatedGameState;

    setUp(() {
      mockAnimationNotifier = MockGameAnimationNotifier();

      final mockPlayerGrid = PlayerGrid(
        cards: List.generate(12, (_) => const GridCard(value: 5)),
      );

      initialGameState = GameState(
        id: 'game123',
        roomId: 'room123',
        players: [
          GamePlayer(id: 'p1', name: 'Player 1', grid: mockPlayerGrid),
          GamePlayer(id: 'p2', name: 'Player 2', grid: mockPlayerGrid),
        ],
        currentPlayerIndex: 0,
        deck: const Deck(
          drawPile: [GameCard(value: 5, color: CardColor.red)],
          discardPile: [GameCard(value: 3, color: CardColor.blue)],
        ),
        turnDirection: TurnDirection.clockwise,
      );

      updatedGameState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );

      container = ProviderContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(() => GameStateNotifier()),
          gameAnimationProvider.overrideWith(() => mockAnimationNotifier),
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
      container.read(gameStateNotifierProvider.notifier).updateState(initialGameState);

      await Future.delayed(Duration.zero);

      verifyNever(() => mockAnimationNotifier.showDirectionChange(any()));
    });

    test('should trigger animation when direction changes from clockwise to counterclockwise', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).updateState(initialGameState);
      await Future.delayed(Duration.zero);

      // Update to state with different direction
      container.read(gameStateNotifierProvider.notifier).updateState(updatedGameState);
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
      container.read(gameStateNotifierProvider.notifier).updateState(counterClockwiseState);
      await Future.delayed(Duration.zero);

      // Update to clockwise
      final clockwiseState = counterClockwiseState.copyWith(
        turnDirection: TurnDirection.clockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState(clockwiseState);
      await Future.delayed(Duration.zero);

      // Should trigger animation with forward direction
      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.forward)).called(1);
    });

    test('should not trigger animation when direction stays the same', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).updateState(initialGameState);
      await Future.delayed(Duration.zero);

      // Update with same direction but different current player
      final sameDirectionState = initialGameState.copyWith(
        currentPlayerIndex: 1,
      );
      container.read(gameStateNotifierProvider.notifier).updateState(sameDirectionState);
      await Future.delayed(Duration.zero);

      // Should not trigger animation
      verifyNever(() => mockAnimationNotifier.showDirectionChange(any()));
    });

    test('should handle multiple direction changes', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).updateState(initialGameState);
      await Future.delayed(Duration.zero);

      // First change: clockwise to counterclockwise
      final counterClockwiseState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState(counterClockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.backward)).called(1);

      // Second change: back to clockwise
      final backToClockwiseState = counterClockwiseState.copyWith(
        turnDirection: TurnDirection.clockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState(backToClockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.forward)).called(1);
    });

    test('should handle null previous state', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Directly update to a state (simulating initial load)
      container.read(gameStateNotifierProvider.notifier).updateState(initialGameState);
      await Future.delayed(Duration.zero);

      // Should not crash and should not trigger animation
      verifyNever(() => mockAnimationNotifier.showDirectionChange(any()));
    });

    test('should convert TurnDirection to PlayDirection correctly', () async {
      // Initialize the observer
      container.read(directionObserverProvider);

      // Set initial state
      container.read(gameStateNotifierProvider.notifier).updateState(initialGameState);
      await Future.delayed(Duration.zero);

      // Test clockwise to counterclockwise conversion
      final counterClockwiseState = initialGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState(counterClockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.backward)).called(1);

      // Test counterclockwise to clockwise conversion
      final clockwiseState = counterClockwiseState.copyWith(
        turnDirection: TurnDirection.clockwise,
      );
      container.read(gameStateNotifierProvider.notifier).updateState(clockwiseState);
      await Future.delayed(Duration.zero);

      verify(() => mockAnimationNotifier.showDirectionChange(PlayDirection.forward)).called(1);
    });
  });
}