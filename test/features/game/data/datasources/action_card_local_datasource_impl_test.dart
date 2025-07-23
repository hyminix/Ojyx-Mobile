import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/datasources/action_card_local_datasource_impl.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  late ActionCardLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = ActionCardLocalDataSourceImpl();
  });

  group('ActionCardLocalDataSourceImpl', () {
    final testCard1 = ActionCard(
      id: 'test-1',
      type: ActionCardType.teleport,
      name: 'Téléportation',
      description: 'Échangez deux cartes',
      timing: ActionTiming.optional,
      target: ActionTarget.self,
    );

    final testCard2 = ActionCard(
      id: 'test-2',
      type: ActionCardType.skip,
      name: 'Saut',
      description: 'Sautez le tour du prochain joueur',
      timing: ActionTiming.optional,
      target: ActionTarget.none,
    );

    test('should initialize with default action cards', () {
      // Act
      final cards = dataSource.getAvailableActionCards();

      // Assert
      expect(cards, isNotEmpty);
      expect(cards.every((card) => card is ActionCard), isTrue);
    });

    test('should get empty player action cards initially', () {
      // Act
      final cards = dataSource.getPlayerActionCards('player1');

      // Assert
      expect(cards, isEmpty);
    });

    test('should add action card to player', () {
      // Act
      dataSource.addActionCardToPlayer('player1', testCard1);
      final cards = dataSource.getPlayerActionCards('player1');

      // Assert
      expect(cards.length, equals(1));
      expect(cards.first, equals(testCard1));
    });

    test('should add multiple action cards to different players', () {
      // Act
      dataSource.addActionCardToPlayer('player1', testCard1);
      dataSource.addActionCardToPlayer('player2', testCard2);

      // Assert
      expect(dataSource.getPlayerActionCards('player1'), contains(testCard1));
      expect(
        dataSource.getPlayerActionCards('player1'),
        isNot(contains(testCard2)),
      );
      expect(dataSource.getPlayerActionCards('player2'), contains(testCard2));
      expect(
        dataSource.getPlayerActionCards('player2'),
        isNot(contains(testCard1)),
      );
    });

    test('should throw when adding more than 3 cards to a player', () {
      // Arrange
      final cards = List.generate(
        kMaxActionCardsInHand,
        (i) => ActionCard(
          id: 'card-$i',
          type: ActionCardType.values[i % ActionCardType.values.length],
          name: 'Card $i',
          description: 'Description $i',
          timing: ActionTiming.optional,
        ),
      );

      for (final card in cards) {
        dataSource.addActionCardToPlayer('player1', card);
      }

      final extraCard = ActionCard(
        id: 'extra',
        type: ActionCardType.shield,
        name: 'Extra Card',
        description: 'Extra',
        timing: ActionTiming.optional,
      );

      // Act & Assert
      expect(
        () => dataSource.addActionCardToPlayer('player1', extraCard),
        throwsException,
      );
    });

    test('should remove action card from player', () {
      // Arrange
      dataSource.addActionCardToPlayer('player1', testCard1);
      dataSource.addActionCardToPlayer('player1', testCard2);

      // Act
      dataSource.removeActionCardFromPlayer('player1', testCard1);

      // Assert
      final cards = dataSource.getPlayerActionCards('player1');
      expect(cards.length, equals(1));
      expect(cards, contains(testCard2));
      expect(cards, isNot(contains(testCard1)));
    });

    test('should throw when removing card player does not have', () {
      // Act & Assert
      expect(
        () => dataSource.removeActionCardFromPlayer('player1', testCard1),
        throwsException,
      );
    });

    test('should draw action card from pile', () {
      // Arrange
      dataSource.initializeDeck(); // Ensure deck is populated

      // Act
      final drawnCard = dataSource.drawActionCard();

      // Assert
      expect(drawnCard, isNotNull);
      expect(drawnCard, isA<ActionCard>());
    });

    test('should return null when drawing from empty pile', () {
      // Arrange - draw all cards
      dataSource.initializeDeck();
      ActionCard? card;
      do {
        card = dataSource.drawActionCard();
      } while (card != null);

      // Act
      final result = dataSource.drawActionCard();

      // Assert
      expect(result, isNull);
    });

    test('should discard action card', () {
      // Arrange
      dataSource.initializeDeck();
      // Draw all cards first
      ActionCard? card;
      final drawnCards = <ActionCard>[];
      do {
        card = dataSource.drawActionCard();
        if (card != null) drawnCards.add(card);
      } while (card != null);

      // Act - discard some cards
      dataSource.discardActionCard(drawnCards[0]);
      dataSource.discardActionCard(drawnCards[1]);

      // Assert - should be able to draw again
      final newDraw = dataSource.drawActionCard();
      expect(newDraw, isNotNull);
      expect([drawnCards[0], drawnCards[1]], contains(newDraw));
    });

    test('should shuffle action cards', () {
      // Arrange
      dataSource.initializeDeck();
      final originalOrder = dataSource.getAvailableActionCards().toList();

      // Act
      dataSource.shuffleActionCards();

      // Assert
      final newOrder = dataSource.getAvailableActionCards();
      expect(newOrder.length, equals(originalOrder.length));
      expect(newOrder.toSet(), equals(originalOrder.toSet()));
      // We can't guarantee order will be different, but all cards should be present
    });

    test('should maintain player cards after operations', () {
      // Arrange
      dataSource.addActionCardToPlayer('player1', testCard1);

      // Act - various operations
      dataSource.initializeDeck();
      dataSource.shuffleActionCards();
      dataSource.drawActionCard();
      dataSource.discardActionCard(testCard2);

      // Assert - player cards unchanged
      expect(dataSource.getPlayerActionCards('player1'), contains(testCard1));
    });
  });
}
