import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/player_hand_widget.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('PlayerHandWidget Strategic Card Management Behavior', () {
    testWidgets('should enable strategic card decision-making for current player only', (
      WidgetTester tester,
    ) async {
      // Test behavior: hand management enforces turn-based fairness by showing
      // strategic options only to the active player, preventing unauthorized actions
      
      final scenarios = [
        // (drawnCard, isCurrentPlayer, expectedBehavior)
        (
          game.Card(value: 10, isRevealed: false), // High-value risky card
          false, // Not player's turn
          'should hide strategic options from inactive players',
        ),
        (
          game.Card(value: -2, isRevealed: false), // Valuable bonus card
          true, // Player's turn
          'should reveal strategic decision point for active player',
        ),
        (
          null, // No card drawn yet
          true, // Player's turn but no decision needed
          'should indicate no strategic action required',
        ),
      ];

      for (final (drawnCard, isCurrentPlayer, expectedBehavior) in scenarios) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerHandWidget(
                drawnCard: drawnCard,
                isCurrentPlayer: isCurrentPlayer,
              ),
            ),
          ),
        );

        final hasStrategicInterface = find.text('Carte en main').evaluate().isNotEmpty;
        
        if (drawnCard != null && isCurrentPlayer) {
          expect(hasStrategicInterface, isTrue, 
              reason: '$expectedBehavior - player needs decision interface');
        } else {
          expect(hasStrategicInterface, isFalse,
              reason: '$expectedBehavior - no decision interface should appear');
        }
        
        await tester.pumpWidget(Container()); // Clear for next scenario
      }
    });

    testWidgets('should provide strategic discard decision based on game state constraints', (
      WidgetTester tester,
    ) async {
      // Test behavior: discard option availability reflects strategic game rules
      // ensuring players can only make valid moves that maintain competitive balance
      
      bool strategicActionExecuted = false;
      
      final gameScenarios = [
        // (cardValue, canDiscard, expectedStrategicOption, scenario)
        (
          12, // High penalty card
          true, // Rules allow discard
          true, // Should show discard option
          'high-risk card with discard allowed creates strategic choice',
        ),
        (
          -2, // Valuable bonus card  
          true, // Rules allow discard
          true, // Should show option (but player might not use it)
          'bonus card with discard allowed tests risk/reward decision',
        ),
        (
          5, // Mid-value card
          false, // Rules forbid discard (e.g., mandatory exchange)
          false, // No discard option
          'mandatory card exchange enforces strategic constraint',
        ),
      ];

      for (final (value, canDiscard, expectOption, scenario) in gameScenarios) {
        strategicActionExecuted = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerHandWidget(
                drawnCard: game.Card(value: value, isRevealed: false),
                isCurrentPlayer: true,
                canDiscard: canDiscard,
                onDiscard: canDiscard ? () {
                  strategicActionExecuted = true;
                } : null,
              ),
            ),
          ),
        );

        final hasDiscardOption = find.text('Défausser').evaluate().isNotEmpty;
        expect(hasDiscardOption, expectOption,
            reason: 'Scenario: $scenario');
            
        // Verify strategic guidance is provided
        if (expectOption) {
          expect(find.text('Glissez sur\nune carte'), findsOneWidget,
              reason: 'Strategic instruction should guide player action');
              
          // Test strategic action execution
          await tester.tap(find.text('Défausser'));
          await tester.pump();
          
          expect(strategicActionExecuted, isTrue,
              reason: 'Strategic discard decision should execute when chosen');
        }
        
        await tester.pumpWidget(Container()); // Clear for next scenario
      }
    });

    testWidgets('should visualize strategic hand position to influence player decisions', (
      WidgetTester tester,
    ) async {
      // Test behavior: hand visualization creates psychological pressure and
      // strategic awareness through prominent positioning and visual cues
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              error: Colors.red, // Strategic warning color for discard
            ),
          ),
          home: Scaffold(
            body: PlayerHandWidget(
              drawnCard: const game.Card(value: 11, isRevealed: false), // High penalty
              isCurrentPlayer: true,
              canDiscard: true,
              onDiscard: () {},
            ),
          ),
        ),
      );

      // Verify strategic visual prominence
      expect(find.text('Carte en main'), findsOneWidget,
          reason: 'Clear labeling creates decision awareness');
      expect(find.byIcon(Icons.pan_tool), findsOneWidget,
          reason: 'Hand icon reinforces temporary nature of held card');
      
      // Verify risk communication through color
      final discardButton = find.text('Défausser');
      expect(discardButton, findsOneWidget,
          reason: 'Discard option prominently displayed for high-risk cards');
          
      // The visual design creates strategic pressure to make a decision
      // rather than holding high-penalty cards indefinitely
    });

    testWidgets('should handle edge cases gracefully maintaining game integrity', (
      WidgetTester tester,
    ) async {
      // Test behavior: widget maintains game stability even with edge case inputs
      
      final edgeCases = [
        // (drawnCard, isCurrentPlayer, canDiscard, onDiscard, scenario)
        (
          game.Card(value: 0, isRevealed: false),
          true,
          true,
          null, // Null callback
          'null callback prevents action but shows interface',
        ),
        (
          game.Card(value: -2, isRevealed: true), // Already revealed (edge case)
          true,
          false,
          () {},
          'revealed card in hand (unusual state) still displays',
        ),
      ];

      for (final (card, isCurrent, canDiscard, onDiscard, scenario) in edgeCases) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerHandWidget(
                drawnCard: card,
                isCurrentPlayer: isCurrent,
                canDiscard: canDiscard,
                onDiscard: onDiscard,
              ),
            ),
          ),
        );

        // Widget should render without errors
        expect(find.byType(PlayerHandWidget), findsOneWidget,
            reason: 'Widget handles edge case: $scenario');
            
        // Strategic interface should still appear for current player with card
        if (isCurrent && card != null) {
          expect(find.text('Carte en main'), findsOneWidget,
              reason: 'Edge case still shows hand management interface');
        }
        
        await tester.pumpWidget(Container()); // Clear for next case
      }
    });
  });
}
