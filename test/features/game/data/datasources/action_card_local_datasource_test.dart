import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/data/datasources/action_card_local_datasource.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

class MockActionCardLocalDataSource extends Mock implements ActionCardLocalDataSource {}

void main() {
  late MockActionCardLocalDataSource mockDataSource;
  late ActionCard testActionCard;

  setUp(() {
    mockDataSource = MockActionCardLocalDataSource();
    testActionCard = const ActionCard(
      id: 'card1',
      type: ActionCardType.teleport,
      name: 'Teleport',
      description: 'Teleport to another position',
    );
  });

  group('ActionCardLocalDataSource interface', () {
    test('should define getAvailableActionCards method', () {
      // Arrange
      final expectedCards = [
        testActionCard,
        const ActionCard(
          id: 'card2',
          type: ActionCardType.shield,
          name: 'Shield',
          description: 'Protect from attacks',
        ),
      ];
      when(() => mockDataSource.getAvailableActionCards())
          .thenReturn(expectedCards);

      // Act
      final result = mockDataSource.getAvailableActionCards();

      // Assert
      expect(result, equals(expectedCards));
      verify(() => mockDataSource.getAvailableActionCards()).called(1);
    });

    test('should define getPlayerActionCards method', () {
      // Arrange
      const playerId = 'player1';
      final expectedCards = [testActionCard];
      when(() => mockDataSource.getPlayerActionCards(playerId))
          .thenReturn(expectedCards);

      // Act
      final result = mockDataSource.getPlayerActionCards(playerId);

      // Assert
      expect(result, equals(expectedCards));
      verify(() => mockDataSource.getPlayerActionCards(playerId)).called(1);
    });

    test('should define addActionCardToPlayer method', () {
      // Arrange
      const playerId = 'player1';
      when(() => mockDataSource.addActionCardToPlayer(playerId, testActionCard))
          .thenReturn(null);

      // Act & Assert
      expect(
        () => mockDataSource.addActionCardToPlayer(playerId, testActionCard),
        returnsNormally,
      );
      verify(() => mockDataSource.addActionCardToPlayer(playerId, testActionCard))
          .called(1);
    });

    test('should handle exception when adding card to player with full hand', () {
      // Arrange
      const playerId = 'player1';
      when(() => mockDataSource.addActionCardToPlayer(playerId, testActionCard))
          .thenThrow(Exception('Player already has 3 cards'));

      // Act & Assert
      expect(
        () => mockDataSource.addActionCardToPlayer(playerId, testActionCard),
        throwsException,
      );
    });

    test('should define removeActionCardFromPlayer method', () {
      // Arrange
      const playerId = 'player1';
      when(() => mockDataSource.removeActionCardFromPlayer(playerId, testActionCard))
          .thenReturn(null);

      // Act & Assert
      expect(
        () => mockDataSource.removeActionCardFromPlayer(playerId, testActionCard),
        returnsNormally,
      );
      verify(() => mockDataSource.removeActionCardFromPlayer(playerId, testActionCard))
          .called(1);
    });

    test('should handle exception when removing card player doesn\'t have', () {
      // Arrange
      const playerId = 'player1';
      when(() => mockDataSource.removeActionCardFromPlayer(playerId, testActionCard))
          .thenThrow(Exception('Player doesn\'t have this card'));

      // Act & Assert
      expect(
        () => mockDataSource.removeActionCardFromPlayer(playerId, testActionCard),
        throwsException,
      );
    });

    test('should define drawActionCard method', () {
      // Arrange
      when(() => mockDataSource.drawActionCard()).thenReturn(testActionCard);

      // Act
      final result = mockDataSource.drawActionCard();

      // Assert
      expect(result, equals(testActionCard));
      verify(() => mockDataSource.drawActionCard()).called(1);
    });

    test('should return null when draw pile is empty', () {
      // Arrange
      when(() => mockDataSource.drawActionCard()).thenReturn(null);

      // Act
      final result = mockDataSource.drawActionCard();

      // Assert
      expect(result, isNull);
      verify(() => mockDataSource.drawActionCard()).called(1);
    });

    test('should define discardActionCard method', () {
      // Arrange
      when(() => mockDataSource.discardActionCard(testActionCard))
          .thenReturn(null);

      // Act & Assert
      expect(
        () => mockDataSource.discardActionCard(testActionCard),
        returnsNormally,
      );
      verify(() => mockDataSource.discardActionCard(testActionCard)).called(1);
    });

    test('should define shuffleActionCards method', () {
      // Arrange
      when(() => mockDataSource.shuffleActionCards()).thenReturn(null);

      // Act & Assert
      expect(
        () => mockDataSource.shuffleActionCards(),
        returnsNormally,
      );
      verify(() => mockDataSource.shuffleActionCards()).called(1);
    });

    test('should handle multiple operations in sequence', () {
      // Arrange
      const playerId = 'player1';
      when(() => mockDataSource.drawActionCard()).thenReturn(testActionCard);
      when(() => mockDataSource.addActionCardToPlayer(playerId, testActionCard))
          .thenReturn(null);
      when(() => mockDataSource.getPlayerActionCards(playerId))
          .thenReturn([testActionCard]);

      // Act
      final drawnCard = mockDataSource.drawActionCard();
      mockDataSource.addActionCardToPlayer(playerId, drawnCard!);
      final playerCards = mockDataSource.getPlayerActionCards(playerId);

      // Assert
      expect(drawnCard, equals(testActionCard));
      expect(playerCards, contains(testActionCard));
      verify(() => mockDataSource.drawActionCard()).called(1);
      verify(() => mockDataSource.addActionCardToPlayer(playerId, testActionCard))
          .called(1);
      verify(() => mockDataSource.getPlayerActionCards(playerId)).called(1);
    });
  });
}