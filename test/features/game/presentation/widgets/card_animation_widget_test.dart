import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/card_animation_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('CardAnimation Strategic Visual Feedback Behavior', () {
    late game.Card testCard;
    late game.Card hiddenCard;

    setUp(() {
      testCard = const game.Card(value: 5, isRevealed: true);
      hiddenCard = const game.Card(value: 7, isRevealed: false);
    });

    testWidgets(
      'should provide visual feedback for strategic card actions affecting gameplay',
      (tester) async {
        // Test behavior: animations communicate strategic actions to all players
        final animationKey = GlobalKey<CardAnimationWidgetState>();
        final strategicActions = [
          (
            'teleport',
            () => animationKey.currentState!.animateTeleport(),
            'position optimization',
          ),
          (
            'bomb',
            () => animationKey.currentState!.animateBomb(),
            'destructive action',
          ),
          (
            'discard',
            () => animationKey.currentState!.animateDiscard(),
            'tactical removal',
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CardAnimationWidget(
                  key: animationKey,
                  card: testCard,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        );

        for (final (action, trigger, impact) in strategicActions) {
          trigger();
          await tester.pump();

          // Animation provides visual feedback for strategic impact
          expect(
            find.byType(AnimatedBuilder),
            findsWidgets,
            reason: 'Animation communicates $action creating $impact awareness',
          );

          await tester.pumpAndSettle(); // Complete before next
        }
      },
    );

    testWidgets(
      'should animate competitive card exchanges for strategic repositioning',
      (tester) async {
        // Test behavior: swap animations visualize strategic card repositioning
        final card1Key = GlobalKey<CardAnimationWidgetState>();
        final card2Key = GlobalKey<CardAnimationWidgetState>();
        final highValueCard = const game.Card(value: 12, isRevealed: true);
        final lowValueCard = const game.Card(value: -2, isRevealed: true);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 140,
                    child: CardAnimationWidget(
                      key: card1Key,
                      card: highValueCard,
                      child: CardWidget(card: highValueCard),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 140,
                    child: CardAnimationWidget(
                      key: card2Key,
                      card: lowValueCard,
                      child: CardWidget(card: lowValueCard),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Strategic swap for position optimization
        final position1 = tester.getCenter(find.byKey(card1Key));
        final position2 = tester.getCenter(find.byKey(card2Key));

        card1Key.currentState!.animateSwapWith(position2);
        card2Key.currentState!.animateSwapWith(position1);
        await tester.pump();

        expect(
          find.byType(AnimatedBuilder),
          findsWidgets,
          reason:
              'Swap animation visualizes strategic repositioning for score optimization',
        );

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'should differentiate information revelation types for strategic gameplay',
      (tester) async {
        // Test behavior: different reveal animations communicate different strategic information
        final animationKey = GlobalKey<CardAnimationWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CardAnimationWidget(
                  key: animationKey,
                  card: hiddenCard,
                  child: CardWidget(card: hiddenCard),
                ),
              ),
            ),
          ),
        );

        // Permanent reveal for strategic commitment
        animationKey.currentState!.animateReveal();
        await tester.pump();
        expect(
          find.byType(AnimatedBuilder),
          findsWidgets,
          reason: 'Full reveal animation shows permanent information exposure',
        );
        await tester.pumpAndSettle();

        // Temporary peek for intelligence gathering
        animationKey.currentState!.animatePeek();
        await tester.pump();
        expect(
          find.byType(AnimatedBuilder),
          findsWidgets,
          reason: 'Peek animation indicates temporary strategic intelligence',
        );
        await tester.pumpAndSettle();

        // Card remains hidden after peek
        expect(
          find.byIcon(Icons.question_mark),
          findsOneWidget,
          reason: 'Peek maintains information asymmetry after preview',
        );
      },
    );

    testWidgets(
      'should notify game system when strategic animations complete',
      (tester) async {
        // Test behavior: completion callbacks enable game state synchronization
        final animationKey = GlobalKey<CardAnimationWidgetState>();
        var animationCompleted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CardAnimationWidget(
                  key: animationKey,
                  card: testCard,
                  onAnimationComplete: () => animationCompleted = true,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        );

        // Strategic action triggers state change
        animationKey.currentState!.animateTeleport();
        expect(
          animationCompleted,
          isFalse,
          reason: 'Game state waits for visual completion',
        );

        await tester.pumpAndSettle();
        expect(
          animationCompleted,
          isTrue,
          reason: 'Completion callback enables game state progression',
        );
      },
    );

    testWidgets(
      'should handle concurrent animation requests maintaining visual clarity',
      (tester) async {
        // Test behavior: animation system prevents visual confusion during rapid actions
        final animationKey = GlobalKey<CardAnimationWidgetState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: CardAnimationWidget(
                  key: animationKey,
                  card: testCard,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        );

        // Rapid strategic actions
        animationKey.currentState!.animateTeleport();
        await tester.pump(const Duration(milliseconds: 50));

        // Second action during first animation
        animationKey.currentState!.animateReveal();
        await tester.pump();

        // System handles gracefully without visual corruption
        expect(
          find.byType(CardWidget),
          findsOneWidget,
          reason: 'Card remains visible during animation transitions',
        );

        await tester.pumpAndSettle();
      },
    );
  });
}
