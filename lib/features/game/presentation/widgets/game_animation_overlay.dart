import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_animation_provider.dart';
import 'direction_change_animation.dart';

class GameAnimationOverlay extends ConsumerWidget {
  final Widget child;

  const GameAnimationOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationState = ref.watch(gameAnimationProvider);

    return Stack(
      children: [
        child,
        if (animationState.showingDirectionChange)
          Positioned.fill(
            child: DirectionChangeAnimation(
              direction: animationState.direction,
              onAnimationComplete: () {
                ref.read(gameAnimationProvider.notifier).hideDirectionChange();
              },
            ),
          ),
      ],
    );
  }
}
