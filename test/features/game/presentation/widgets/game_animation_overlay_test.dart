import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/game_animation_overlay.dart';
import 'package:ojyx/features/game/presentation/widgets/direction_change_animation.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import 'package:ojyx/features/game/presentation/providers/game_animation_provider.dart';

void main() {
  group('GameAnimationOverlay Strategic Visual Communication Behavior', () {
    testWidgets('should communicate strategic turn direction changes affecting all players', (
      tester,
    ) async {
      // Test behavior: direction changes impact strategic planning for all participants
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Container(color: Colors.blue),
                  const GameAnimationOverlay(
                    child: Center(child: Text('Strategic Game Board')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Strategic reversal action triggers animation
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.forward);
      await tester.pump();

      expect(find.byType(DirectionChangeAnimation), findsOneWidget,
          reason: 'Direction change animation communicates strategic shift to all players');
    });

    testWidgets('should maintain strategic gameplay visibility during normal play', (tester) async {
      // Test behavior: gameplay remains unobstructed without active animations
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const GameAnimationOverlay(
                    child: Center(child: Text('Strategic Game Board')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Strategic Game Board'), findsOneWidget,
          reason: 'Game board remains visible for continuous strategic planning');
      expect(find.byType(DirectionChangeAnimation), findsNothing,
          reason: 'No visual disruption during standard gameplay');
    });

    testWidgets('should ensure strategic communication completes before gameplay resumes', (tester) async {
      // Test behavior: animation lifecycle ensures all players see strategic changes
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const GameAnimationOverlay(
                    child: Center(child: Text('Strategic Game Board')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Strategic reversal affects turn order
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.backward);
      await tester.pump();

      expect(find.byType(DirectionChangeAnimation), findsOneWidget,
          reason: 'Strategic change notification active for all players');

      // Strategic communication completes
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(DirectionChangeAnimation), findsNothing,
          reason: 'Gameplay resumes after strategic communication completes');
    });

    testWidgets('should overlay strategic notifications without disrupting game state visibility', (tester) async {
      // Test behavior: critical game information remains visible during animations
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameAnimationOverlay(
                child: Container(
                  color: Colors.red,
                  child: const Center(child: Text('Active Game State')),
                ),
              ),
            ),
          ),
        ),
      );

      // Strategic action triggers overlay notification
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.forward);
      await tester.pump();

      // Both strategic state and notification visible
      expect(find.text('Active Game State'), findsOneWidget,
          reason: 'Game state remains visible for strategic continuity');
      expect(find.byType(DirectionChangeAnimation), findsOneWidget,
          reason: 'Strategic notification overlays without blocking');

      // Proper layering ensures visibility hierarchy
      final stack = tester.widget<Stack>(find.byType(Stack).first);
      expect(stack.children.length, equals(2),
          reason: 'Dual-layer system maintains game state and notifications');
      expect(stack.children.first, isA<Container>(),
          reason: 'Base layer preserves game state');
      expect(stack.children.last, isA<Positioned>(),
          reason: 'Overlay layer communicates strategic changes');
    });

    testWidgets('should manage rapid strategic actions preventing visual confusion', (
      tester,
    ) async {
      // Test behavior: system handles multiple strategic changes maintaining clarity
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const GameAnimationOverlay(
                child: Center(child: Text('Strategic Game Board')),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );

      // Rapid strategic reversals in competitive play
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.forward);
      await tester.pump();

      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.backward);
      await tester.pump();

      expect(find.byType(DirectionChangeAnimation), findsOneWidget,
          reason: 'Single clear notification prevents strategic confusion during rapid changes');
    });

    testWidgets('should accurately communicate strategic direction changes for turn planning', (tester) async {
      // Test behavior: precise direction communication enables strategic adaptation
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const GameAnimationOverlay(
                child: Center(child: Text('Strategic Game Board')),
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameAnimationOverlay)),
      );

      // Strategic reversal changes turn order
      container
          .read(gameAnimationProvider.notifier)
          .showDirectionChange(PlayDirection.backward);
      await tester.pump();

      // Verify accurate strategic information
      final animation = tester.widget<DirectionChangeAnimation>(
        find.byType(DirectionChangeAnimation),
      );
      expect(animation.direction, equals(PlayDirection.backward),
          reason: 'Accurate direction enables players to adapt turn strategies');
    });
  });
}
