import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/card_animation_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('CardAnimationWidget', () {
    late game.Card testCard;

    setUp(() {
      testCard = const game.Card(
        value: 5,
        isRevealed: true,
      );
    });

    testWidgets('should show card without animation initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CardAnimationWidget(
                card: testCard,
                child: CardWidget(card: testCard),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CardWidget), findsOneWidget);
      expect(find.text('5'), findsNWidgets(3)); // Card shows value 3 times
    });

    testWidgets('should animate teleport effect', (tester) async {
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

      // Start teleport animation
      animationKey.currentState!.animateTeleport();
      await tester.pump();

      // Should start animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();

      // Card should be fully visible again
      expect(find.byType(CardWidget), findsOneWidget);
    });

    testWidgets('should animate swap effect between two cards', (tester) async {
      final card1Key = GlobalKey<CardAnimationWidgetState>();
      final card2Key = GlobalKey<CardAnimationWidgetState>();
      final card2 = const game.Card(value: 8, isRevealed: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: CardAnimationWidget(
                      key: card1Key,
                      card: testCard,
                      child: CardWidget(card: testCard),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: CardAnimationWidget(
                      key: card2Key,
                      card: card2,
                      child: CardWidget(card: card2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Get positions before swap
      final card1Position = tester.getCenter(find.byKey(card1Key));
      final card2Position = tester.getCenter(find.byKey(card2Key));

      // Start swap animation
      card1Key.currentState!.animateSwapWith(card2Position);
      card2Key.currentState!.animateSwapWith(card1Position);
      await tester.pump();

      // Cards should be animating
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();

      // Cards should be back in their original visual positions
      // (actual swap is handled by game logic, not animation)
      expect(find.text('5'), findsWidgets);
      expect(find.text('8'), findsWidgets);
    });

    testWidgets('should animate reveal effect', (tester) async {
      final unrevealed = const game.Card(value: 7, isRevealed: false);
      final animationKey = GlobalKey<CardAnimationWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CardAnimationWidget(
                key: animationKey,
                card: unrevealed,
                child: CardWidget(card: unrevealed),
              ),
            ),
          ),
        ),
      );

      // Should show unrevealed card
      expect(find.byIcon(Icons.question_mark), findsOneWidget);

      // Start reveal animation
      animationKey.currentState!.animateReveal();
      await tester.pump();

      // Should show rotation animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should animate discard effect', (tester) async {
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

      // Start discard animation
      animationKey.currentState!.animateDiscard();
      await tester.pump();

      // Should start animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should animate bomb effect', (tester) async {
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

      // Start bomb animation
      animationKey.currentState!.animateBomb();
      await tester.pump();

      // Should show explosion effect (scale up then down)
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();
    });

    testWidgets('should animate peek effect', (tester) async {
      final animationKey = GlobalKey<CardAnimationWidgetState>();
      final unrevealed = const game.Card(value: 3, isRevealed: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CardAnimationWidget(
                key: animationKey,
                card: unrevealed,
                child: CardWidget(card: unrevealed),
              ),
            ),
          ),
        ),
      );

      // Start peek animation
      animationKey.currentState!.animatePeek();
      await tester.pump();

      // Should show partial flip animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      // Complete animation
      await tester.pumpAndSettle();

      // Card should still be unrevealed after peek
      expect(find.byIcon(Icons.question_mark), findsOneWidget);
    });

    testWidgets('should handle multiple animations in sequence', (tester) async {
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

      // Start first animation
      animationKey.currentState!.animateTeleport();
      await tester.pump(const Duration(milliseconds: 100));

      // Start second animation while first is running
      animationKey.currentState!.animateReveal();
      await tester.pump();

      // Should handle gracefully
      expect(find.byType(CardWidget), findsOneWidget);

      // Complete all animations
      await tester.pumpAndSettle();
    });

    testWidgets('should notify when animation completes', (tester) async {
      final animationKey = GlobalKey<CardAnimationWidgetState>();
      bool animationCompleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CardAnimationWidget(
                key: animationKey,
                card: testCard,
                onAnimationComplete: () {
                  animationCompleted = true;
                },
                child: CardWidget(card: testCard),
              ),
            ),
          ),
        ),
      );

      // Start animation
      animationKey.currentState!.animateTeleport();
      expect(animationCompleted, isFalse);

      // Complete animation
      await tester.pumpAndSettle();
      expect(animationCompleted, isTrue);
    });

    testWidgets('should apply custom animation duration', (tester) async {
      final animationKey = GlobalKey<CardAnimationWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CardAnimationWidget(
                key: animationKey,
                card: testCard,
                animationDuration: const Duration(milliseconds: 100),
                child: CardWidget(card: testCard),
              ),
            ),
          ),
        ),
      );

      // Start animation
      animationKey.currentState!.animateTeleport();
      await tester.pump();

      // Animation should still be running after 50ms
      await tester.pump(const Duration(milliseconds: 50));
      final fadeTransition = tester.widget<FadeTransition>(
        find.byType(FadeTransition).first,
      );
      expect(fadeTransition.opacity.value, lessThan(1.0));
      expect(fadeTransition.opacity.value, greaterThan(0.0));

      // Animation should complete after 100ms
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(); // One more frame to ensure completion
    });
  });
}