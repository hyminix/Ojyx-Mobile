import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/db_player_grid_model.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('DbPlayerGridModel', () {
    late DbPlayerGridModel model;
    late List<Card> testCards;
    late List<ActionCard> testActionCards;

    setUp(() {
      testCards = [
        const Card(value: 5, isRevealed: true),
        const Card(value: 10, isRevealed: false),
        const Card(value: -2, isRevealed: true),
      ];

      testActionCards = [
        const ActionCard(
          id: 'action1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Move a card',
        ),
        const ActionCard(
          id: 'action2',
          type: ActionCardType.swap,
          name: 'Swap',
          description: 'Swap two cards',
          timing: ActionTiming.immediate,
          target: ActionTarget.self,
        ),
      ];

      model = DbPlayerGridModel(
        id: 'grid-123',
        gameStateId: 'game-456',
        playerId: 'player-789',
        gridCards: testCards,
        actionCards: testActionCards,
        score: 13,
        position: 1,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1, 10, 0),
      );
    });

    test('should be a data layer model with JSON serialization', () {
      // DbPlayerGridModel should support JSON serialization
      expect(model.id, equals('grid-123'));
      expect(model.gameStateId, equals('game-456'));
      expect(model.playerId, equals('player-789'));
      expect(model.gridCards, equals(testCards));
      expect(model.actionCards, equals(testActionCards));
      expect(model.score, equals(13));
      expect(model.position, equals(1));
      expect(model.isActive, isTrue);
      expect(model.hasRevealedAll, isFalse);
    });

    test('should serialize to JSON correctly', () {
      final json = model.toJson();

      expect(json['id'], equals('grid-123'));
      expect(json['game_state_id'], equals('game-456'));
      expect(json['player_id'], equals('player-789'));
      expect(json['grid_cards'], isA<List>());
      expect(json['grid_cards'].length, equals(3));
      expect(json['action_cards'], isA<List>());
      expect(json['action_cards'].length, equals(2));
      expect(json['score'], equals(13));
      expect(json['position'], equals(1));
      expect(json['is_active'], isTrue);
      expect(json['has_revealed_all'], isFalse);
      expect(json['created_at'], equals('2024-01-01T00:00:00.000'));
      expect(json['updated_at'], equals('2024-01-01T10:00:00.000'));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'grid-999',
        'game_state_id': 'game-888',
        'player_id': 'player-777',
        'grid_cards': [
          {'value': 5, 'is_revealed': true},
          {'value': 10, 'is_revealed': false},
        ],
        'action_cards': [
          {
            'id': 'action3',
            'type': 'teleport',
            'name': 'Teleport',
            'description': 'Move card',
            'timing': 'optional',
            'target': 'none',
            'parameters': <String, dynamic>{},
          },
        ],
        'score': 15,
        'position': 2,
        'is_active': false,
        'has_revealed_all': true,
        'created_at': '2024-01-02T00:00:00.000',
        'updated_at': '2024-01-02T12:00:00.000',
      };

      final deserialized = DbPlayerGridModel.fromJson(json);

      expect(deserialized.id, equals('grid-999'));
      expect(deserialized.gameStateId, equals('game-888'));
      expect(deserialized.playerId, equals('player-777'));
      expect(deserialized.gridCards.length, equals(2));
      expect(deserialized.gridCards[0].value, equals(5));
      expect(deserialized.gridCards[0].isRevealed, isTrue);
      expect(deserialized.actionCards.length, equals(1));
      expect(deserialized.actionCards[0].id, equals('action3'));
      expect(deserialized.score, equals(15));
      expect(deserialized.position, equals(2));
      expect(deserialized.isActive, isFalse);
      expect(deserialized.hasRevealedAll, isTrue);
    });

    test('should convert to Supabase JSON format', () {
      final supabaseJson = model.toSupabaseJson();

      expect(supabaseJson['id'], equals('grid-123'));
      expect(supabaseJson['game_state_id'], equals('game-456'));
      expect(supabaseJson['player_id'], equals('player-789'));
      
      // Grid cards should be serialized as JSON array
      expect(supabaseJson['grid_cards'], isA<List>());
      final gridCards = supabaseJson['grid_cards'] as List;
      expect(gridCards.length, equals(3));
      expect(gridCards[0]['value'], equals(5));
      expect(gridCards[0]['is_revealed'], isTrue);
      
      // Action cards should be serialized as JSON array
      expect(supabaseJson['action_cards'], isA<List>());
      final actionCards = supabaseJson['action_cards'] as List;
      expect(actionCards.length, equals(2));
      expect(actionCards[0]['id'], equals('action1'));
      expect(actionCards[0]['type'], equals('teleport'));
      
      expect(supabaseJson['score'], equals(13));
      expect(supabaseJson['position'], equals(1));
      expect(supabaseJson['is_active'], isTrue);
      expect(supabaseJson['has_revealed_all'], isFalse);
      expect(supabaseJson['created_at'], equals('2024-01-01T00:00:00.000'));
      expect(supabaseJson['updated_at'], equals('2024-01-01T10:00:00.000'));
    });

    test('should handle empty collections correctly', () {
      final emptyModel = DbPlayerGridModel(
        id: 'empty-grid',
        gameStateId: 'game-123',
        playerId: 'player-123',
        gridCards: [],
        actionCards: [],
        score: 0,
        position: 0,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final json = emptyModel.toJson();
      expect(json['grid_cards'], isEmpty);
      expect(json['action_cards'], isEmpty);

      final supabaseJson = emptyModel.toSupabaseJson();
      expect(supabaseJson['grid_cards'], isEmpty);
      expect(supabaseJson['action_cards'], isEmpty);
    });

    test('should support Freezed features', () {
      // Test copyWith
      final updated = model.copyWith(
        score: 20,
        hasRevealedAll: true,
      );

      expect(updated.score, equals(20));
      expect(updated.hasRevealedAll, isTrue);
      expect(updated.id, equals(model.id));
      expect(updated.gridCards, equals(model.gridCards));

      // Test equality
      final sameModel = DbPlayerGridModel(
        id: 'grid-123',
        gameStateId: 'game-456',
        playerId: 'player-789',
        gridCards: testCards,
        actionCards: testActionCards,
        score: 13,
        position: 1,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1, 10, 0),
      );

      expect(model, equals(sameModel));
    });
  });
}