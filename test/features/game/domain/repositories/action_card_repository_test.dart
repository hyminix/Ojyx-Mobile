import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';

// Test implementation
class TestActionCardRepository implements ActionCardRepository {
  final List<ActionCard> _actionCards = [];
  final Map<String, List<ActionCard>> _playerActionCards = {};

  @override
  List<ActionCard> getAvailableActionCards() {
    return List.unmodifiable(_actionCards);
  }

  @override
  List<ActionCard> getPlayerActionCards(String playerId) {
    return List.unmodifiable(_playerActionCards[playerId] ?? []);
  }

  @override
  void addActionCardToPlayer(String playerId, ActionCard card) {
    _playerActionCards.putIfAbsent(playerId, () => []);
    final playerCards = _playerActionCards[playerId]!;

    if (playerCards.length >= 3) {
      throw Exception('Player cannot have more than 3 action cards');
    }

    playerCards.add(card);
  }

  @override
  void removeActionCardFromPlayer(String playerId, ActionCard card) {
    final playerCards = _playerActionCards[playerId];
    if (playerCards == null || !playerCards.contains(card)) {
      throw Exception('Player does not have this action card');
    }

    playerCards.remove(card);
  }

  @override
  ActionCard? drawActionCard() {
    if (_actionCards.isEmpty) {
      return null;
    }

    return _actionCards.removeAt(0);
  }

  @override
  void discardActionCard(ActionCard card) {
    _actionCards.add(card);
  }

  @override
  void shuffleActionCards() {
    _actionCards.shuffle();
  }

  // Test helper methods
  void addToDrawPile(ActionCard card) {
    _actionCards.add(card);
  }

  void clearAll() {
    _actionCards.clear();
    _playerActionCards.clear();
  }
}

void main() {
  group('ActionCardRepository', () {
    late TestActionCardRepository repository;

    setUp(() {
      repository = TestActionCardRepository();
    });

    test('should get empty list when no action cards available', () {
      // Act
      final cards = repository.getAvailableActionCards();

      // Assert
      expect(cards, isEmpty);
    });

    test('should get available action cards', () {
      // Arrange
      final card1 = ActionCard(
        id: '1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      final card2 = ActionCard(
        id: '2',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Inversez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      );

      repository.addToDrawPile(card1);
      repository.addToDrawPile(card2);

      // Act
      final cards = repository.getAvailableActionCards();

      // Assert
      expect(cards.length, equals(2));
      expect(cards, contains(card1));
      expect(cards, contains(card2));
    });

    test('should get player action cards when empty', () {
      // Act
      final cards = repository.getPlayerActionCards('player1');

      // Assert
      expect(cards, isEmpty);
    });

    test('should add action card to player', () {
      // Arrange
      final card = ActionCard(
        id: '1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );

      // Act
      repository.addActionCardToPlayer('player1', card);

      // Assert
      final playerCards = repository.getPlayerActionCards('player1');
      expect(playerCards.length, equals(1));
      expect(playerCards.first, equals(card));
    });

    test('should prevent adding more than 3 action cards', () {
      // Arrange
      final cards = List.generate(
        3,
        (i) => ActionCard(
          id: '$i',
          type: ActionCardType.teleport,
          name: 'Card $i',
          description: 'Description $i',
          timing: ActionTiming.optional,
        ),
      );

      for (final card in cards) {
        repository.addActionCardToPlayer('player1', card);
      }

      final extraCard = ActionCard(
        id: '4',
        type: ActionCardType.shield,
        name: 'Extra Card',
        description: 'Extra',
        timing: ActionTiming.optional,
      );

      // Act & Assert
      expect(
        () => repository.addActionCardToPlayer('player1', extraCard),
        throwsException,
      );
    });

    test('should remove action card from player', () {
      // Arrange
      final card = ActionCard(
        id: '1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );

      repository.addActionCardToPlayer('player1', card);

      // Act
      repository.removeActionCardFromPlayer('player1', card);

      // Assert
      final playerCards = repository.getPlayerActionCards('player1');
      expect(playerCards, isEmpty);
    });

    test('should throw when removing card player does not have', () {
      // Arrange
      final card = ActionCard(
        id: '1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );

      // Act & Assert
      expect(
        () => repository.removeActionCardFromPlayer('player1', card),
        throwsException,
      );
    });

    test('should draw action card from pile', () {
      // Arrange
      final card = ActionCard(
        id: '1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );

      repository.addToDrawPile(card);

      // Act
      final drawnCard = repository.drawActionCard();

      // Assert
      expect(drawnCard, equals(card));
      expect(repository.getAvailableActionCards(), isEmpty);
    });

    test('should return null when drawing from empty pile', () {
      // Act
      final drawnCard = repository.drawActionCard();

      // Assert
      expect(drawnCard, isNull);
    });

    test('should discard action card', () {
      // Arrange
      final card = ActionCard(
        id: '1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );

      // Act
      repository.discardActionCard(card);

      // Assert
      expect(repository.getAvailableActionCards(), contains(card));
    });

    test('should shuffle action cards', () {
      // Arrange
      final cards = List.generate(
        10,
        (i) => ActionCard(
          id: '$i',
          type: ActionCardType.values[i % ActionCardType.values.length],
          name: 'Card $i',
          description: 'Description $i',
          timing: ActionTiming.optional,
        ),
      );

      for (final card in cards) {
        repository.addToDrawPile(card);
      }

      final originalOrder = List.from(repository.getAvailableActionCards());

      // Act
      repository.shuffleActionCards();

      // Assert
      final newOrder = repository.getAvailableActionCards();
      expect(newOrder.length, equals(originalOrder.length));
      expect(newOrder.toSet(), equals(originalOrder.toSet()));
      // Note: We can't guarantee the order will be different after shuffle
      // but all cards should still be present
    });

    test('should handle multiple players independently', () {
      // Arrange
      final card1 = ActionCard(
        id: '1',
        type: ActionCardType.swap,
        name: 'Card 1',
        description: 'Description 1',
        timing: ActionTiming.optional,
      );
      final card2 = ActionCard(
        id: '2',
        type: ActionCardType.peek,
        name: 'Card 2',
        description: 'Description 2',
        timing: ActionTiming.optional,
      );

      // Act
      repository.addActionCardToPlayer('player1', card1);
      repository.addActionCardToPlayer('player2', card2);

      // Assert
      expect(repository.getPlayerActionCards('player1'), contains(card1));
      expect(
        repository.getPlayerActionCards('player1'),
        isNot(contains(card2)),
      );
      expect(repository.getPlayerActionCards('player2'), contains(card2));
      expect(
        repository.getPlayerActionCards('player2'),
        isNot(contains(card1)),
      );
    });
  });
}
