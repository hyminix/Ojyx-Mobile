import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/common_area_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/draw_pile_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/discard_pile_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('CommonAreaWidget', () {
    const testCard = game.Card(value: 5, isRevealed: true);

    testWidgets('should display both draw and discard piles', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 30,
              topDiscardCard: testCard,
              isPlayerTurn: false,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(DrawPileWidget), findsOneWidget);
      expect(find.byType(DiscardPileWidget), findsOneWidget);
    });

    testWidgets('should arrange piles horizontally with spacing', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 20,
              topDiscardCard: null,
              isPlayerTurn: false,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Row), findsWidgets);
      // Check spacing between piles
      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    testWidgets('should show turn indicator when player turn', (tester) async {
      // Act
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

      // Assert
      expect(find.text('Votre tour'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('should not show turn indicator when not player turn', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 10,
              topDiscardCard: testCard,
              isPlayerTurn: false,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Votre tour'), findsNothing);
    });

    testWidgets('should handle draw card callback', (tester) async {
      // Arrange
      bool drawCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 25,
              topDiscardCard: null,
              isPlayerTurn: true,
              onDrawCard: () => drawCalled = true,
            ),
          ),
        ),
      );

      // Tap on draw pile
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert
      expect(drawCalled, isTrue);
    });

    testWidgets('should handle discard card callback', (tester) async {
      // Arrange
      game.Card? discardedCard;

      // Act
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

      // Simulate card drop by calling the callback directly
      const cardToDiscard = game.Card(value: 8, isRevealed: true);
      final discardPile = tester.widget<DiscardPileWidget>(
        find.byType(DiscardPileWidget),
      );
      expect(discardPile.onCardDropped, isNotNull);
      discardPile.onCardDropped!(cardToDiscard);

      // Assert
      expect(discardedCard, equals(cardToDiscard));
    });

    testWidgets('should show reshuffle indicator when draw pile empty', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 0,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () {},
              showReshuffleIndicator: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Mélange nécessaire'), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
    });

    testWidgets('should be responsive to different screen sizes', (
      tester,
    ) async {
      // Test on different screen sizes
      final sizes = [
        const Size(400, 800), // Phone
        const Size(800, 600), // Tablet landscape
        const Size(600, 1000), // Tablet portrait
      ];

      for (final size in sizes) {
        // Set screen size
        await tester.binding.setSurfaceSize(size);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CommonAreaWidget(
                drawPileCount: 52,
                topDiscardCard: testCard,
                isPlayerTurn: false,
                onDrawCard: () {},
              ),
            ),
          ),
        );

        // Assert - Should not overflow
        expect(find.byType(CommonAreaWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should animate turn changes', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 30,
              topDiscardCard: testCard,
              isPlayerTurn: false,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      // Act - Change to player turn
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 30,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('should have proper accessibility structure', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 40,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.bySemanticsLabel(RegExp(r'Zone commune')), findsOneWidget);
    });

    testWidgets('should show game info when provided', (tester) async {
      // Act
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

      // Assert
      expect(find.text('Tour de Alice'), findsOneWidget);
      expect(find.text('Manche 3'), findsOneWidget);
    });

    testWidgets('should disable interactions when game is paused', (
      tester,
    ) async {
      // Arrange
      bool drawCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonAreaWidget(
              drawPileCount: 20,
              topDiscardCard: testCard,
              isPlayerTurn: true,
              onDrawCard: () => drawCalled = true,
              isGamePaused: true,
            ),
          ),
        ),
      );

      // Try to tap draw pile
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert
      expect(drawCalled, isFalse);
      expect(find.text('Jeu en pause'), findsOneWidget);
    });
  });
}
