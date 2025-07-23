import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/deck_and_discard_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

class MockPlayer extends Mock implements Player {}

void main() {
  group('DeckAndDiscardWidget', () {
    late GameState mockGameState;
    late Player mockPlayer;

    setUp(() {
      mockPlayer = MockPlayer();
      when(() => mockPlayer.id).thenReturn('player-id');
      when(() => mockPlayer.name).thenReturn('Test Player');
      when(() => mockPlayer.grid).thenReturn(PlayerGrid.empty());
      when(() => mockPlayer.isHost).thenReturn(true);

      mockGameState = GameState.initial(
        roomId: 'test-room',
        players: [mockPlayer],
      );
    });

    testWidgets('should display deck and discard pile', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(
              gameState: mockGameState,
              canDraw: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Pioche'), findsOneWidget);
      expect(find.text('Défausse'), findsOneWidget);
      expect(
        find.byIcon(Icons.arrow_forward),
        findsOneWidget,
      ); // Arrow between deck and discard
    });

    testWidgets('should show top discard card when available', (tester) async {
      // Arrange
      const discardCard = game.Card(value: 7, isRevealed: true);

      final gameState = mockGameState.copyWith(discardPile: [discardCard]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(gameState: gameState, canDraw: false),
          ),
        ),
      );

      // Assert
      expect(find.byType(CardWidget), findsNWidgets(2)); // Deck + discard
      final discardWidget = tester.widget<CardWidget>(
        find.byType(CardWidget).last,
      );
      expect(discardWidget.card, equals(discardCard));
    });

    testWidgets('should show empty discard pile', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(discardPile: []);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(gameState: gameState, canDraw: false),
          ),
        ),
      );

      // Assert
      expect(find.text('Vide'), findsOneWidget);
    });

    testWidgets('should handle deck tap when canDraw is true', (tester) async {
      // Arrange
      bool deckTapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(
              gameState: mockGameState,
              canDraw: true,
              onDrawFromDeck: () => deckTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Assert
      expect(deckTapped, isTrue);
    });

    testWidgets('should handle discard tap when canDraw is true', (
      tester,
    ) async {
      // Arrange
      bool discardTapped = false;
      const discardCard = game.Card(value: 5, isRevealed: true);

      final gameState = mockGameState.copyWith(discardPile: [discardCard]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(
              gameState: gameState,
              canDraw: true,
              onDrawFromDiscard: () => discardTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CardWidget).last);
      await tester.pump();

      // Assert
      expect(discardTapped, isTrue);
    });

    testWidgets('should not handle taps when interaction disabled', (
      tester,
    ) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(
              gameState: mockGameState,
              canDraw: false,
              onDrawFromDeck: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CardWidget).first);
      await tester.pump();

      // Assert
      expect(tapped, isFalse);
    });

    testWidgets('should highlight deck when canDraw is true', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(gameState: mockGameState, canDraw: true),
          ),
        ),
      );

      // Assert
      // When canDraw is true, the deck should show a touch_app icon
      expect(
        find.byIcon(Icons.touch_app),
        findsOneWidget,
      ); // Only deck shows icon (discard is empty)
    });

    testWidgets('should highlight discard when canDraw is true', (
      tester,
    ) async {
      // Arrange
      const discardCard = game.Card(value: 3, isRevealed: true);

      final gameState = mockGameState.copyWith(discardPile: [discardCard]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(gameState: gameState, canDraw: true),
          ),
        ),
      );

      // Assert
      // When canDraw is true, both deck and discard should show touch_app icons
      expect(
        find.byIcon(Icons.touch_app),
        findsNWidgets(2),
      ); // One for deck, one for discard
    });

    testWidgets('should display remaining cards count', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(
        deck: List.generate(
          25,
          (i) => game.Card(value: i % 13, isRevealed: false),
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(gameState: gameState, canDraw: false),
          ),
        ),
      );

      // Assert
      expect(find.text('25 cartes'), findsOneWidget);
    });
  });
}
