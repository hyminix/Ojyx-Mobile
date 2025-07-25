import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/deck_and_discard_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/card_widget.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

class MockPlayer extends Mock implements GamePlayer {}

void main() {
  group('DeckAndDiscard Strategic Draw Decision Behavior', () {
    late GameState mockGameState;
    late GamePlayer mockPlayer;

    setUp(() {
      mockPlayer = MockPlayer();
      when(() => mockPlayer.id).thenReturn('player-id');
      when(() => mockPlayer.name).thenReturn('Test GamePlayer');
      when(() => mockPlayer.grid).thenReturn(PlayerGrid.empty());
      when(() => mockPlayer.isHost).thenReturn(true);

      mockGameState = GameState.initial(
        roomId: 'test-room',
        players: [mockPlayer],
      );
    });

    testWidgets(
      'should enable strategic draw decisions between hidden risk and known values',
      (tester) async {
        // Test behavior: players face strategic choice between unknown deck cards and visible discard
        const knownCard = game.Card(value: 8, isRevealed: true);
        final gameState = mockGameState.copyWith(
          discardPile: [knownCard],
          deck: List.generate(20, (i) => game.Card(value: i % 13 - 2)),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DeckAndDiscardWidget(gameState: gameState, canDraw: true),
            ),
          ),
        );

        // Both strategic options visible
        expect(
          find.text('Pioche'),
          findsOneWidget,
          reason: 'Hidden deck offers risk/reward strategic choice',
        );
        expect(
          find.text('Défausse'),
          findsOneWidget,
          reason: 'Visible discard enables informed strategic decision',
        );
        expect(
          find.byIcon(Icons.arrow_forward),
          findsOneWidget,
          reason: 'Flow indicator shows card progression path',
        );
      },
    );

    testWidgets(
      'should reveal discard value enabling strategic risk assessment',
      (tester) async {
        // Test behavior: visible discard card enables calculated strategic decisions
        const strategicScenarios = [
          (value: -2, decision: 'bonus card creates high-value opportunity'),
          (value: 12, decision: 'penalty card suggests deck draw preference'),
          (value: 5, decision: 'neutral card requires context-based choice'),
        ];

        for (final (value: cardValue, :decision) in strategicScenarios) {
          final discardCard = game.Card(value: cardValue, isRevealed: true);
          final gameState = mockGameState.copyWith(discardPile: [discardCard]);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DeckAndDiscardWidget(
                  gameState: gameState,
                  canDraw: false,
                ),
              ),
            ),
          );

          final discardWidget = tester.widget<CardWidget>(
            find.byType(CardWidget).last,
          );
          expect(
            discardWidget.card?.value,
            equals(cardValue),
            reason: 'Visible value enables strategic assessment: $decision',
          );
        }
      },
    );

    testWidgets('should force deck-only strategy when discard empty', (
      tester,
    ) async {
      // Test behavior: empty discard removes strategic choice, forcing deck draw
      final gameState = mockGameState.copyWith(discardPile: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckAndDiscardWidget(gameState: gameState, canDraw: false),
          ),
        ),
      );

      expect(
        find.text('Vide'),
        findsOneWidget,
        reason: 'Empty discard eliminates known-value strategic option',
      );
    });

    testWidgets(
      'should execute strategic draw choices based on game context and turn rules',
      (tester) async {
        // Test behavior: draw choices create different strategic outcomes
        final drawScenarios = [
          (
            source: 'deck',
            setupDiscard: <game.Card>[],
            canDraw: true,
            expectAction: true,
            strategy: 'risk-taking draw from unknown deck',
          ),
          (
            source: 'discard',
            setupDiscard: [const game.Card(value: -2, isRevealed: true)],
            canDraw: true,
            expectAction: true,
            strategy: 'calculated draw of known bonus card',
          ),
          (
            source: 'deck',
            setupDiscard: [const game.Card(value: 12, isRevealed: true)],
            canDraw: false,
            expectAction: false,
            strategy: 'opponent turn prevents strategic interference',
          ),
        ];

        for (final (:source, :setupDiscard, :canDraw, :expectAction, :strategy)
            in drawScenarios) {
          var actionExecuted = false;
          final gameState = mockGameState.copyWith(discardPile: setupDiscard);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DeckAndDiscardWidget(
                  gameState: gameState,
                  canDraw: canDraw,
                  onDrawFromDeck: source == 'deck'
                      ? () => actionExecuted = true
                      : null,
                  onDrawFromDiscard: source == 'discard'
                      ? () => actionExecuted = true
                      : null,
                ),
              ),
            ),
          );

          final targetFinder = source == 'deck'
              ? find.byType(CardWidget).first
              : find.byType(CardWidget).last;

          await tester.tap(targetFinder);
          await tester.pump();

          expect(
            actionExecuted,
            expectAction,
            reason: 'Strategic scenario: $strategy',
          );
        }
      },
    );

    testWidgets(
      'should communicate strategic draw opportunities through visual indicators',
      (tester) async {
        // Test behavior: visual cues guide strategic decision-making
        final indicatorScenarios = [
          (
            discardPile: <game.Card>[],
            canDraw: true,
            expectedIndicators: 1,
            scenario: 'deck-only option when discard empty',
          ),
          (
            discardPile: [const game.Card(value: 5, isRevealed: true)],
            canDraw: true,
            expectedIndicators: 2,
            scenario: 'dual strategic choice between known and unknown',
          ),
          (
            discardPile: [const game.Card(value: -2, isRevealed: true)],
            canDraw: false,
            expectedIndicators: 0,
            scenario: 'no indicators during opponent turn',
          ),
        ];

        for (final (:discardPile, :canDraw, :expectedIndicators, :scenario)
            in indicatorScenarios) {
          final gameState = mockGameState.copyWith(discardPile: discardPile);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: DeckAndDiscardWidget(
                  gameState: gameState,
                  canDraw: canDraw,
                ),
              ),
            ),
          );

          expect(
            find.byIcon(Icons.touch_app),
            findsNWidgets(expectedIndicators),
            reason: 'Visual guidance for: $scenario',
          );
        }
      },
    );

    testWidgets('should track deck depletion for endgame strategic planning', (
      tester,
    ) async {
      // Test behavior: deck count awareness influences draw strategies
      final depletionScenarios = [
        (
          count: 52,
          display: '52 cartes',
          strategy: 'abundant deck allows aggressive drawing',
        ),
        (
          count: 10,
          display: '10 cartes',
          strategy: 'low deck signals conservative play',
        ),
        (
          count: 2,
          display: '2 cartes',
          strategy: 'critical depletion forces adaptation',
        ),
      ];

      for (final (count: deckSize, :display, :strategy) in depletionScenarios) {
        final gameState = mockGameState.copyWith(
          deck: List.generate(deckSize, (i) => game.Card(value: i % 13 - 2)),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DeckAndDiscardWidget(gameState: gameState, canDraw: false),
            ),
          ),
        );

        expect(
          find.text(display),
          findsOneWidget,
          reason: 'Deck awareness enables: $strategy',
        );
      }
    });
  });
}
