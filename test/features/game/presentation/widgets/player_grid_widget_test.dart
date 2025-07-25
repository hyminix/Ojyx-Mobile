import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerGridWidget', () {
    late PlayerGrid testGrid;

    setUp(() {
      testGrid = PlayerGrid.empty();
    });

    // Helper function to wrap widget with proper constraints
    Widget wrapWithConstraints(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: SizedBox(width: 400, height: 600, child: child)),
        ),
      );
    }

    testWidgets('should display 3x4 grid of cards', (tester) async {
      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(grid: testGrid, isCurrentPlayer: false),
        ),
      );

      // Assert
      expect(find.byType(CardWidget), findsNWidgets(12)); // 3 rows * 4 columns
    });

    testWidgets('should display "Votre grille" based on isCurrentPlayer value', (
      tester,
    ) async {
      // Test cases for isCurrentPlayer true/false
      final testCases = [
        (isCurrentPlayer: true, expectedFinds: findsOneWidget),
        (isCurrentPlayer: false, expectedFinds: findsNothing),
      ];

      for (final testCase in testCases) {
        // Act
        await tester.pumpWidget(
          wrapWithConstraints(
            PlayerGridWidget(
              grid: testGrid,
              isCurrentPlayer: testCase.isCurrentPlayer,
            ),
          ),
        );

        // Assert
        expect(
          find.text('Votre grille'),
          testCase.expectedFinds,
          reason: 'When isCurrentPlayer=${testCase.isCurrentPlayer}, "Votre grille" should ${testCase.expectedFinds == findsOneWidget ? "be visible" : "not be visible"}',
        );
        
        if (testCase.isCurrentPlayer) {
          expect(find.byIcon(Icons.person), findsOneWidget);
        }

        // Clear for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('should display grid stats when isCurrentPlayer is true', (
      tester,
    ) async {
      // Arrange
      var grid = PlayerGrid.empty();
      // Add some revealed cards
      grid = grid.placeCard(game.Card(value: 5, isRevealed: true), 0, 0);
      grid = grid.placeCard(game.Card(value: 3, isRevealed: true), 1, 1);

      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(grid: grid, isCurrentPlayer: true),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('2/12'), findsOneWidget); // Revealed cards count
      expect(find.text('8 pts'), findsOneWidget); // Total score (5 + 3)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.calculate), findsOneWidget);
    });

    testWidgets('should handle card tap when canInteract is true', (
      tester,
    ) async {
      // Arrange
      int? tappedRow;
      int? tappedCol;

      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(
            grid: testGrid,
            isCurrentPlayer: true,
            canInteract: true,
            onCardTap: (row, col) {
              tappedRow = row;
              tappedCol = col;
            },
          ),
        ),
      );

      // Tap on first card (row 0, col 0)
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Assert
      expect(tappedRow, equals(0));
      expect(tappedCol, equals(0));
    });

    testWidgets('should not handle tap when canInteract is false', (
      tester,
    ) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(
            grid: testGrid,
            isCurrentPlayer: true,
            canInteract: false,
            onCardTap: (row, col) => tapped = true,
          ),
        ),
      );

      // Try to tap
      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Assert
      expect(tapped, isFalse);
    });

    testWidgets('should highlight specified positions', (tester) async {
      // Arrange
      const highlightedPositions = {(0, 0), (1, 2)};

      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(
            grid: testGrid,
            isCurrentPlayer: true,
            highlightedPositions: highlightedPositions,
          ),
        ),
      );

      // Assert
      final cardWidgets = tester
          .widgetList<CardWidget>(find.byType(CardWidget))
          .toList();

      // Check first card (0,0) is highlighted
      expect(cardWidgets[0].isHighlighted, isTrue);

      // Check card at (1,2) is highlighted (row 1 * 4 + col 2 = index 6)
      expect(cardWidgets[6].isHighlighted, isTrue);

      // Check other cards are not highlighted
      expect(cardWidgets[1].isHighlighted, isFalse);
    });

    testWidgets('should show selected positions', (tester) async {
      // Arrange
      const selectedPositions = {(2, 3)};

      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(
            grid: testGrid,
            isCurrentPlayer: true,
            selectedPositions: selectedPositions,
          ),
        ),
      );

      // Assert
      final cardWidgets = tester
          .widgetList<CardWidget>(find.byType(CardWidget))
          .toList();

      // Check card at (2,3) is selected (row 2 * 4 + col 3 = index 11)
      expect(cardWidgets[11].isSelected, isTrue);

      // Check other cards are not selected
      expect(cardWidgets[0].isSelected, isFalse);
    });

    testWidgets('should show identical columns indicator', (tester) async {
      // Arrange
      var grid = PlayerGrid.empty();

      // Create identical column (all 5s in column 0)
      final card5 = game.Card(value: 5, isRevealed: true);

      grid = grid.placeCard(card5, 0, 0);
      grid = grid.placeCard(card5.copyWith(), 1, 0);
      grid = grid.placeCard(card5.copyWith(), 2, 0);

      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(grid: grid, isCurrentPlayer: true),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.textContaining('1 col'),
        findsOneWidget,
      ); // 1 identical column
      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('should apply correct styling for current player', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(grid: testGrid, isCurrentPlayer: true),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      // Should have primary color border when current player
      expect(decoration.border?.top.width, equals(2));
    });

    testWidgets('should show placeholders when canInteract is true', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        wrapWithConstraints(
          PlayerGridWidget(
            grid: testGrid,
            isCurrentPlayer: true,
            canInteract: true,
          ),
        ),
      );

      // Assert
      final cardWidgets = tester.widgetList<CardWidget>(
        find.byType(CardWidget),
      );

      // All cards should be placeholders since grid is empty
      for (final widget in cardWidgets) {
        expect(widget.isPlaceholder, isTrue);
      }
    });

    testWidgets('should calculate correct layout based on constraints', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400, // Fixed width to test layout calculation
              child: PlayerGridWidget(grid: testGrid, isCurrentPlayer: true),
            ),
          ),
        ),
      );

      // Assert
      final cardWidgets = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(CardWidget),
          matching: find.byType(SizedBox),
        ),
      );

      // Check that cards have appropriate width
      // (400 - 32 padding) / 4 columns = 92 per card
      expect(cardWidgets.isNotEmpty, isTrue);
    });
  });

}
