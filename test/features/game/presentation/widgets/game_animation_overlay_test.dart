import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/game_animation_overlay.dart';
import 'package:ojyx/features/game/presentation/widgets/direction_change_animation.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider.dart';

void main() {
  group('GameAnimationOverlay', () {
    testWidgets('should show direction change animation when triggered', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Container(color: Colors.blue),
                  const GameAnimationOverlay(
                    child: Center(child: Text('Game Content')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Trigger animation
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.forward);
      await tester.pump();

      // Assert
      expect(find.byType(DirectionChangeAnimation), findsOneWidget);
    });

    testWidgets('should show game content when no animation', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const GameAnimationOverlay(
                    child: Center(child: Text('Game Content')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Game Content'), findsOneWidget);
      expect(find.byType(DirectionChangeAnimation), findsNothing);
    });

    testWidgets('should remove animation after completion', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const GameAnimationOverlay(
                    child: Center(child: Text('Game Content')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Trigger animation
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.backward);
      await tester.pump();

      // Animation should be visible
      expect(find.byType(DirectionChangeAnimation), findsOneWidget);

      // Wait for animation to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Animation should be gone
      expect(find.byType(DirectionChangeAnimation), findsNothing);
    });

    testWidgets('should stack animations on top of content', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameAnimationOverlay(
                child: Container(
                  color: Colors.red,
                  child: const Center(child: Text('Game Content')),
                ),
              ),
            ),
          ),
        ),
      );

      // Trigger animation
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.forward);
      await tester.pump();

      // Assert - Both content and animation should be visible
      expect(find.text('Game Content'), findsOneWidget);
      expect(find.byType(DirectionChangeAnimation), findsOneWidget);

      // Animation should be on top (later in the widget tree)
      final stack = tester.widget<Stack>(find.byType(Stack).first);
      expect(stack.children.length, equals(2));
      expect(stack.children.first, isA<Container>());
      expect(stack.children.last, isA<Positioned>());
    });

    testWidgets('should handle multiple animation requests gracefully', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const GameAnimationOverlay(
                child: Center(child: Text('Game Content')),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );

      // Trigger multiple animations quickly
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.forward);
      await tester.pump();

      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.backward);
      await tester.pump();

      // Should still only show one animation
      expect(find.byType(DirectionChangeAnimation), findsOneWidget);
    });

    testWidgets('should pass correct direction to animation', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const GameAnimationOverlay(
                child: Center(child: Text('Game Content')),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );

      // Trigger with backward direction
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.backward);
      await tester.pump();

      // Check the animation has correct direction
      final animation = tester.widget<DirectionChangeAnimation>(
        find.byType(DirectionChangeAnimation),
      );
      expect(animation.direction, equals(PlayDirection.backward));
    });
  });
}
