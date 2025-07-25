import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  group('GamePlayer Action Card Management', () {
    test('should expand action card options when receiving new cards during gameplay', () {
      // Test behavior: players accumulate strategic options through action cards
      final player = GamePlayer(
        id: 'player1',
        name: 'John',
        grid: PlayerGrid.empty(),
      );

      const actionCard = ActionCard(
        id: 'teleport-1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échange deux cartes',
      );

      final updatedPlayer = player.addActionCard(actionCard);

      // Verify immutability and behavior
      expect(player.actionCards, isEmpty, reason: 'Original player should remain unchanged');
      expect(updatedPlayer.actionCards.length, 1, reason: 'Player should gain strategic option');
      expect(updatedPlayer.actionCards.first, equals(actionCard), reason: 'Exact card should be available');
    });

    test('should enforce hand limit to maintain game balance when action cards are abundant', () {
      // Test behavior: game prevents action card hoarding by enforcing 3-card limit
      var player = GamePlayer(
        id: 'player1',
        name: 'John',
        grid: PlayerGrid.empty(),
      );

      // Fill player's action card hand to maximum
      for (int i = 0; i < 3; i++) {
        player = player.addActionCard(
          ActionCard(
            id: 'action$i',
            type: ActionCardType.teleport,
            name: 'Card $i',
            description: 'Strategic option $i',
          ),
        );
      }

      expect(player.actionCards.length, 3, reason: 'Player should reach maximum hand size');

      // Verify game rule enforcement
      expect(
        () => player.addActionCard(
          const ActionCard(
            id: 'overflow-card',
            type: ActionCardType.teleport,
            name: 'Overflow Card',
            description: 'This should not be addable',
          ),
        ),
        throwsAssertionError,
        reason: 'Game should prevent action card hoarding beyond limit',
      );
    });

    test('should allow strategic card usage by removing cards from hand', () {
      // Test behavior: players can use action cards, reducing their strategic options
      var player = GamePlayer(
        id: 'player1',
        name: 'John',
        grid: PlayerGrid.empty(),
      );

      const teleportCard = ActionCard(
        id: 'teleport-1',
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );
      const reverseCard = ActionCard(
        id: 'reverse-1',
        type: ActionCardType.turnAround,
        name: 'Reverse',
        description: 'Turn around card',
      );

      // Build up player's strategic options
      player = player.addActionCard(teleportCard);
      player = player.addActionCard(reverseCard);

      expect(player.actionCards.length, 2, reason: 'Player should have multiple strategic options');

      // Player uses teleport card
      final updatedPlayer = player.removeActionCard('teleport-1');

      // Verify strategic option is consumed
      expect(updatedPlayer.actionCards.length, 1, reason: 'Player should have fewer options after using card');
      expect(updatedPlayer.actionCards.first.id, 'reverse-1', reason: 'Remaining card should be available');
    });

    test('should calculate meaningful score for competitive ranking during end game', () {
      // Test behavior: score calculation determines game winner
      final grid = PlayerGrid.empty();
      // Create realistic scoring scenario with mixed card values
      final gridWithCards = grid
          .setCard(0, 0, const Card(value: 5, isRevealed: true))   // Moderate penalty
          .setCard(0, 1, const Card(value: -2, isRevealed: true))  // Bonus points
          .setCard(1, 0, const Card(value: 12, isRevealed: true)); // High penalty

      final player = GamePlayer(
        id: 'player1',
        name: 'John',
        grid: gridWithCards,
      );

      // Verify score calculation for game ranking
      const expectedScore = 5 + (-2) + 12; // 15 points
      expect(player.currentScore, expectedScore, 
             reason: 'Score should reflect revealed card values for competitive ranking');
    });
  });
}
