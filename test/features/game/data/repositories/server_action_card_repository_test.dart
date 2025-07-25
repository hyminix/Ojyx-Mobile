import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/game/data/repositories/server_action_card_repository.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('ServerActionCardRepository', () {
    late ServerActionCardRepository repository;
    late MockSupabaseClient mockSupabase;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      repository = ServerActionCardRepository(mockSupabase);
    });

    group('getAvailableActionCards', () {
      test('should return list of available action cards', () async {
        final cards = await repository.getAvailableActionCards();

        expect(cards, isNotEmpty);
        expect(cards.length, greaterThanOrEqualTo(4));

        // Verify specific cards exist
        expect(
          cards.any((card) => card.type == ActionCardType.teleport),
          isTrue,
        );
        expect(
          cards.any((card) => card.type == ActionCardType.turnAround),
          isTrue,
        );
        expect(cards.any((card) => card.type == ActionCardType.peek), isTrue);
        expect(cards.any((card) => card.type == ActionCardType.swap), isTrue);
      });

      test('should return cards with correct properties', () async {
        final cards = await repository.getAvailableActionCards();
        final teleportCard = cards.firstWhere(
          (card) => card.type == ActionCardType.teleport,
        );

        expect(teleportCard.id, 'teleport_1');
        expect(teleportCard.name, 'Téléportation');
        expect(teleportCard.timing, ActionTiming.optional);
        expect(teleportCard.target, ActionTarget.self);
      });
    });

    test(
      'should throw UnsupportedError for deprecated client-side methods',
      () {
        const testCard = ActionCard(
          id: 'test',
          type: ActionCardType.peek,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        // All deprecated methods should throw UnsupportedError
        expect(
          () => repository.getPlayerActionCards('player1'),
          throwsA(isA<UnsupportedError>()),
        );
        expect(
          () => repository.addActionCardToPlayer('player1', testCard),
          throwsA(isA<UnsupportedError>()),
        );
        expect(
          () => repository.removeActionCardFromPlayer('player1', testCard),
          throwsA(isA<UnsupportedError>()),
        );
        expect(
          () => repository.drawActionCard(),
          throwsA(isA<UnsupportedError>()),
        );
        expect(
          () => repository.discardActionCard(testCard),
          throwsA(isA<UnsupportedError>()),
        );
        expect(
          () => repository.shuffleActionCards(),
          throwsA(isA<UnsupportedError>()),
        );
      },
    );

    group('helper methods', () {
      test('getActionCardByType should return correct card', () async {
        final card = await repository.getActionCardByType(
          ActionCardType.teleport,
        );

        expect(card, isNotNull);
        expect(card!.type, ActionCardType.teleport);
        expect(card.name, 'Téléportation');
      });

      test('getActionCardByType should return null for unknown type', () async {
        // Create a custom type that doesn't exist in the available cards
        final cards = await repository.getAvailableActionCards();
        // Find a type that doesn't exist
        ActionCardType? nonExistentType;
        for (final type in ActionCardType.values) {
          if (!cards.any((card) => card.type == type)) {
            nonExistentType = type;
            break;
          }
        }

        if (nonExistentType != null) {
          final card = await repository.getActionCardByType(nonExistentType);
          expect(card, isNull);
        }
      });

      test('should correctly identify action timing types', () {
        const immediateCard = ActionCard(
          id: 'immediate',
          type: ActionCardType.turnAround,
          name: 'Immediate',
          description: 'Test',
          timing: ActionTiming.immediate,
          target: ActionTarget.none,
        );
        const optionalCard = ActionCard(
          id: 'optional',
          type: ActionCardType.peek,
          name: 'Optional',
          description: 'Test',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );
        const reactiveCard = ActionCard(
          id: 'reactive',
          type: ActionCardType.shield,
          name: 'Reactive',
          description: 'Test',
          timing: ActionTiming.reactive,
          target: ActionTarget.none,
        );

        // Test immediate action detection
        expect(repository.isImmediateAction(immediateCard), isTrue);
        expect(repository.isImmediateAction(optionalCard), isFalse);
        expect(repository.isImmediateAction(reactiveCard), isFalse);

        // Test optional action detection
        expect(repository.isOptionalAction(optionalCard), isTrue);
        expect(repository.isOptionalAction(immediateCard), isFalse);
        expect(repository.isOptionalAction(reactiveCard), isFalse);

        // Test reactive action detection
        expect(repository.isReactiveAction(reactiveCard), isTrue);
        expect(repository.isReactiveAction(immediateCard), isFalse);
        expect(repository.isReactiveAction(optionalCard), isFalse);
      });
    });

    test('should have all server-side methods defined', () {
      expect(repository.validateActionCardUse, isA<Function>());
      expect(repository.processActionCardUse, isA<Function>());
      expect(repository.validateActionTiming, isA<Function>());
    });
  });
}
