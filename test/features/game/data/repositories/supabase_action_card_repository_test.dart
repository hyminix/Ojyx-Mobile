import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/data/datasources/supabase_action_card_datasource.dart';
import 'package:ojyx/features/game/data/repositories/supabase_action_card_repository.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseActionCardDataSource extends Mock
    implements SupabaseActionCardDataSource {}

class FakeActionCard extends Fake implements ActionCard {}

void main() {
  late SupabaseActionCardRepository repository;
  late MockSupabaseActionCardDataSource mockDataSource;

  const testGameStateId = 'test-game-state-id';
  const testPlayerId = 'test-player-id';

  setUp(() {
    registerFallbackValue(FakeActionCard());
    mockDataSource = MockSupabaseActionCardDataSource();
    repository = SupabaseActionCardRepository(mockDataSource);
  });

  group('SupabaseActionCardRepository', () {
    group('getAvailableActionCards', () {
      test('should return list of action cards from datasource', () async {
        // Arrange
        final expectedCards = [
          const ActionCard(
            id: 'card-1',
            type: ActionCardType.teleport,
            name: 'Téléportation',
            description: 'Échangez deux cartes',
            timing: ActionTiming.optional,
            target: ActionTarget.self,
          ),
          const ActionCard(
            id: 'card-2',
            type: ActionCardType.skip,
            name: 'Saut',
            description: 'Passer un tour',
            timing: ActionTiming.optional,
            target: ActionTarget.none,
          ),
        ];

        when(
          () => mockDataSource.getAvailableActionCards(),
        ).thenAnswer((_) async => expectedCards);

        // Act
        final result = await repository.getAvailableActionCards();

        // Assert
        expect(result, expectedCards);
        verify(() => mockDataSource.getAvailableActionCards()).called(1);
      });
    });

    group('getPlayerActionCards', () {
      test('should return player action cards from datasource', () async {
        // Arrange
        final expectedCards = [
          const ActionCard(
            id: 'card-1',
            type: ActionCardType.shield,
            name: 'Bouclier',
            description: 'Protection',
            timing: ActionTiming.reactive,
            target: ActionTarget.self,
          ),
        ];

        when(
          () => mockDataSource.getPlayerActionCards(testPlayerId),
        ).thenAnswer((_) async => expectedCards);

        // Act
        final result = await repository.getPlayerActionCards(testPlayerId);

        // Assert
        expect(result, expectedCards);
        verify(
          () => mockDataSource.getPlayerActionCards(testPlayerId),
        ).called(1);
      });
    });

    group('addActionCardToPlayer', () {
      test('should call datasource to add card', () async {
        // Arrange
        const card = ActionCard(
          id: 'card-1',
          type: ActionCardType.draw,
          name: 'Pioche',
          description: 'Piochez 2 cartes',
          timing: ActionTiming.optional,
          target: ActionTarget.deck,
        );

        when(
          () => mockDataSource.addActionCardToPlayer(testPlayerId, card),
        ).thenAnswer((_) async {});

        // Act
        await repository.addActionCardToPlayer(testPlayerId, card);

        // Assert
        verify(
          () => mockDataSource.addActionCardToPlayer(testPlayerId, card),
        ).called(1);
      });
    });

    group('removeActionCardFromPlayer', () {
      test('should call datasource to remove card', () async {
        // Arrange
        const card = ActionCard(
          id: 'card-1',
          type: ActionCardType.shield,
          name: 'Bouclier',
          description: 'Protection',
          timing: ActionTiming.reactive,
          target: ActionTarget.self,
        );

        when(
          () => mockDataSource.removeActionCardFromPlayer(testPlayerId, card),
        ).thenAnswer((_) async {});

        // Act
        await repository.removeActionCardFromPlayer(testPlayerId, card);

        // Assert
        verify(
          () => mockDataSource.removeActionCardFromPlayer(testPlayerId, card),
        ).called(1);
      });
    });

    group('drawActionCard', () {
      test('should return drawn card from datasource', () async {
        // Arrange
        const expectedCard = ActionCard(
          id: 'card-1',
          type: ActionCardType.teleport,
          name: 'Téléportation',
          description: 'Échangez deux cartes',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        when(
          () => mockDataSource.drawActionCard(),
        ).thenAnswer((_) async => expectedCard);

        // Act
        final result = await repository.drawActionCard();

        // Assert
        expect(result, expectedCard);
        verify(() => mockDataSource.drawActionCard()).called(1);
      });

      test('should return null when deck is empty', () async {
        // Arrange
        when(
          () => mockDataSource.drawActionCard(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.drawActionCard();

        // Assert
        expect(result, isNull);
        verify(() => mockDataSource.drawActionCard()).called(1);
      });
    });

    group('discardActionCard', () {
      test('should call datasource to discard card', () async {
        // Arrange
        const card = ActionCard(
          id: 'card-1',
          type: ActionCardType.teleport,
          name: 'Téléportation',
          description: 'Échangez deux cartes',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        when(
          () => mockDataSource.discardActionCard(card),
        ).thenAnswer((_) async {});

        // Act
        await repository.discardActionCard(card);

        // Assert
        verify(() => mockDataSource.discardActionCard(card)).called(1);
      });
    });

    group('shuffleActionCards', () {
      test('should call datasource to shuffle cards', () async {
        // Arrange
        when(
          () => mockDataSource.shuffleActionCards(),
        ).thenAnswer((_) async {});

        // Act
        await repository.shuffleActionCards();

        // Assert
        verify(() => mockDataSource.shuffleActionCards()).called(1);
      });
    });

    group('initializeDeck', () {
      test('should call datasource to initialize deck', () async {
        // Arrange
        when(() => mockDataSource.initializeDeck()).thenAnswer((_) async {});

        // Act
        await repository.initializeDeck();

        // Assert
        verify(() => mockDataSource.initializeDeck()).called(1);
      });
    });
  });
}
