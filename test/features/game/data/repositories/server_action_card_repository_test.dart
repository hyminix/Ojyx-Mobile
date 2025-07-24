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
      test('should return list of available action cards', () {
        final cards = repository.getAvailableActionCards();

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
        expect(
          cards.any((card) => card.type == ActionCardType.peek),
          isTrue,
        );
        expect(
          cards.any((card) => card.type == ActionCardType.swap),
          isTrue,
        );
      });

      test('should return cards with correct properties', () {
        final cards = repository.getAvailableActionCards();
        final teleportCard = cards.firstWhere(
          (card) => card.type == ActionCardType.teleport,
        );

        expect(teleportCard.id, 'teleport_1');
        expect(teleportCard.name, 'Téléportation');
        expect(teleportCard.timing, ActionTiming.optional);
        expect(teleportCard.target, ActionTarget.self);
      });
    });

    group('deprecated methods', () {
      test('getPlayerActionCards should throw UnsupportedError', () {
        expect(
          () => repository.getPlayerActionCards('player1'),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('addActionCardToPlayer should throw UnsupportedError', () {
        const card = ActionCard(
          id: 'test',
          type: ActionCardType.peek,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        expect(
          () => repository.addActionCardToPlayer('player1', card),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('removeActionCardFromPlayer should throw UnsupportedError', () {
        const card = ActionCard(
          id: 'test',
          type: ActionCardType.peek,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        expect(
          () => repository.removeActionCardFromPlayer('player1', card),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('drawActionCard should throw UnsupportedError', () {
        expect(
          () => repository.drawActionCard(),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('discardActionCard should throw UnsupportedError', () {
        const card = ActionCard(
          id: 'test',
          type: ActionCardType.peek,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        expect(
          () => repository.discardActionCard(card),
          throwsA(isA<UnsupportedError>()),
        );
      });

      test('shuffleActionCards should throw UnsupportedError', () {
        expect(
          () => repository.shuffleActionCards(),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('validateActionCardUse', () {
      test('should call rpc with correct parameters', () async {
        final response = {'valid': true, 'message': 'Card can be used'};
        when(() => mockSupabase.rpc(
          'validate_action_card_use',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.validateActionCardUse(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.teleport,
          targetData: {'position': 1},
        );

        expect(result, equals(response));
        verify(() => mockSupabase.rpc(
          'validate_action_card_use',
          params: {
            'p_game_state_id': 'game123',
            'p_player_id': 'player1',
            'p_action_card_type': 'teleport',
            'p_target_data': {'position': 1},
          },
        )).called(1);
      });

      test('should handle empty targetData', () async {
        final response = {'valid': true};
        when(() => mockSupabase.rpc(
          'validate_action_card_use',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        await repository.validateActionCardUse(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.turnAround,
        );

        verify(() => mockSupabase.rpc(
          'validate_action_card_use',
          params: {
            'p_game_state_id': 'game123',
            'p_player_id': 'player1',
            'p_action_card_type': 'turnAround',
            'p_target_data': {},
          },
        )).called(1);
      });

      test('should throw exception on error', () async {
        when(() => mockSupabase.rpc(
          'validate_action_card_use',
          params: any(named: 'params'),
        )).thenThrow(Exception('Database error'));

        expect(
          () => repository.validateActionCardUse(
            gameStateId: 'game123',
            playerId: 'player1',
            actionCardType: ActionCardType.teleport,
          ),
          throwsException,
        );
      });
    });

    group('processActionCardUse', () {
      test('should process valid action card use', () async {
        final response = {'valid': true, 'result': 'Card played successfully'};
        when(() => mockSupabase.rpc(
          'process_action_card',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.processActionCardUse(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.swap,
          targetData: {'opponentId': 'player2', 'position': 3},
        );

        expect(result, equals(response));
        verify(() => mockSupabase.rpc(
          'process_action_card',
          params: {
            'p_game_state_id': 'game123',
            'p_player_id': 'player1',
            'p_action_card_type': 'swap',
            'p_target_data': {'opponentId': 'player2', 'position': 3},
          },
        )).called(1);
      });

      test('should throw exception for invalid action', () async {
        final response = {'valid': false, 'error': 'Invalid target'};
        when(() => mockSupabase.rpc(
          'process_action_card',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        expect(
          () => repository.processActionCardUse(
            gameStateId: 'game123',
            playerId: 'player1',
            actionCardType: ActionCardType.swap,
            targetData: {'opponentId': 'invalid'},
          ),
          throwsException,
        );
      });

      test('should handle response without error message', () async {
        final response = {'valid': false};
        when(() => mockSupabase.rpc(
          'process_action_card',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        expect(
          () => repository.processActionCardUse(
            gameStateId: 'game123',
            playerId: 'player1',
            actionCardType: ActionCardType.swap,
          ),
          throwsA(
            predicate((e) =>
              e is Exception && e.toString().contains('Invalid action card use')),
          ),
        );
      });
    });

    group('validateActionTiming', () {
      test('should validate action timing', () async {
        final response = {'valid': true, 'canPlay': true};
        when(() => mockSupabase.rpc(
          'validate_action_timing',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.validateActionTiming(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.peek,
        );

        expect(result, equals(response));
        verify(() => mockSupabase.rpc(
          'validate_action_timing',
          params: {
            'p_game_state_id': 'game123',
            'p_player_id': 'player1',
            'p_action_card_type': 'peek',
          },
        )).called(1);
      });

      test('should handle validation error', () async {
        when(() => mockSupabase.rpc(
          'validate_action_timing',
          params: any(named: 'params'),
        )).thenThrow(Exception('Timing error'));

        expect(
          () => repository.validateActionTiming(
            gameStateId: 'game123',
            playerId: 'player1',
            actionCardType: ActionCardType.peek,
          ),
          throwsException,
        );
      });
    });

    group('helper methods', () {
      test('getActionCardByType should return correct card', () {
        final card = repository.getActionCardByType(ActionCardType.teleport);

        expect(card, isNotNull);
        expect(card!.type, ActionCardType.teleport);
        expect(card.name, 'Téléportation');
      });

      test('getActionCardByType should return null for unknown type', () {
        // Create a custom type that doesn't exist in the available cards
        final cards = repository.getAvailableActionCards();
        // Find a type that doesn't exist
        ActionCardType? nonExistentType;
        for (final type in ActionCardType.values) {
          if (!cards.any((card) => card.type == type)) {
            nonExistentType = type;
            break;
          }
        }

        if (nonExistentType != null) {
          final card = repository.getActionCardByType(nonExistentType);
          expect(card, isNull);
        }
      });

      test('isImmediateAction should identify immediate actions', () {
        const immediateCard = ActionCard(
          id: 'test',
          type: ActionCardType.turnAround,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.immediate,
          target: ActionTarget.none,
        );

        const optionalCard = ActionCard(
          id: 'test2',
          type: ActionCardType.peek,
          name: 'Test2',
          description: 'Test2',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        expect(repository.isImmediateAction(immediateCard), isTrue);
        expect(repository.isImmediateAction(optionalCard), isFalse);
      });

      test('isOptionalAction should identify optional actions', () {
        const optionalCard = ActionCard(
          id: 'test',
          type: ActionCardType.peek,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        const immediateCard = ActionCard(
          id: 'test2',
          type: ActionCardType.turnAround,
          name: 'Test2',
          description: 'Test2',
          timing: ActionTiming.immediate,
          target: ActionTarget.none,
        );

        expect(repository.isOptionalAction(optionalCard), isTrue);
        expect(repository.isOptionalAction(immediateCard), isFalse);
      });

      test('isReactiveAction should identify reactive actions', () {
        const reactiveCard = ActionCard(
          id: 'test',
          type: ActionCardType.counter,
          name: 'Test',
          description: 'Test',
          timing: ActionTiming.reactive,
          target: ActionTarget.none,
        );

        const optionalCard = ActionCard(
          id: 'test2',
          type: ActionCardType.peek,
          name: 'Test2',
          description: 'Test2',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        );

        expect(repository.isReactiveAction(reactiveCard), isTrue);
        expect(repository.isReactiveAction(optionalCard), isFalse);
      });
    });
  });
}