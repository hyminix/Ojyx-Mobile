import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/common_area_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/draw_pile_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/discard_pile_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('CommonAreaWidget User Interactions', () {
    const testCard = game.Card(value: 5, isRevealed: true);

    testWidgets('should allow player to draw card during their turn', (
      tester,
    ) async {
      // Arrange
      bool cardDrawn = false;
      int drawCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 30,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () {
                cardDrawn = true;
                drawCount++;
              },
            ),
          ),
        ),
      );

      // Act - Player taps draw pile
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert - Card draw action was triggered
      expect(cardDrawn, isTrue);
      expect(drawCount, equals(1));
    });

    testWidgets('should prevent drawing when not player turn', (tester) async {
      // Arrange
      bool cardDrawn = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 30,
              topDiscardCard: testCard,
              isPlayerTurn: false, // Not player's turn
              onDrawCard: () => cardDrawn = true,
            ),
          ),
        ),
      );

      // Act - Try to tap draw pile
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert - Card draw should not be triggered
      expect(cardDrawn, isFalse);
    });

    testWidgets('should provide clear feedback about whose turn it is', (
      tester,
    ) async {
      // Test showing current player's turn
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 15,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      expect(find.text('Votre tour'), findsOneWidget);

      // Test showing other player's turn
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 15,
              topDiscardCard: testCard,
              isPlayerTurn: false,
              onDrawCard: () {},
              currentPlayerName: 'Alice',
            ),
          ),
        ),
      );

      expect(find.text('Tour de Alice'), findsOneWidget);
      expect(find.text('Votre tour'), findsNothing);
    });

    testWidgets('should accept discarded cards from player', (tester) async {
      // Arrange
      game.Card? discardedCard;
      const cardToDiscard = game.Card(value: 8, isRevealed: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 20,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () {},
              onDiscardCard: (card) => discardedCard = card,
              canDiscard: true,
            ),
          ),
        ),
      );

      // Act - Simulate player discarding a card
      final discardPile = tester.widget<DiscardPileWidget>(
        find.byType(DiscardPileWidget),
      );
      discardPile.onCardDropped!(cardToDiscard);

      // Assert - Card was discarded
      expect(discardedCard, equals(cardToDiscard));
      expect(discardedCard?.value, equals(8));
    });

    testWidgets('should handle empty draw pile and trigger reshuffle', (
      tester,
    ) async {
      // Arrange
      bool reshuffleRequested = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 0, // Empty draw pile
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () => reshuffleRequested = true,
              showReshuffleIndicator: true,
            ),
          ),
        ),
      );

      // Assert - Reshuffle indicator visible
      expect(find.text('Mélange nécessaire'), findsOneWidget);

      // Act - Player attempts to draw from empty pile
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert - Reshuffle was requested
      expect(reshuffleRequested, isTrue);
    });

    testWidgets('should block all interactions during game pause', (
      tester,
    ) async {
      // Arrange
      bool drawCalled = false;
      bool discardCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 20,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () => drawCalled = true,
              onDiscardCard: (_) => discardCalled = true,
              canDiscard: true,
              isGamePaused: true,
            ),
          ),
        ),
      );

      // Act - Try to interact while paused
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Try to discard
      final discardPile = tester.widget<DiscardPileWidget>(
        find.byType(DiscardPileWidget),
      );
      if (discardPile.onCardDropped != null) {
        discardPile.onCardDropped!(const game.Card(value: 3, isRevealed: true));
      }

      // Assert - No interactions should work
      expect(drawCalled, isFalse);
      expect(discardCalled, isFalse);
      expect(find.text('Jeu en pause'), findsOneWidget);
    });

    testWidgets('should show game progression info', (tester) async {
      // Act - Display game state information
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 35,
              topDiscardCard: testCard,
              isPlayerTurn: false,
              onDrawCard: () {},
              currentPlayerName: 'Alice',
              roundNumber: 3,
            ),
          ),
        ),
      );

      // Assert - Game info is visible
      expect(find.text('Tour de Alice'), findsOneWidget);
      expect(find.text('Manche 3'), findsOneWidget);
    });
  });
}
