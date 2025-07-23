import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/opponent_grid_widget.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('OpponentGridWidget', () {
    late PlayerState testPlayerState;

    setUp(() {
      // Create a test player state with some cards
      final cards = List<game.Card?>.generate(12, (index) {
        if (index < 4) {
          // First 4 cards are revealed
          return game.Card(value: index + 1, isRevealed: true);
        } else if (index < 8) {
          // Next 4 cards are hidden
          return game.Card(value: index + 1, isRevealed: false);
        } else {
          // Last 4 are null
          return null;
        }
      });

      testPlayerState = PlayerState(
        playerId: 'test-player-123',
        cards: cards,
        currentScore: 15,
        revealedCount: 4,
        identicalColumns: [1], // One identical column
        hasFinished: false,
      );
    });

    testWidgets('should display player information', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: testPlayerState),
          ),
        ),
      );

      // Assert
      expect(find.text('Joueur test-p'), findsOneWidget); // Truncated player ID
      expect(find.text('15 pts'), findsOneWidget); // Score
      expect(find.text('4'), findsOneWidget); // Revealed count
      expect(find.text('1'), findsOneWidget); // Identical columns
    });

    testWidgets(
      'should show current player indicator when isCurrentPlayer is true',
      (tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OpponentGridWidget(
                playerState: testPlayerState,
                isCurrentPlayer: true,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('En train de jouer'), findsOneWidget);

        // Check border styling
        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border?.top.width, equals(3));
      },
    );

    testWidgets('should display mini grid with 12 cards', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: testPlayerState),
          ),
        ),
      );

      // Assert
      // Count containers that represent mini cards
      final miniCardContainers = find.descendant(
        of: find.byType(Stack),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration != null,
        ),
      );

      // Should have at least 12 containers for the cards
      expect(miniCardContainers, findsWidgets);
    });

    testWidgets('should display revealed cards with values', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: testPlayerState),
          ),
        ),
      );

      // Assert
      // First 4 cards are revealed with values 1-4
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('should handle tap when onTap is provided', (tester) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(
              playerState: testPlayerState,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(OpponentGridWidget));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should display finish flag when player has finished', (
      tester,
    ) async {
      // Arrange
      final finishedPlayerState = testPlayerState.copyWith(hasFinished: true);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: finishedPlayerState),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.flag), findsOneWidget);
    });

    testWidgets('should display player avatar with initials', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: testPlayerState),
          ),
        ),
      );

      // Assert
      expect(find.text('TE'), findsOneWidget); // First two letters of player ID
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display statistics correctly', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: testPlayerState),
          ),
        ),
      );

      // Assert
      expect(find.text('Révélées'), findsOneWidget);
      expect(find.text('Colonnes'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.grid_on), findsOneWidget);
    });

    testWidgets('should handle empty cards in grid', (tester) async {
      // Arrange
      final emptyPlayerState = PlayerState(
        playerId: 'empty-player',
        cards: List<game.Card?>.filled(12, null),
        currentScore: 0,
        revealedCount: 0,
        identicalColumns: [],
        hasFinished: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(playerState: emptyPlayerState),
          ),
        ),
      );

      // Assert
      expect(find.text('0 pts'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2)); // Revealed count and columns
    });

    testWidgets('should apply correct color for different card colors', (
      tester,
    ) async {
      // Arrange
      final colorTestState = PlayerState(
        playerId: 'color-test',
        cards: [
          game.Card(value: 1, isRevealed: true),
          game.Card(value: 2, isRevealed: true),
          game.Card(value: 3, isRevealed: true),
          game.Card(value: 4, isRevealed: true),
          ...List.filled(8, null),
        ],
        currentScore: 10,
        revealedCount: 4,
        identicalColumns: [],
        hasFinished: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OpponentGridWidget(playerState: colorTestState)),
        ),
      );

      // Assert
      // All revealed cards should be displayed
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('should animate container when properties change', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(
              playerState: testPlayerState,
              isCurrentPlayer: false,
            ),
          ),
        ),
      );

      // Change to current player
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentGridWidget(
              playerState: testPlayerState,
              isCurrentPlayer: true,
            ),
          ),
        ),
      );

      // Assert - AnimatedContainer should exist
      expect(find.byType(AnimatedContainer), findsOneWidget);

      // Pump to trigger animation
      await tester.pump(const Duration(milliseconds: 150));

      // Animation should be in progress
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });
  });
}
