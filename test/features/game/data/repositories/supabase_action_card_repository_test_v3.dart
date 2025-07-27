import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/data/datasources/supabase_action_card_datasource.dart';
import 'package:ojyx/features/game/data/repositories/supabase_action_card_repository.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../helpers/supabase_test_helpers.dart';

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
    const testCard = ActionCard(
      id: 'test-card',
      type: ActionCardType.teleport,
      name: 'Test Card',
      description: 'Test',
      timing: ActionTiming.optional,
      target: ActionTarget.self,
    );

    test('should return action cards from datasource', () async {
      // Test getAvailableActionCards
      final availableCards = [testCard];
      when(
        () => mockDataSource.getAvailableActionCards(),
      ).thenAnswer((_) async => availableCards);

      final availableResult = await repository.getAvailableActionCards();
      expect(availableResult, hasLength(1));
      expect(availableResult.first.id, equals('test-card'));

      // Test getPlayerActionCards
      final playerCards = [testCard];
      when(
        () => mockDataSource.getPlayerActionCards(testPlayerId),
      ).thenAnswer((_) async => playerCards);

      final playerResult = await repository.getPlayerActionCards(testPlayerId);
      expect(playerResult, hasLength(1));
      expect(playerResult.first.type, equals(ActionCardType.teleport));
    });

    test('should manage player card operations successfully', () async {
      // Setup mock responses
      when(
        () => mockDataSource.addActionCardToPlayer(testPlayerId, testCard),
      ).thenAnswer((_) async {});
      when(
        () => mockDataSource.removeActionCardFromPlayer(testPlayerId, testCard),
      ).thenAnswer((_) async {});

      // Test adding card completes successfully
      await expectLater(
        repository.addActionCardToPlayer(testPlayerId, testCard),
        completes,
      );

      // Test removing card completes successfully
      await expectLater(
        repository.removeActionCardFromPlayer(testPlayerId, testCard),
        completes,
      );
    });

    test('should handle deck operations correctly', () async {
      // Test drawActionCard - success case
      when(
        () => mockDataSource.drawActionCard(),
      ).thenAnswer((_) async => testCard);
      final drawnCard = await repository.drawActionCard();
      expect(drawnCard, isNotNull);
      expect(drawnCard!.id, equals('test-card'));

      // Test drawActionCard - empty deck case
      when(() => mockDataSource.drawActionCard()).thenAnswer((_) async => null);
      final emptyResult = await repository.drawActionCard();
      expect(emptyResult, isNull);

      // Test discard, shuffle, and initialize operations complete successfully
      when(
        () => mockDataSource.discardActionCard(testCard),
      ).thenAnswer((_) async {});
      when(() => mockDataSource.shuffleActionCards()).thenAnswer((_) async {});
      when(() => mockDataSource.initializeDeck()).thenAnswer((_) async {});

      await expectLater(repository.discardActionCard(testCard), completes);
      await expectLater(repository.shuffleActionCards(), completes);
      await expectLater(repository.initializeDeck(), completes);
    });
  });
}
