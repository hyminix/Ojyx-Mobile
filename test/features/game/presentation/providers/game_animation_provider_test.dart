import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';

void main() {
  group('Game Animation Visual Feedback System', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should manage visual direction change feedback for competitive turn order awareness', () {
      // Test behavior: animation system provides clear visual feedback for strategic direction changes
      final notifier = container.read(gameAnimationProvider.notifier);
      
      // Initial state - no visual feedback active
      var state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, false, reason: 'Initial state should have no active visual feedback');
      expect(state.direction, PlayDirection.forward, reason: 'Default direction should be forward');
      
      // Strategic direction change triggers visual feedback
      notifier.showDirectionChange(PlayDirection.backward);
      state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, true, reason: 'Visual feedback should activate for strategic awareness');
      expect(state.direction, PlayDirection.backward, reason: 'Direction change should be visually communicated');
      
      // Visual feedback completion
      notifier.hideDirectionChange();
      state = container.read(gameAnimationProvider);
      expect(state.showingDirectionChange, false, reason: 'Visual feedback should complete gracefully');
      expect(state.direction, PlayDirection.backward, reason: 'Direction context should be preserved');
    });

    test('should enforce single-animation policy for clear visual communication', () {
      // Test behavior: prevent animation conflicts for clear player communication
      final notifier = container.read(gameAnimationProvider.notifier);
      
      // First strategic animation
      notifier.showDirectionChange(PlayDirection.forward);
      var state = container.read(gameAnimationProvider);
      expect(state.direction, PlayDirection.forward, reason: 'First animation should establish direction');
      
      // Attempted conflicting animation should be rejected
      notifier.showDirectionChange(PlayDirection.backward);
      state = container.read(gameAnimationProvider);
      expect(state.direction, PlayDirection.forward, reason: 'Original animation should have priority');
      expect(state.showingDirectionChange, true, reason: 'Animation conflict should not interrupt active feedback');
      
      // Sequential animations should work after completion
      notifier.hideDirectionChange();
      notifier.showDirectionChange(PlayDirection.backward);
      state = container.read(gameAnimationProvider);
      expect(state.direction, PlayDirection.backward, reason: 'Sequential animation should work after completion');
    });
  });
}
