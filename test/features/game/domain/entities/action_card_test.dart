import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('ActionCard', () {
    test('should create ActionCard with required parameters', () {
      // Act
      const actionCard = ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Teleport Card',
        description: 'Teleport to another position',
      );

      // Assert
      expect(actionCard.id, equals('card1'));
      expect(actionCard.type, equals(ActionCardType.teleport));
      expect(actionCard.name, equals('Teleport Card'));
      expect(actionCard.description, equals('Teleport to another position'));
      expect(actionCard.timing, equals(ActionTiming.optional));
      expect(actionCard.target, equals(ActionTarget.none));
      expect(actionCard.parameters, isEmpty);
    });

    test('should create ActionCard with all parameters', () {
      // Act
      const actionCard = ActionCard(
        id: 'card2',
        type: ActionCardType.shield,
        name: 'Shield Card',
        description: 'Protect from attacks',
        timing: ActionTiming.reactive,
        target: ActionTarget.self,
        parameters: {'duration': 2, 'strength': 50},
      );

      // Assert
      expect(actionCard.id, equals('card2'));
      expect(actionCard.type, equals(ActionCardType.shield));
      expect(actionCard.timing, equals(ActionTiming.reactive));
      expect(actionCard.target, equals(ActionTarget.self));
      expect(actionCard.parameters['duration'], equals(2));
      expect(actionCard.parameters['strength'], equals(50));
    });

    group('isImmediate getter', () {
      test('should return true when timing is immediate', () {
        // Act
        const actionCard = ActionCard(
          id: 'card1',
          type: ActionCardType.bomb,
          name: 'Bomb',
          description: 'Explodes immediately',
          timing: ActionTiming.immediate,
        );

        // Assert
        expect(actionCard.isImmediate, isTrue);
        expect(actionCard.isOptional, isFalse);
        expect(actionCard.isReactive, isFalse);
      });

      test('should return false when timing is not immediate', () {
        // Act
        const actionCard = ActionCard(
          id: 'card1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport card',
          timing: ActionTiming.optional,
        );

        // Assert
        expect(actionCard.isImmediate, isFalse);
      });
    });

    group('isOptional getter', () {
      test('should return true when timing is optional', () {
        // Act
        const actionCard = ActionCard(
          id: 'card1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport card',
          timing: ActionTiming.optional,
        );

        // Assert
        expect(actionCard.isOptional, isTrue);
        expect(actionCard.isImmediate, isFalse);
        expect(actionCard.isReactive, isFalse);
      });

      test('should return true by default when timing not specified', () {
        // Act
        const actionCard = ActionCard(
          id: 'card1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport card',
        );

        // Assert
        expect(actionCard.isOptional, isTrue);
      });
    });

    group('isReactive getter', () {
      test('should return true when timing is reactive', () {
        // Act
        const actionCard = ActionCard(
          id: 'card1',
          type: ActionCardType.shield,
          name: 'Shield',
          description: 'Shield card',
          timing: ActionTiming.reactive,
        );

        // Assert
        expect(actionCard.isReactive, isTrue);
        expect(actionCard.isImmediate, isFalse);
        expect(actionCard.isOptional, isFalse);
      });
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

    group('ActionCardType enum', () {
      test('should have all expected card types', () {
        // Assert
        expect(ActionCardType.values.length, equals(21));
        expect(ActionCardType.values, contains(ActionCardType.teleport));
        expect(ActionCardType.values, contains(ActionCardType.turnAround));
        expect(ActionCardType.values, contains(ActionCardType.peek));
        expect(ActionCardType.values, contains(ActionCardType.swap));
        expect(ActionCardType.values, contains(ActionCardType.shield));
        expect(ActionCardType.values, contains(ActionCardType.draw));
        expect(ActionCardType.values, contains(ActionCardType.reveal));
        expect(ActionCardType.values, contains(ActionCardType.shuffle));
        expect(ActionCardType.values, contains(ActionCardType.steal));
        expect(ActionCardType.values, contains(ActionCardType.duplicate));
        expect(ActionCardType.values, contains(ActionCardType.skip));
        expect(ActionCardType.values, contains(ActionCardType.reverse));
        expect(ActionCardType.values, contains(ActionCardType.discard));
        expect(ActionCardType.values, contains(ActionCardType.freeze));
        expect(ActionCardType.values, contains(ActionCardType.mirror));
        expect(ActionCardType.values, contains(ActionCardType.bomb));
        expect(ActionCardType.values, contains(ActionCardType.heal));
        expect(ActionCardType.values, contains(ActionCardType.curse));
        expect(ActionCardType.values, contains(ActionCardType.gift));
        expect(ActionCardType.values, contains(ActionCardType.gamble));
        expect(ActionCardType.values, contains(ActionCardType.scout));
      });
    });

    group('ActionTiming enum', () {
      test('should have all expected timing types', () {
        // Assert
        expect(ActionTiming.values.length, equals(3));
        expect(ActionTiming.values, contains(ActionTiming.immediate));
        expect(ActionTiming.values, contains(ActionTiming.optional));
        expect(ActionTiming.values, contains(ActionTiming.reactive));
      });
    });

    group('ActionTarget enum', () {
      test('should have all expected target types', () {
        // Assert
        expect(ActionTarget.values.length, equals(7));
        expect(ActionTarget.values, contains(ActionTarget.self));
        expect(ActionTarget.values, contains(ActionTarget.singleOpponent));
        expect(ActionTarget.values, contains(ActionTarget.allOpponents));
        expect(ActionTarget.values, contains(ActionTarget.allPlayers));
        expect(ActionTarget.values, contains(ActionTarget.deck));
        expect(ActionTarget.values, contains(ActionTarget.discard));
        expect(ActionTarget.values, contains(ActionTarget.none));
      });
    });

    test('should support equality comparison', () {
      // Arrange
      const card1 = ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );

      const card2 = ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );

      const card3 = ActionCard(
        id: 'card2',
        type: ActionCardType.teleport,
        name: 'Teleport',
        description: 'Teleport card',
      );

      // Assert
      expect(card1, equals(card2));
      expect(card1, isNot(equals(card3)));
    });
  });
}
