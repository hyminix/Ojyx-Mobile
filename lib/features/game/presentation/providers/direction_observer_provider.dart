import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state_notifier.dart';
import 'game_animation_provider.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/play_direction.dart';

// Provider that observes direction changes and triggers animations
final directionObserverProvider = Provider<void>((ref) {
  TurnDirection? previousDirection;

  ref.listen(gameStateNotifierProvider, (previous, next) {
    if (previous != null && next != null) {
      // Check if direction has changed
      final prevDir = previous.turnDirection;
      final nextDir = next.turnDirection;

      if (prevDir != nextDir && previousDirection != null) {
        // Direction has changed - trigger animation
        // Convert TurnDirection to PlayDirection
        final playDirection = nextDir == TurnDirection.clockwise
            ? PlayDirection.forward
            : PlayDirection.backward;
        ref
            .read(gameAnimationProvider.notifier)
            .showDirectionChange(playDirection);
      }

      previousDirection = nextDir;
    }
  });
});
