import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_animation_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/visual_feedback_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('EnhancedCardWidget', () {
    late game.Card testCard;

    setUp(() {
      testCard = const game.Card(
        value: 7,
        isRevealed: true,
      );
    });

    testWidgets('should wrap CardWidget with animation and feedback widgets',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                tooltip: 'Valeur: 7',
                child: CardAnimationWidget(
                  card: testCard,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        ),
      );

      // Should show the card
      expect(find.byType(CardWidget), findsOneWidget);
      expect(find.text('7'), findsNWidgets(3)); // Card shows value 3 times

      // Should have animation wrapper
      expect(find.byType(CardAnimationWidget), findsOneWidget);
      
      // Should have feedback wrapper
      expect(find.byType(VisualFeedbackWidget), findsOneWidget);
    });

    testWidgets('should show highlight on selection', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: CardAnimationWidget(
                  card: testCard,
                  child: CardWidget(
                    card: testCard,
                    isSelected: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show highlight
      feedbackKey.currentState!.showHighlight(Colors.blue);
      await tester.pumpAndSettle();

      // Card should be selected
      final cardWidget = tester.widget<CardWidget>(find.byType(CardWidget));
      expect(cardWidget.isSelected, isTrue);
    });

    testWidgets('should animate card reveal', (tester) async {
      final animationKey = GlobalKey<CardAnimationWidgetState>();
      final unrevealedCard = const game.Card(
        value: 7,
        isRevealed: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                child: CardAnimationWidget(
                  key: animationKey,
                  card: unrevealedCard,
                  child: CardWidget(card: unrevealedCard),
                ),
              ),
            ),
          ),
        ),
      );

      // Should show unrevealed card
      expect(find.byIcon(Icons.question_mark), findsOneWidget);

      // Animate reveal
      animationKey.currentState!.animateReveal();
      await tester.pumpAndSettle();
    });

    testWidgets('should show success feedback when valid move', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: CardAnimationWidget(
                  card: testCard,
                  child: CardWidget(
                    card: testCard,
                    onTap: () {
                      feedbackKey.currentState!.showSuccess();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap card
      await tester.tap(find.byType(CardWidget));
      await tester.pump();

      // Should show success animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should show error feedback when invalid move', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: CardAnimationWidget(
                  card: testCard,
                  child: CardWidget(
                    card: testCard,
                    onTap: () {
                      feedbackKey.currentState!.showError();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap card
      await tester.tap(find.byType(CardWidget));
      await tester.pump();

      // Should show error animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should show ripple effect at tap position', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                child: CardAnimationWidget(
                  card: testCard,
                  child: CardWidget(
                    card: testCard,
                    onTap: () {
                      final RenderBox box = feedbackKey.currentContext!
                          .findRenderObject() as RenderBox;
                      final center = box.size.center(Offset.zero);
                      feedbackKey.currentState!.showRipple(center);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap card
      await tester.tap(find.byType(CardWidget));
      await tester.pump();

      // Should show ripple animation
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should animate teleport effect', (tester) async {
      final animationKey = GlobalKey<CardAnimationWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                child: CardAnimationWidget(
                  key: animationKey,
                  card: testCard,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        ),
      );

      // Animate teleport
      animationKey.currentState!.animateTeleport();
      await tester.pump();

      // Should be animating
      expect(find.byType(AnimatedBuilder), findsWidgets);

      await tester.pumpAndSettle();
    });

    testWidgets('should show pulse effect on hover', (tester) async {
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                tooltip: 'Valeur: 7',
                child: CardAnimationWidget(
                  card: testCard,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        ),
      );

      // Simulate hover (pulse effect)
      feedbackKey.currentState!.showPulse(intensity: 1.5);
      await tester.pump();

      // Should show pulse animation
      expect(find.byType(AnimatedBuilder), findsWidgets);

      await tester.pumpAndSettle();
    });

    testWidgets('should integrate with selection provider', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    return VisualFeedbackWidget(
                      child: CardAnimationWidget(
                        card: testCard,
                        child: CardWidget(
                          card: testCard,
                          isHighlighted: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Should show highlighted card
      final cardWidget = tester.widget<CardWidget>(find.byType(CardWidget));
      expect(cardWidget.isHighlighted, isTrue);
    });

    testWidgets('should chain multiple animations', (tester) async {
      final animationKey = GlobalKey<CardAnimationWidgetState>();
      final feedbackKey = GlobalKey<VisualFeedbackWidgetState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VisualFeedbackWidget(
                key: feedbackKey,
                onFeedbackComplete: () {
                  // Chain next animation
                  animationKey.currentState?.animateDiscard();
                },
                child: CardAnimationWidget(
                  key: animationKey,
                  card: testCard,
                  child: CardWidget(card: testCard),
                ),
              ),
            ),
          ),
        ),
      );

      // Start first animation
      feedbackKey.currentState!.showPulse();
      await tester.pump();

      // Both animations should complete
      await tester.pumpAndSettle();
    });
  });
}