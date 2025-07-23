import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/enhanced_player_grid.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/visual_feedback_widget.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('EnhancedPlayerGrid', () {
    late Player testPlayer;
    late PlayerGrid testGrid;

    setUp(() {
      final cards = List.generate(
        12,
        (index) => game.Card(
          value: index,
          isRevealed: index < 2,
        ),
      );
      testGrid = PlayerGrid.fromCards(cards);
      testPlayer = Player(
        id: 'player-1',
        name: 'Test Player',
        grid: testGrid,
      );
    });

    testWidgets('should wrap PlayerGridWidget with enhanced features',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {},
              ),
            ),
          ),
        ),
      );

      // Should show the grid
      expect(find.byType(GridView), findsOneWidget);
      
      // Should have visual feedback wrappers for each card
      expect(find.byType(VisualFeedbackWidget), findsNWidgets(12));
    });

    testWidgets('should show tooltips with card values on hover',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {},
              ),
            ),
          ),
        ),
      );

      // Hover over a revealed card
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      
      // Find the first revealed card
      final firstCard = find.byType(CardWidget).first;
      await gesture.moveTo(tester.getCenter(firstCard));
      await tester.pump();

      // Wait for tooltip
      await tester.pump(const Duration(seconds: 1));

      // Should show tooltip with card value
      expect(find.text('Valeur: 0'), findsOneWidget);
    });

    testWidgets('should highlight valid selection targets', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should highlight selectable cards
      final cardWidgets = tester.widgetList<CardWidget>(find.byType(CardWidget));
      final highlightedCards = cardWidgets.where((card) => card.isHighlighted);
      expect(highlightedCards, isNotEmpty);
    });

    testWidgets('should animate card interactions', (tester) async {
      int tappedPosition = -1;
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {
                  tappedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // Tap on a card
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Should trigger tap callback
      expect(tappedPosition, equals(0));

      // Should show feedback animation
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should show success feedback on valid move', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {
                  // Simulate valid move
                },
                showSuccessFeedback: true,
              ),
            ),
          ),
        ),
      );

      // Tap on a card
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Should show success animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });

    testWidgets('should show error feedback on invalid move', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {
                  // Simulate invalid move
                },
                showErrorFeedback: true,
              ),
            ),
          ),
        ),
      );

      // Tap on a card
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Should show error animation
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.error), findsWidgets);
    });

    testWidgets('should pulse highlighted cards during selection',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {},
                enablePulseAnimation: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have pulsing animations
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should show ripple effect at tap location', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {},
                enableRippleEffect: true,
              ),
            ),
          ),
        ),
      );

      // Tap on a card
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Should show ripple animation
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should disable interactions for non-current player',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: false,
                onCardTap: (position) {},
              ),
            ),
          ),
        ),
      );

      // Should not have tooltips
      final feedbackWidgets = tester.widgetList<VisualFeedbackWidget>(
        find.byType(VisualFeedbackWidget),
      );
      expect(feedbackWidgets.every((w) => w.tooltip == null), isTrue);
    });

    testWidgets('should animate swap between two cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {
                  if (position == 1) {
                    // Trigger swap animation
                  }
                },
                animateSwap: true,
              ),
            ),
          ),
        ),
      );

      // Tap second card to swap
      final cards = find.byType(CardWidget);
      await tester.tap(cards.at(1));
      await tester.pump();

      // Should show swap animation
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should chain multiple feedback animations', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedPlayerGrid(
                player: testPlayer,
                isCurrentPlayer: true,
                onCardTap: (position) {},
                enableChainedAnimations: true,
              ),
            ),
          ),
        ),
      );

      // Tap on a card
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Should show multiple animations
      expect(find.byType(AnimatedBuilder), findsWidgets);
      
      await tester.pumpAndSettle();
    });
  });
}