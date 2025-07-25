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

    test('should return available action cards when requested', () async {
      // Arrange
      final expectedCards = [testCard];
      when(() => mockDataSource.getAvailableActionCards()).thenAnswer((_) async => expectedCards);

      // Act
      final result = await repository.getAvailableActionCards();

      // Assert - Focus on the result, not the call
      expect(result, hasLength(1));
      expect(result.first.id, equals('test-1'));
      expect(result.first.type, equals(ActionCardType.teleport));
      expect(result.first.name, equals('Téléportation'));
    });

    test('should return player action cards when requested', () async {
      // Arrange
      final playerId = 'player1';
      final expectedCards = [testCard];
      when(() => mockDataSource.getPlayerActionCards(playerId)).thenAnswer((_) async => expectedCards);

      // Act
      final result = await repository.getPlayerActionCards(playerId);

      // Assert - Focus on the result
      expect(result, hasLength(1));
      expect(result.first.id, equals('test-1'));
      expect(result.first.timing, equals(ActionTiming.optional));
    });

    test('should successfully add action card to player', () async {
      // Arrange
      final playerId = 'player1';
      when(() => mockDataSource.addActionCardToPlayer(playerId, testCard)).thenAnswer((_) async {});

      // Act & Assert - Should complete without error
      await expectLater(
        repository.addActionCardToPlayer(playerId, testCard),
        completes,
      );
    });

    test('should successfully remove action card from player', () async {
      // Arrange
      final playerId = 'player1';
      when(() => mockDataSource.removeActionCardFromPlayer(playerId, testCard)).thenAnswer((_) async {});

      // Act & Assert - Should complete without error
      await expectLater(
        repository.removeActionCardFromPlayer(playerId, testCard),
        completes,
      );
    });

    test('should return drawn action card when available', () async {
      // Arrange
      when(() => mockDataSource.drawActionCard()).thenAnswer((_) async => testCard);

      // Act
      final result = await repository.drawActionCard();

      // Assert - Focus on the result content
      expect(result, isNotNull);
      expect(result!.id, equals('test-1'));
      expect(result.type, equals(ActionCardType.teleport));
    });

    test('should return null when no action cards available to draw', () async {
      // Arrange
      when(() => mockDataSource.drawActionCard()).thenAnswer((_) async => null);

      // Act
      final result = await repository.drawActionCard();

      // Assert - Focus on the result state
      expect(result, isNull);
    });

    test('should successfully discard action card', () async {
      // Arrange
      when(() => mockDataSource.discardActionCard(testCard)).thenAnswer((_) async {});

      // Act & Assert - Should complete without error
      await expectLater(
        repository.discardActionCard(testCard),
        completes,
      );
    });

    test('should successfully shuffle action cards', () async {
      // Arrange
      when(() => mockDataSource.shuffleActionCards()).thenAnswer((_) async {});

      // Act & Assert - Should complete without error
      await expectLater(
        repository.shuffleActionCards(),
        completes,
      );
    });

    test(
      'should propagate exception when adding card to player with full hand',
      () {
        // Arrange
        final playerId = 'player1';
        when(
          () => mockDataSource.addActionCardToPlayer(playerId, testCard),
        ).thenThrow(
          Exception('GamePlayer cannot have more than 3 action cards'),
        );

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
