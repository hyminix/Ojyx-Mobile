import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';

void main() {
  group('GameAnimationProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have initial state with no animation showing', () {
      // Act
      final state = container.read(gameAnimationProvider);

      // Assert
      expect(state.showingDirectionChange, isFalse);
      expect(state.direction, equals(PlayDirection.forward));
    });

    test('should show direction change animation when requested', () {
      // Arrange
      final notifier = container.read(gameAnimationProvider.notifier);

      // Act
      notifier.showDirectionChange(PlayDirection.backward);

      // Assert
      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, isTrue);
      expect(state.direction, equals(PlayDirection.backward));
    });

    test('should hide animation when hideDirectionChange is called', () {
      // Arrange
      final notifier = container.read(gameAnimationProvider.notifier);
      notifier.showDirectionChange(PlayDirection.forward);

      // Act
      notifier.hideDirectionChange();

      // Assert
      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, isFalse);
    });

    test('should not allow showing animation if already showing', () {
      // Arrange
      final notifier = container.read(gameAnimationProvider.notifier);
      notifier.showDirectionChange(PlayDirection.forward);

      // Act - Try to show another animation
      notifier.showDirectionChange(PlayDirection.backward);

      // Assert - Should still show first animation
      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, isTrue);
      expect(state.direction, equals(PlayDirection.forward));
    });

    test('should preserve direction when hiding animation', () {
      // Arrange
      final notifier = container.read(gameAnimationProvider.notifier);
      notifier.showDirectionChange(PlayDirection.backward);

      // Act
      notifier.hideDirectionChange();

      // Assert
      final state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, isFalse);
      expect(state.direction, equals(PlayDirection.backward));
    });

    test('should handle direction changes after hiding', () {
      // Arrange
      final notifier = container.read(gameAnimationProvider.notifier);

      // Act & Assert - Forward
      notifier.showDirectionChange(PlayDirection.forward);
      var state = container.read(gameAnimationProvider);
      expect(state.direction, equals(PlayDirection.forward));
      expect(state.showingDirectionChange, isTrue);

      // Hide and show different direction
      notifier.hideDirectionChange();
      notifier.showDirectionChange(PlayDirection.backward);
      
      state = container.read(gameAnimationProvider);
      expect(state.direction, equals(PlayDirection.backward));
      expect(state.showingDirectionChange, isTrue);
    });

    test('should notify listeners when state changes', () {
      // Arrange
      final notifier = container.read(gameAnimationProvider.notifier);
      var callCount = 0;
      final subscription = container.listen(gameAnimationProvider, (previous, next) {
        callCount++;
      });

      // Act
      notifier.showDirectionChange(PlayDirection.backward);
      notifier.hideDirectionChange();

      // Assert
      expect(callCount, equals(2)); // Show + Hide

      // Cleanup
      subscription.close();
    });
  });
}