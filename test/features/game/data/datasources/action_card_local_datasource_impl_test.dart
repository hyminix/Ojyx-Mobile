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

    test('should initialize with default action cards', () async {
      // Act
      final cards = await dataSource.getAvailableActionCards();

      // Assert
      expect(cards, isNotEmpty);
      expect(cards.every((card) => card is ActionCard), isTrue);
    });

    test('should get empty player action cards initially', () async {
      // Act
      final cards = await dataSource.getPlayerActionCards('player1');

      // Assert
      expect(cards, isEmpty);
    });

    test('should add action card to player', () async {
      // Act
      await dataSource.addActionCardToPlayer('player1', testCard1);
      final cards = await dataSource.getPlayerActionCards('player1');

      // Assert
      expect(cards.length, equals(1));
      expect(cards.first, equals(testCard1));
    });

    test('should add multiple action cards to different players', () async {
      // Act
      await dataSource.addActionCardToPlayer('player1', testCard1);
      await dataSource.addActionCardToPlayer('player2', testCard2);

      // Assert
      expect(
        await dataSource.getPlayerActionCards('player1'),
        contains(testCard1),
      );
      expect(
        await dataSource.getPlayerActionCards('player1'),
        isNot(contains(testCard2)),
      );
      expect(
        await dataSource.getPlayerActionCards('player2'),
        contains(testCard2),
      );
      expect(
        await dataSource.getPlayerActionCards('player2'),
        isNot(contains(testCard1)),
      );
    });

    test('should throw when adding more than 3 cards to a player', () async {
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
        await dataSource.addActionCardToPlayer('player1', card);
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

    test('should remove action card from player', () async {
      // Arrange
      await dataSource.addActionCardToPlayer('player1', testCard1);
      await dataSource.addActionCardToPlayer('player1', testCard2);

      // Act
      await dataSource.removeActionCardFromPlayer('player1', testCard1);

      // Assert
      final cards = await dataSource.getPlayerActionCards('player1');
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

    test('should draw action card from pile', () async {
      // Arrange
      await dataSource.initializeDeck(); // Ensure deck is populated

      // Act
      final drawnCard = await dataSource.drawActionCard();

      // Assert
      expect(drawnCard, isNotNull);
      expect(drawnCard, isA<ActionCard>());
    });

    test('should return null when drawing from empty pile', () async {
      // Arrange - draw all cards
      await dataSource.initializeDeck();
      ActionCard? card;
      do {
        card = await dataSource.drawActionCard();
      } while (card != null);

      // Act
      final result = await dataSource.drawActionCard();

      // Assert
      expect(result, isNull);
    });

    test('should discard action card', () async {
      // Arrange
      await dataSource.initializeDeck();
      // Draw all cards first
      ActionCard? card;
      final drawnCards = <ActionCard>[];
      do {
        card = await dataSource.drawActionCard();
        if (card != null) drawnCards.add(card);
      } while (card != null);

      // Act - discard some cards
      await dataSource.discardActionCard(drawnCards[0]);
      await dataSource.discardActionCard(drawnCards[1]);

      // Assert - should be able to draw again
      final newDraw = await dataSource.drawActionCard();
      expect(newDraw, isNotNull);
      expect([drawnCards[0], drawnCards[1]], contains(newDraw));
    });

    test('should shuffle action cards', () async {
      // Arrange
      await dataSource.initializeDeck();
      final originalOrder = (await dataSource.getAvailableActionCards())
          .toList();

      // Act
      await dataSource.shuffleActionCards();

      // Assert
      final newOrder = await dataSource.getAvailableActionCards();
      expect(newOrder.length, equals(originalOrder.length));
      expect(newOrder.toSet(), equals(originalOrder.toSet()));
      // We can't guarantee order will be different, but all cards should be present
    });

    test('should maintain player cards after operations', () async {
      // Arrange
      await dataSource.addActionCardToPlayer('player1', testCard1);

      // Act - various operations
      await dataSource.initializeDeck();
      await dataSource.shuffleActionCards();
      await dataSource.drawActionCard();
      await dataSource.discardActionCard(testCard2);

      // Assert - player cards unchanged
      expect(
        await dataSource.getPlayerActionCards('player1'),
        contains(testCard1),
      );
    });
  });
}
