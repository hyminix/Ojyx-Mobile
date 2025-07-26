import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/action_card_draw_pile_widget.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_providers.dart';

class MockActionCardStateNotifier extends ActionCardStateNotifier with Mock {
  MockActionCardStateNotifier(ActionCardState initialState) {
    state = initialState;
  }
}

void main() {
  group('ActionCardDrawPile Strategic Card Acquisition Behavior', () {
    late MockActionCardStateNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockActionCardStateNotifier(
        const ActionCardState(
          drawPileCount: 37,
          discardPileCount: 0,
          isLoading: false,
        ),
      );
    });

    Widget createTestWidget({bool canDraw = true, VoidCallback? onDraw}) {
      return ProviderScope(
        overrides: [
          actionCardStateNotifierProvider.overrideWith(() => mockNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ActionCardDrawPileWidget(canDraw: canDraw, onDraw: onDraw),
            ),
          ),
        ),
      );
    }

    testWidgets(
      'should enable strategic action card acquisition when player turn allows',
      (tester) async {
        // Test behavior: action card pile provides strategic advantage through new abilities
        final drawScenarios = [
          (
            drawPileCount: 37,
            canDraw: true,
            expectDrawAction: true,
            scenario:
                'full deck during player turn enables strategic card acquisition',
          ),
          (
            drawPileCount: 3,
            canDraw: true,
            expectDrawAction: true,
            scenario: 'limited cards create urgency for strategic draws',
          ),
          (
            drawPileCount: 37,
            canDraw: false,
            expectDrawAction: false,
            scenario: 'opponent turn prevents unauthorized card acquisition',
          ),
          (
            drawPileCount: 0,
            canDraw: false,
            expectDrawAction: false,
            scenario: 'exhausted deck prevents any draw attempts',
          ),
        ];

        for (final (
              drawPileCount: count,
              :canDraw,
              :expectDrawAction,
              :scenario,
            )
            in drawScenarios) {
          mockNotifier.state = ActionCardState(
            drawPileCount: count,
            discardPileCount: 0,
            isLoading: false,
          );

          var drawAttempted = false;
          await tester.pumpWidget(
            createTestWidget(
              canDraw: canDraw,
              onDraw: () => drawAttempted = true,
            ),
          );

          await tester.tap(find.byType(ActionCardDrawPileWidget));
          await tester.pump();

          expect(
            drawAttempted,
            expectDrawAction,
            reason: 'Scenario: $scenario',
          );
        }
      },
    );

    testWidgets('should communicate deck availability for strategic planning', (
      tester,
    ) async {
      // Test behavior: deck status informs strategic decision-making
      final deckScenarios = [
        (
          drawPileCount: 37,
          expectedDisplay: '37',
          expectedStatus: null,
          'abundant cards allow aggressive drawing',
        ),
        (
          drawPileCount: 5,
          expectedDisplay: '5',
          expectedStatus: null,
          'low card count suggests conservative strategy',
        ),
        (
          drawPileCount: 0,
          expectedDisplay: '0',
          expectedStatus: 'Pile vide',
          'empty pile requires adaptation',
        ),
      ];

      for (final (
            drawPileCount: count,
            :expectedDisplay,
            :expectedStatus,
            scenario,
          )
          in deckScenarios) {
        mockNotifier.state = ActionCardState(
          drawPileCount: count,
          discardPileCount: 0,
          isLoading: false,
        );

        await tester.pumpWidget(createTestWidget());

        expect(
          find.text(expectedDisplay),
          findsOneWidget,
          reason:
              'Card count visibility enables strategic planning for $scenario',
        );

        if (expectedStatus != null) {
          expect(
            find.text(expectedStatus),
            findsOneWidget,
            reason: 'Deck status communication for $scenario',
          );
        }
      }
    });

    testWidgets(
      'should provide interactive feedback for strategic action timing',
      (tester) async {
        // Test behavior: visual and interactive feedback guides strategic play
        await tester.pumpWidget(createTestWidget(canDraw: true));

        // Long press reveals strategic guidance
        await tester.longPress(find.byType(ActionCardDrawPileWidget));
        await tester.pumpAndSettle();

        expect(
          find.text('Piochez une carte action'),
          findsOneWidget,
          reason:
              'Strategic guidance helps players understand action card mechanics',
        );
      },
    );

    testWidgets(
      'should handle concurrent draw operations during intense gameplay',
      (tester) async {
        // Test behavior: system prevents accidental multiple draws maintaining game integrity
        mockNotifier.state = const ActionCardState(
          drawPileCount: 10,
          discardPileCount: 0,
          isLoading: true, // Simulating ongoing draw operation
        );

        var additionalDrawAttempted = false;
        await tester.pumpWidget(
          createTestWidget(
            canDraw: true,
            onDraw: () => additionalDrawAttempted = true,
          ),
        );

        // Loading state should prevent additional draws
        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
          reason: 'Loading indicator prevents duplicate draw operations',
        );

        await tester.tap(
          find.byType(ActionCardDrawPileWidget),
          warnIfMissed: false,
        );
        await tester.pump();

        expect(
          additionalDrawAttempted,
          isFalse,
          reason: 'Concurrent draw protection maintains game state integrity',
        );
      },
    );

    testWidgets('should reflect dynamic deck changes for strategic awareness', (
      tester,
    ) async {
      // Test behavior: real-time deck updates inform evolving strategies
      await tester.pumpWidget(createTestWidget());

      // Initial abundant state
      expect(
        find.text('37'),
        findsOneWidget,
        reason: 'Initial deck state establishes baseline strategy',
      );

      // Mid-game depletion affects strategy
      mockNotifier.state = const ActionCardState(
        drawPileCount: 12,
        discardPileCount: 25,
        isLoading: false,
      );
      await tester.pump();

      expect(
        find.text('12'),
        findsOneWidget,
        reason: 'Depleted deck signals shift to conservative strategy',
      );
      expect(
        find.text('37'),
        findsNothing,
        reason: 'Outdated information removed for accurate decision-making',
      );
    });
  });
}
