import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';

void main() {
  group('GameAnimationProvider V2 (Modern Syntax)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should have correct default values', () {
      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, false);
      expect(state.direction, PlayDirection.forward);
    });

    test('should show direction change with forward direction', () {
      final notifier = container.read(gameAnimationProvider.notifier);
      notifier.showDirectionChange(PlayDirection.forward);

      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, true);
      expect(state.direction, PlayDirection.forward);
    });

    test('should show direction change with backward direction', () {
      final notifier = container.read(gameAnimationProvider.notifier);
      notifier.showDirectionChange(PlayDirection.backward);

      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, true);
      expect(state.direction, PlayDirection.backward);
    });

    test('should not update if already showing direction change', () {
      final notifier = container.read(gameAnimationProvider.notifier);

      // First show forward direction
      notifier.showDirectionChange(PlayDirection.forward);

      var state = container.read(gameAnimationProvider);
      expect(state.direction, PlayDirection.forward);

      // Try to show backward while already showing
      notifier.showDirectionChange(PlayDirection.backward);

      // Direction should not change
      state = container.read(gameAnimationProvider);
      expect(state.direction, PlayDirection.forward);
      expect(state.showingDirectionChange, true);
    });

    test('should hide direction change', () {
      final notifier = container.read(gameAnimationProvider.notifier);

      // First show direction change
      notifier.showDirectionChange(PlayDirection.backward);
      expect(
        container.read(gameAnimationProvider).showingDirectionChange,
        true,
      );

      // Then hide it
      notifier.hideDirectionChange();

      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, false);
      expect(state.direction, PlayDirection.backward); // Direction preserved
    });

    test('should handle show-hide-show sequence', () {
      final notifier = container.read(gameAnimationProvider.notifier);

      // Show forward
      notifier.showDirectionChange(PlayDirection.forward);
      expect(
        container.read(gameAnimationProvider).showingDirectionChange,
        true,
      );
      expect(
        container.read(gameAnimationProvider).direction,
        PlayDirection.forward,
      );

      // Hide
      notifier.hideDirectionChange();
      expect(
        container.read(gameAnimationProvider).showingDirectionChange,
        false,
      );

      // Show backward
      notifier.showDirectionChange(PlayDirection.backward);
      expect(
        container.read(gameAnimationProvider).showingDirectionChange,
        true,
      );
      expect(
        container.read(gameAnimationProvider).direction,
        PlayDirection.backward,
      );
    });

    test('auto-generated provider should be available', () {
      final provider = gameAnimationProvider;
      expect(provider, isNotNull);
      expect(
        provider
            is AutoDisposeNotifierProvider<GameAnimation, GameAnimationState>,
        true,
      );
    });
  });
}
