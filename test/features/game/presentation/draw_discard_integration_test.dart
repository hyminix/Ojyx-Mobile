import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/common_area_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/draw_pile_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/discard_pile_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/entities/deck_state.dart';

void main() {
  group('Draw/Discard Integration Tests', () {
    testWidgets('should handle complete draw and discard flow', (tester) async {
      // Arrange
      var deckState = DeckState(
        drawPile: List.generate(10, (i) => game.Card(value: i, isRevealed: false)),
        discardPile: [const game.Card(value: 5, isRevealed: true)],
      );
      
      game.Card? lastDrawnCard;
      game.Card? lastDiscardedCard;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CommonAreaWidget(
                  drawPileCount: deckState.drawPile.length,
                  topDiscardCard: deckState.topDiscardCard,
                  isPlayerTurn: true,
                  onDrawCard: () {
                    final (newState, drawnCard) = deckState.drawCard();
                    if (drawnCard != null) {
                      setState(() {
                        deckState = newState;
                        lastDrawnCard = drawnCard;
                      });
                    }
                  },
                  onDiscardCard: (card) {
                    setState(() {
                      deckState = deckState.discardCard(card);
                      lastDiscardedCard = card;
                    });
                  },
                  canDiscard: lastDrawnCard != null,
                );
              },
            ),
          ),
        ),
      );

      // Assert initial state
      expect(find.text('10'), findsOneWidget); // Draw pile count
      expect(find.text('5'), findsWidgets); // Top discard card

      // Draw a card
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pumpAndSettle();

      // Verify draw
      expect(lastDrawnCard, isNotNull);
      expect(lastDrawnCard!.value, equals(0)); // First card in draw pile
      expect(find.text('9'), findsOneWidget); // Updated draw pile count

      // Discard the drawn card
      const cardToDiscard = game.Card(value: 0, isRevealed: true);
      final discardPile = tester.widget<DiscardPileWidget>(find.byType(DiscardPileWidget));
      expect(discardPile.onCardDropped, isNotNull);
      discardPile.onCardDropped!(cardToDiscard);
      await tester.pumpAndSettle();

      // Verify discard
      expect(lastDiscardedCard, equals(cardToDiscard));
      expect(deckState.topDiscardCard?.value, equals(0));
    });

    testWidgets('should handle reshuffle when draw pile is empty', (tester) async {
      // Arrange
      var deckState = DeckState(
        drawPile: const [],
        discardPile: List.generate(5, (i) => game.Card(value: i, isRevealed: true)),
      );
      
      bool reshuffleTriggered = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CommonAreaWidget(
                  drawPileCount: deckState.drawPile.length,
                  topDiscardCard: deckState.topDiscardCard,
                  isPlayerTurn: true,
                  showReshuffleIndicator: deckState.isDrawPileEmpty,
                  onDrawCard: () {
                    setState(() {
                      if (deckState.isDrawPileEmpty && deckState.discardPile.length > 1) {
                        deckState = deckState.reshuffleDiscardIntoDraw();
                        reshuffleTriggered = true;
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Assert initial empty state
      expect(find.text('0'), findsOneWidget); // Empty draw pile
      expect(find.text('Mélange nécessaire'), findsOneWidget);

      // Trigger reshuffle
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pumpAndSettle();

      // Verify reshuffle
      expect(reshuffleTriggered, isTrue);
      expect(deckState.drawPile.length, equals(4)); // All but top discard
      expect(deckState.discardPile.length, equals(1)); // Only top card remains
    });

    testWidgets('should prevent actions when not player turn', (tester) async {
      // Arrange
      bool actionTriggered = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 20,
              topDiscardCard: const game.Card(value: 7, isRevealed: true),
              isPlayerTurn: false,
              onDrawCard: () => actionTriggered = true,
              onDiscardCard: (card) => actionTriggered = true,
            ),
          ),
        ),
      );

      // Try to draw
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert
      expect(actionTriggered, isFalse);
    });

    testWidgets('should show proper animations during card transitions', (tester) async {
      // Arrange
      const initialCard = game.Card(value: 3, isRevealed: true);
      const newCard = game.Card(value: 8, isRevealed: true);
      var currentCard = initialCard;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CommonAreaWidget(
                  drawPileCount: 15,
                  topDiscardCard: currentCard,
                  isPlayerTurn: true,
                  onDrawCard: () {},
                  onDiscardCard: (card) {
                    setState(() {
                      currentCard = newCard;
                    });
                  },
                  canDiscard: true,
                );
              },
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('3'), findsWidgets);

      // Trigger discard with new card
      final discardPile = tester.widget<DiscardPileWidget>(find.byType(DiscardPileWidget));
      expect(discardPile.onCardDropped, isNotNull);
      discardPile.onCardDropped!(newCard);
      
      // Pump a few frames to see animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      
      // Animation in progress
      expect(find.byType(AnimatedSwitcher), findsWidgets);
      
      // Complete animation
      await tester.pumpAndSettle();
      
      // Verify new state
      expect(find.text('8'), findsWidgets);
      expect(find.text('3'), findsNothing);
    });

    testWidgets('should update UI correctly after multiple operations', (tester) async {
      // Arrange
      var deckState = DeckState(
        drawPile: List.generate(5, (i) => game.Card(value: i * 2, isRevealed: false)),
        discardPile: [const game.Card(value: 1, isRevealed: true)],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CommonAreaWidget(
                  drawPileCount: deckState.drawPile.length,
                  topDiscardCard: deckState.topDiscardCard,
                  isPlayerTurn: true,
                  onDrawCard: () {
                    final (newState, drawnCard) = deckState.drawCard();
                    setState(() {
                      deckState = newState;
                    });
                  },
                  onDiscardCard: (card) {
                    setState(() {
                      deckState = deckState.discardCard(card);
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Perform multiple draws
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(DrawPileWidget));
        await tester.pumpAndSettle();
      }

      // Verify state after multiple operations
      expect(find.text('2'), findsOneWidget); // 5 - 3 = 2 cards left
      expect(deckState.drawPile.length, equals(2));
    });
  });
}