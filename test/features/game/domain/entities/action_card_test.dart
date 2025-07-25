import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('ActionCard', () {
    test('should classify card timing behavior correctly for gameplay', () {
      // Test cases for different timing behaviors
      final testCases = [
        (ActionTiming.immediate, 'should trigger automatically when drawn'),
        (ActionTiming.optional, 'should allow player choice when to use'),
        (ActionTiming.reactive, 'should respond to opponent actions'),
      ];

      for (final (timing, expectedBehavior) in testCases) {
        final actionCard = ActionCard(
          id: 'test-card',
          type: ActionCardType.teleport,
          name: 'Test Card',
          description: expectedBehavior,
          timing: timing,
        );

        // Verify behavior classification for game logic
        switch (timing) {
          case ActionTiming.immediate:
            expect(
              actionCard.isImmediate,
              isTrue,
              reason: 'Should trigger automatically',
            );
            expect(actionCard.isOptional, isFalse);
            expect(actionCard.isReactive, isFalse);
            break;
          case ActionTiming.optional:
            expect(
              actionCard.isOptional,
              isTrue,
              reason: 'Should allow player choice',
            );
            expect(actionCard.isImmediate, isFalse);
            expect(actionCard.isReactive, isFalse);
            break;
          case ActionTiming.reactive:
            expect(
              actionCard.isReactive,
              isTrue,
              reason: 'Should respond to actions',
            );
            expect(actionCard.isImmediate, isFalse);
            expect(actionCard.isOptional, isFalse);
            break;
        }
      }
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        const actionCard = ActionCard(
          id: 'card1',
          type: ActionCardType.teleport,
          name: 'Teleport Card',
          description: 'Teleport to another position',
          timing: ActionTiming.immediate,
          target: ActionTarget.singleOpponent,
          parameters: {'range': 3},
        );

        // Act
        final json = actionCard.toJson();

        // Assert
        expect(json['id'], equals('card1'));
        expect(json['type'], equals('teleport'));
        expect(json['name'], equals('Teleport Card'));
        expect(json['description'], equals('Teleport to another position'));
        expect(json['timing'], equals('immediate'));
        expect(json['target'], equals('singleOpponent'));
        expect(json['parameters']['range'], equals(3));
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {
          'id': 'card2',
          'type': 'shield',
          'name': 'Shield Card',
          'description': 'Protect from attacks',
          'timing': 'reactive',
          'target': 'self',
          'parameters': {'duration': 2},
        };

        // Act
        final actionCard = ActionCard.fromJson(json);

        // Assert
        expect(actionCard.id, equals('card2'));
        expect(actionCard.type, equals(ActionCardType.shield));
        expect(actionCard.name, equals('Shield Card'));
        expect(actionCard.timing, equals(ActionTiming.reactive));
        expect(actionCard.target, equals(ActionTarget.self));
        expect(actionCard.parameters['duration'], equals(2));
      });
    });

    test('should preserve card identity for game state management', () {
      // Test behavior: cards with same ID should be considered equal in game logic
      const card1 = ActionCard(
        id: 'teleport-1',
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );

      const card2 = ActionCard(
        id: 'teleport-1', // Same ID
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );

      const differentCard = ActionCard(
        id: 'teleport-2', // Different ID
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );

      // Assert behavior: game should recognize same cards
      expect(
        card1,
        equals(card2),
        reason: 'Same ID cards should be equal for game logic',
      );
      expect(
        card1,
        isNot(equals(differentCard)),
        reason: 'Different cards should not be equal',
      );
    });
  });
}
