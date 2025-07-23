import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  group('Player Entity', () {
    test('should create player with required fields', () {
      final player = Player(
        id: 'player1',
        name: 'John Doe',
        grid: PlayerGrid.empty(),
      );

      expect(player.id, 'player1');
      expect(player.name, 'John Doe');
      expect(player.grid, isNotNull);
      expect(player.actionCards, isEmpty);
      expect(player.isConnected, true);
      expect(player.isHost, false);
      expect(player.hasFinishedRound, false);
    });

    test('should create host player', () {
      final player = Player(
        id: 'host1',
        name: 'Host Player',
        grid: PlayerGrid.empty(),
        isHost: true,
      );

      expect(player.isHost, true);
    });

    test('should add action card to hand', () {
      final player = Player(
        id: 'player1',
        name: 'John',
        grid: PlayerGrid.empty(),
      );

      const actionCard = ActionCard(
        id: 'action1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échange deux cartes',
      );

      final updatedPlayer = player.addActionCard(actionCard);

      expect(player.actionCards, isEmpty);
      expect(updatedPlayer.actionCards.length, 1);
      expect(updatedPlayer.actionCards.first, equals(actionCard));
    });

    test('should not add more than 3 action cards', () {
      var player = Player(
        id: 'player1',
        name: 'John',
        grid: PlayerGrid.empty(),
      );

      // Add 3 cards
      for (int i = 0; i < 3; i++) {
        player = player.addActionCard(
          ActionCard(
            id: 'action$i',
            type: ActionCardType.teleport,
            name: 'Card $i',
            description: 'Description',
          ),
        );
      }

      expect(player.actionCards.length, 3);

      // Try to add 4th card
      expect(
        () => player.addActionCard(
          const ActionCard(
            id: 'action4',
            type: ActionCardType.teleport,
            name: 'Card 4',
            description: 'Description',
          ),
        ),
        throwsAssertionError,
      );
    });

    test('should remove action card from hand', () {
      var player = Player(
        id: 'player1',
        name: 'John',
        grid: PlayerGrid.empty(),
      );

      const actionCard1 = ActionCard(
        id: 'action1',
        type: ActionCardType.teleport,
        name: 'Card 1',
        description: 'Description',
      );
      const actionCard2 = ActionCard(
        id: 'action2',
        type: ActionCardType.turnAround,
        name: 'Card 2',
        description: 'Description',
      );

      player = player.addActionCard(actionCard1);
      player = player.addActionCard(actionCard2);

      expect(player.actionCards.length, 2);

      final updatedPlayer = player.removeActionCard('action1');

      expect(updatedPlayer.actionCards.length, 1);
      expect(updatedPlayer.actionCards.first.id, 'action2');
    });

    test('should calculate current score', () {
      final grid = PlayerGrid.empty();
      // Add some cards with values
      final gridWithCards = grid
          .setCard(0, 0, const Card(value: 5, isRevealed: true))
          .setCard(0, 1, const Card(value: -2, isRevealed: true))
          .setCard(1, 0, const Card(value: 12, isRevealed: true));

      final player = Player(id: 'player1', name: 'John', grid: gridWithCards);

      expect(player.currentScore, 5 + (-2) + 12);
    });

    test('should support value equality', () {
      final grid = PlayerGrid.empty();

      final player1 = Player(id: 'player1', name: 'John', grid: grid);

      final player2 = Player(id: 'player1', name: 'John', grid: grid);

      final player3 = Player(id: 'player2', name: 'John', grid: grid);

      expect(player1, equals(player2));
      expect(player1, isNot(equals(player3)));
    });
  });
}
