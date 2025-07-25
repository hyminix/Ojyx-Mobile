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

    test('should convert bidirectionally between model and JSON formats', () {
      // Test toJson() - serialization
      final json = model.toJson();
      expect(json['id'], equals('grid-123'));
      expect(json['game_state_id'], equals('game-456'));
      expect(json['player_id'], equals('player-789'));
      expect(json['grid_cards'], hasLength(3));
      expect(json['action_cards'], hasLength(2));
      expect(json['score'], equals(13));
      expect(json['is_active'], isTrue);
      expect(json['has_revealed_all'], isFalse);

      // Test fromJson() - deserialization with round-trip
      final roundTripModel = DbPlayerGridModel.fromJson(json);
      expect(roundTripModel.id, equals(model.id));
      expect(roundTripModel.gameStateId, equals(model.gameStateId));
      expect(roundTripModel.playerId, equals(model.playerId));
      expect(roundTripModel.gridCards.length, equals(model.gridCards.length));
      expect(roundTripModel.actionCards.length, equals(model.actionCards.length));
      expect(roundTripModel.score, equals(model.score));
      expect(roundTripModel.isActive, equals(model.isActive));
      expect(roundTripModel.hasRevealedAll, equals(model.hasRevealedAll));

      // Test toSupabaseJson() - Supabase format
      final supabaseJson = model.toSupabaseJson();
      expect(supabaseJson['grid_cards'], isA<List>());
      expect(supabaseJson['action_cards'], isA<List>());
      final gridCards = supabaseJson['grid_cards'] as List;
      final actionCards = supabaseJson['action_cards'] as List;
      expect(gridCards[0]['value'], equals(5));
      expect(gridCards[0]['is_revealed'], isTrue);
      expect(actionCards[0]['id'], equals('action1'));
      expect(actionCards[0]['type'], equals('teleport'));
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
      final updated = model.copyWith(score: 20, hasRevealedAll: true);

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
