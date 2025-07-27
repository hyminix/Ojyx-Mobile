import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../helpers/riverpod_test_helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/providers/direction_observer_provider.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

class MockGameAnimation extends Mock implements GameAnimation {}

void main() {
  setUpAll(() {
    registerFallbackValue(PlayDirection.forward);
  });

  group('Direction Observer Game Flow Behavior', () {
    late ProviderContainer container;
    late MockGameAnimation mockAnimation;
    late GameState clockwiseState;
    late GameState counterClockwiseState;

    setUp(() {
      mockAnimation = MockGameAnimation();
      when(() => mockAnimation.showDirectionChange(any())).thenReturn(null);

      final mockPlayerGrid = PlayerGrid.empty();
      clockwiseState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'p1',
            name: 'Player 1',
            grid: mockPlayerGrid,
            actionCards: [],
          ),
          GamePlayer(
            id: 'p2',
            name: 'Player 2',
            grid: mockPlayerGrid,
            actionCards: [],
          ),
        ],
        currentPlayerIndex: 0,
        deck: [const Card(value: 5), const Card(value: 3)],
        discardPile: [const Card(value: 2)],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        createdAt: DateTime.now(),
      );

      counterClockwiseState = clockwiseState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );

      container = createTestContainer(
        overrides: [
          gameStateNotifierProvider.overrideWith(() => GameStateNotifier()),
          gameAnimationProvider.overrideWith(() => mockAnimation),
        ],
      );
    });

    test(
      'should provide visual feedback for strategic direction changes affecting player turn order',
      () async {
        // Test behavior: direction changes impact competitive turn sequence and require visual notification
        container.read(directionObserverProvider);

        // Establish baseline game flow
        container
            .read(gameStateNotifierProvider.notifier)
            .loadState(clockwiseState);
        await Future.delayed(Duration.zero);

        // Initialize direction tracking with neutral state change
        container
            .read(gameStateNotifierProvider.notifier)
            .updateState((state) => state.copyWith(currentPlayerIndex: 0));
        await Future.delayed(Duration.zero);

        // Strategic action triggers turn order reversal
        container
            .read(gameStateNotifierProvider.notifier)
            .updateState((_) => counterClockwiseState);
        await Future.delayed(Duration.zero);

        verify(
          () => mockAnimation.showDirectionChange(PlayDirection.backward),
        ).called(1);

        // Verify protection against redundant visual feedback
        container
            .read(gameStateNotifierProvider.notifier)
            .updateState(
              (state) =>
                  state.copyWith(currentPlayerIndex: 1), // Same direction
            );
        await Future.delayed(Duration.zero);

        verifyNever(
          () => mockAnimation.showDirectionChange(PlayDirection.backward),
        );
      },
    );

    test(
      'should track direction changes for competitive turn order management',
      () async {
        // Given: A game with direction observer active
        container.read(directionObserverProvider);

        // When: Direction changes from clockwise to counter-clockwise
        container
            .read(gameStateNotifierProvider.notifier)
            .loadState(clockwiseState);
        await Future.delayed(Duration.zero);

        container
            .read(gameStateNotifierProvider.notifier)
            .updateState((state) => state.copyWith(currentPlayerIndex: 0));
        await Future.delayed(Duration.zero);

        container
            .read(gameStateNotifierProvider.notifier)
            .updateState((_) => counterClockwiseState);
        await Future.delayed(Duration.zero);

        // Then: Direction change is detected and notified
        verify(
          () => mockAnimation.showDirectionChange(PlayDirection.backward),
        ).called(1);

        // When: Direction changes back to clockwise
        container
            .read(gameStateNotifierProvider.notifier)
            .updateState((_) => clockwiseState);
        await Future.delayed(Duration.zero);

        // Then: Return to normal flow is detected
        verify(
          () => mockAnimation.showDirectionChange(PlayDirection.forward),
        ).called(1);
      },
    );
  });
}
