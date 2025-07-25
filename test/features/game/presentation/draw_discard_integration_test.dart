import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/common_area_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/draw_pile_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/discard_pile_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';

class MockGameStateNotifier extends Mock implements GameStateNotifier {}

void main() {
  group('Draw/Discard Integration Tests', () {
    late MockGameStateNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockGameStateNotifier();
    });
    
    setUpAll(() {
      registerFallbackValue(const game.Card(value: 0, isRevealed: false));
    });

    testWidgets('should trigger draw action when player taps draw pile', (tester) async {
      // Arrange: Mock the game state to simulate behavior
      final initialDeckState = DeckState(
        drawPile: List.generate(10, (i) => game.Card(value: i, isRevealed: false)),
        discardPile: [const game.Card(value: 5, isRevealed: true)],
      );

      // Act: Render widget with mocked provider
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override provider with mock for isolated testing
            gameStateNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CommonAreaWidget(
                drawPileCount: initialDeckState.drawPile.length,
                topDiscardCard: initialDeckState.topDiscardCard,
                isPlayerTurn: true,
                onDrawCard: () => mockNotifier.drawFromDeck('player1'),
                onDiscardCard: (card) => mockNotifier.discardCard('player1', 0),
                canDiscard: false,
              ),
            ),
          ),
        ),
      );

      // Assert initial state behavior
      expect(find.text('10'), findsOneWidget, reason: 'Should display correct draw pile count');
      expect(find.text('5'), findsWidgets, reason: 'Should display top discard card value');

      // Trigger draw action behavior
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pumpAndSettle();

      // Verify draw behavior was triggered
      verify(() => mockNotifier.drawFromDeck('player1')).called(1);
    });

    testWidgets('should trigger reshuffle action when draw pile is empty', (tester) async {
      // Arrange: Mock empty draw pile scenario
      final emptyDrawState = DeckState(
        drawPile: const [],
        discardPile: List.generate(5, (i) => game.Card(value: i, isRevealed: true)),
      );

      // Act: Render widget showing empty draw pile
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameStateNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CommonAreaWidget(
                drawPileCount: emptyDrawState.drawPile.length,
                topDiscardCard: emptyDrawState.topDiscardCard,
                isPlayerTurn: true,
                showReshuffleIndicator: emptyDrawState.isDrawPileEmpty,
                onDrawCard: () => mockNotifier.drawFromDeck('player1'),
              ),
            ),
          ),
        ),
      );

      // Assert empty draw pile behavior
      expect(find.text('0'), findsOneWidget, reason: 'Should show empty draw pile count');
      expect(find.text('Mélange nécessaire'), findsOneWidget, reason: 'Should show reshuffle indicator');

      // Trigger reshuffle behavior
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pumpAndSettle();

      // Verify reshuffle behavior was triggered
      verify(() => mockNotifier.drawFromDeck('player1')).called(1);
    });

    testWidgets('should not trigger actions when not player turn', (tester) async {
      // Arrange: Mock non-player turn scenario
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameStateNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CommonAreaWidget(
                drawPileCount: 20,
                topDiscardCard: const game.Card(value: 7, isRevealed: true),
                isPlayerTurn: false, // Not player's turn
                onDrawCard: () => mockNotifier.drawFromDeck('player1'),
                onDiscardCard: (card) => mockNotifier.discardCard('player1', 0),
              ),
            ),
          ),
        ),
      );

      // Act: Try to draw when not player turn
      await tester.tap(find.byType(DrawPileWidget));
      await tester.pump();

      // Assert: No actions should be triggered
      verifyNever(() => mockNotifier.drawFromDeck(any()));
      verifyNever(() => mockNotifier.discardCard(any(), any()));
    });

    testWidgets('should display proper UI animations during discard actions', (tester) async {
      // Arrange: Mock initial card state
      const initialCard = game.Card(value: 3, isRevealed: true);
      const newCard = game.Card(value: 8, isRevealed: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameStateNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CommonAreaWidget(
                drawPileCount: 15,
                topDiscardCard: initialCard,
                isPlayerTurn: true,
                onDrawCard: () => mockNotifier.drawFromDeck('player1'),
                onDiscardCard: (card) => mockNotifier.discardCard('player1', 0),
                canDiscard: true,
              ),
            ),
          ),
        ),
      );

      // Assert initial card display behavior
      expect(find.text('3'), findsWidgets, reason: 'Should display initial top card value');

      // Act: Trigger discard UI behavior 
      final discardPile = tester.widget<DiscardPileWidget>(find.byType(DiscardPileWidget));
      expect(discardPile.onCardDropped, isNotNull, reason: 'Should provide discard drop callback');
      discardPile.onCardDropped!(newCard);

      // Assert: Animation components should be present
      await tester.pump();
      expect(find.byType(AnimatedSwitcher), findsWidgets, reason: 'Should show card transition animations');

      // Verify discard behavior was triggered
      verify(() => mockNotifier.discardCard('player1', 0)).called(1);
    });

    testWidgets('should handle multiple draw actions correctly', (tester) async {
      // Arrange: Mock initial deck state
      final initialDeckState = DeckState(
        drawPile: List.generate(5, (i) => game.Card(value: i * 2, isRevealed: false)),
        discardPile: [const game.Card(value: 1, isRevealed: true)],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameStateNotifierProvider.overrideWith(() => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CommonAreaWidget(
                drawPileCount: initialDeckState.drawPile.length,
                topDiscardCard: initialDeckState.topDiscardCard,
                isPlayerTurn: true,
                onDrawCard: () => mockNotifier.drawFromDeck('player1'),
                onDiscardCard: (card) => mockNotifier.discardCard('player1', 0),
              ),
            ),
          ),
        ),
      );

      // Act: Perform multiple draw actions
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(DrawPileWidget));
        await tester.pumpAndSettle();
      }

      // Assert: Verify multiple draw behaviors were triggered
      verify(() => mockNotifier.drawFromDeck('player1')).called(3);
    });
  });
}
