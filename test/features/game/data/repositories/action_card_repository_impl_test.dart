import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/data/repositories/action_card_repository_impl.dart';
import 'package:ojyx/features/game/data/datasources/action_card_local_datasource.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

class MockActionCardLocalDataSource extends Mock
    implements ActionCardLocalDataSource {}

void main() {
  late ActionCardRepositoryImpl repository;
  late MockActionCardLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockActionCardLocalDataSource();
    repository = ActionCardRepositoryImpl(mockDataSource);
  });

  group('ActionCardRepositoryImpl', () {
    final testCard = ActionCard(
      id: 'test-1',
      type: ActionCardType.teleport,
      name: 'Téléportation',
      description: 'Échangez deux cartes',
      timing: ActionTiming.optional,
      target: ActionTarget.self,
    );

    test('should get available action cards from datasource', () async {
      // Arrange
      final cards = [testCard];
      when(() => mockDataSource.getAvailableActionCards()).thenAnswer((_) async => cards);

      // Act
      final result = await repository.getAvailableActionCards();

      // Assert
      expect(result, equals(cards));
      verify(() => mockDataSource.getAvailableActionCards()).called(1);
    });

    test('should get player action cards from datasource', () async {
      // Arrange
      final playerId = 'player1';
      final cards = [testCard];
      when(
        () => mockDataSource.getPlayerActionCards(playerId),
      ).thenAnswer((_) async => cards);

      // Act
      final result = await repository.getPlayerActionCards(playerId);

      // Assert
      expect(result, equals(cards));
      verify(() => mockDataSource.getPlayerActionCards(playerId)).called(1);
    });

    test('should add action card to player through datasource', () async {
      // Arrange
      final playerId = 'player1';
      when(
        () => mockDataSource.addActionCardToPlayer(playerId, testCard),
      ).thenAnswer((_) async {});

      // Act
      await repository.addActionCardToPlayer(playerId, testCard);

      // Assert
      verify(
        () => mockDataSource.addActionCardToPlayer(playerId, testCard),
      ).called(1);
    });

    test('should remove action card from player through datasource', () async {
      // Arrange
      final playerId = 'player1';
      when(
        () => mockDataSource.removeActionCardFromPlayer(playerId, testCard),
      ).thenAnswer((_) async {});

      // Act
      await repository.removeActionCardFromPlayer(playerId, testCard);

      // Assert
      verify(
        () => mockDataSource.removeActionCardFromPlayer(playerId, testCard),
      ).called(1);
    });

    test('should draw action card from datasource', () async {
      // Arrange
      when(() => mockDataSource.drawActionCard()).thenAnswer((_) async => testCard);

      // Act
      final result = await repository.drawActionCard();

      // Assert
      expect(result, equals(testCard));
      verify(() => mockDataSource.drawActionCard()).called(1);
    });

    test('should return null when drawing from empty pile', () async {
      // Arrange
      when(() => mockDataSource.drawActionCard()).thenAnswer((_) async => null);

      // Act
      final result = await repository.drawActionCard();

      // Assert
      expect(result, isNull);
      verify(() => mockDataSource.drawActionCard()).called(1);
    });

    test('should discard action card through datasource', () async {
      // Arrange
      when(() => mockDataSource.discardActionCard(testCard)).thenAnswer((_) async {});

      // Act
      await repository.discardActionCard(testCard);

      // Assert
      verify(() => mockDataSource.discardActionCard(testCard)).called(1);
    });

    test('should shuffle action cards through datasource', () async {
      // Arrange
      when(() => mockDataSource.shuffleActionCards()).thenAnswer((_) async {});

      // Act
      await repository.shuffleActionCards();

      // Assert
      verify(() => mockDataSource.shuffleActionCards()).called(1);
    });

    test(
      'should propagate exception when adding card to player with full hand',
      () {
        // Arrange
        final playerId = 'player1';
        when(
          () => mockDataSource.addActionCardToPlayer(playerId, testCard),
        ).thenThrow(Exception('GamePlayer cannot have more than 3 action cards'));

        // Act & Assert
        expect(
          () => repository.addActionCardToPlayer(playerId, testCard),
          throwsException,
        );
      },
    );

    test(
      'should propagate exception when removing card player does not have',
      () {
        // Arrange
        final playerId = 'player1';
        when(
          () => mockDataSource.removeActionCardFromPlayer(playerId, testCard),
        ).thenThrow(Exception('GamePlayer does not have this action card'));

        // Act & Assert
        expect(
          () => repository.removeActionCardFromPlayer(playerId, testCard),
          throwsException,
        );
      },
    );
  });
}
