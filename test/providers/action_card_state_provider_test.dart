import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/riverpod_test_helpers.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_state_provider.dart';

void main() {
  group('ActionCardStateNotifier (Modern Syntax)', () {
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
    });

    test('initial state should have correct values', () {
      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 37);
      expect(state.discardPileCount, 0);
      expect(state.isLoading, false);
    });

    test('should update draw pile count', () {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);
      notifier.updateCounts(drawPileCount: 25);

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 25);
      expect(state.discardPileCount, 0); // Unchanged
    });

    test('should update discard pile count', () {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);
      notifier.updateCounts(discardPileCount: 5);

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 37); // Unchanged
      expect(state.discardPileCount, 5);
    });

    test('should update both counts', () {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);
      notifier.updateCounts(drawPileCount: 20, discardPileCount: 17);

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 20);
      expect(state.discardPileCount, 17);
    });

    test('should set loading state', () {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);

      notifier.setLoading(true);
      expect(container.read(actionCardStateNotifierProvider).isLoading, true);

      notifier.setLoading(false);
      expect(container.read(actionCardStateNotifierProvider).isLoading, false);
    });

    test('should handle draw card action', () async {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);

      // Listen to state changes
      final states = <ActionCardState>[];
      final sub = container.listen(
        actionCardStateNotifierProvider,
        (_, state) => states.add(state),
      );

      await notifier.drawCard();

      // Verify state transitions
      expect(states.length, greaterThanOrEqualTo(2)); // Loading and final state

      final finalState = container.read(actionCardStateNotifierProvider);
      expect(finalState.drawPileCount, 36); // One card drawn
      expect(finalState.discardPileCount, 0);
      expect(finalState.isLoading, false);

      sub.close();
    });

    test('should not draw when pile is empty', () async {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);

      // Set draw pile to 0
      notifier.updateCounts(drawPileCount: 0);

      // Try to draw
      await notifier.drawCard();

      // Count should remain 0
      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 0);
    });

    test('should handle discard card action', () async {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);

      // Listen to state changes
      final states = <ActionCardState>[];
      final sub = container.listen(
        actionCardStateNotifierProvider,
        (_, state) => states.add(state),
      );

      await notifier.discardCard();

      // Verify state transitions
      expect(states.length, greaterThanOrEqualTo(2)); // Loading and final state

      final finalState = container.read(actionCardStateNotifierProvider);
      expect(finalState.drawPileCount, 37); // Unchanged
      expect(finalState.discardPileCount, 1); // One card discarded
      expect(finalState.isLoading, false);

      sub.close();
    });

    test('should reset counts', () {
      final notifier = container.read(actionCardStateNotifierProvider.notifier);

      // First change the counts
      notifier.updateCounts(drawPileCount: 10, discardPileCount: 27);

      // Then reset
      notifier.reset();

      final state = container.read(actionCardStateNotifierProvider);
      expect(state.drawPileCount, 37);
      expect(state.discardPileCount, 0);
      expect(state.isLoading, false);
    });

    test('auto-generated provider should be available', () {
      final provider = actionCardStateNotifierProvider;
      expect(provider, isNotNull);
      expect(
        provider
            is AutoDisposeNotifierProvider<
              ActionCardStateNotifier,
              ActionCardState
            >,
        true,
      );
    });
  });
}
