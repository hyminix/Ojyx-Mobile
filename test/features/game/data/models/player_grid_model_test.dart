import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/player_grid_model.dart';
import 'package:ojyx/features/game/domain/entities/db_player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('PlayerGridModel', () {
    test('should create from domain entity', () {
      // Given
      final cards = List.generate(12, (i) => Card(value: i, isRevealed: i < 2));
      final actionCards = [
        ActionCard(id: '1', type: ActionCardType.demiTour, isObligatory: true),
        ActionCard(id: '2', type: ActionCardType.teleportation),
      ];

      final playerGrid = DbPlayerGrid(
        id: 'grid-id',
        gameStateId: 'game-id',
        playerId: 'player-id',
        gridCards: cards,
        actionCards: actionCards,
        score: 42,
        position: 1,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // When
      final model = PlayerGridModel.fromDomain(playerGrid);

      // Then
      expect(model.id, equals('grid-id'));
      expect(model.gameStateId, equals('game-id'));
      expect(model.playerId, equals('player-id'));
      expect(model.gridCards, hasLength(12));
      expect(model.actionCards, hasLength(2));
      expect(model.score, equals(42));
      expect(model.position, equals(1));
      expect(model.isActive, isTrue);
      expect(model.hasRevealedAll, isFalse);
    });

    test('should convert to domain entity', () {
      // Given
      final gridCardsJson = List.generate(12, (i) => {
        'value': i,
        'is_revealed': i < 2,
      });

      final actionCardsJson = [
        {
          'id': '1',
          'type': 'demi_tour',
          'is_obligatory': true,
        },
        {
          'id': '2', 
          'type': 'teleportation',
          'is_obligatory': false,
        }
      ];

      final model = PlayerGridModel(
        id: 'grid-id',
        gameStateId: 'game-id',
        playerId: 'player-id',
        gridCards: gridCardsJson,
        actionCards: actionCardsJson,
        score: 42,
        position: 1,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // When
      final playerGrid = model.toDomain();

      // Then
      expect(playerGrid.id, equals('grid-id'));
      expect(playerGrid.gameStateId, equals('game-id'));
      expect(playerGrid.playerId, equals('player-id'));
      expect(playerGrid.gridCards, hasLength(12));
      expect(playerGrid.actionCards, hasLength(2));
      expect(playerGrid.score, equals(42));
      expect(playerGrid.position, equals(1));
      expect(playerGrid.isActive, isTrue);
      expect(playerGrid.hasRevealedAll, isFalse);
    });

    test('should serialize to JSON', () {
      // Given
      final model = PlayerGridModel(
        id: 'grid-id',
        gameStateId: 'game-id', 
        playerId: 'player-id',
        gridCards: [{'value': 5, 'is_revealed': true}],
        actionCards: [{'id': '1', 'type': 'teleportation', 'is_obligatory': false}],
        score: 25,
        position: 2,
        isActive: false,
        hasRevealedAll: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // When
      final json = model.toJson();

      // Then
      expect(json['id'], equals('grid-id'));
      expect(json['game_state_id'], equals('game-id'));
      expect(json['player_id'], equals('player-id'));
      expect(json['grid_cards'], isA<List>());
      expect(json['action_cards'], isA<List>());
      expect(json['score'], equals(25));
      expect(json['position'], equals(2));
      expect(json['is_active'], isFalse);
      expect(json['has_revealed_all'], isTrue);
    });

    test('should deserialize from JSON', () {
      // Given
      final json = {
        'id': 'grid-id',
        'game_state_id': 'game-id',
        'player_id': 'player-id',
        'grid_cards': [{'value': 3, 'is_revealed': false}],
        'action_cards': [],
        'score': 15,
        'position': 3,
        'is_active': true,
        'has_revealed_all': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      // When
      final model = PlayerGridModel.fromJson(json);

      // Then
      expect(model.id, equals('grid-id'));
      expect(model.gameStateId, equals('game-id'));
      expect(model.playerId, equals('player-id'));
      expect(model.gridCards, hasLength(1));
      expect(model.actionCards, isEmpty);
      expect(model.score, equals(15));
      expect(model.position, equals(3));
      expect(model.isActive, isTrue);
      expect(model.hasRevealedAll, isFalse);
    });

    test('should handle empty grids', () {
      // Given
      final json = {
        'id': 'grid-id',
        'game_state_id': 'game-id',
        'player_id': 'player-id',
        'grid_cards': [],
        'action_cards': [],
        'score': 0,
        'position': 1,
        'is_active': true,
        'has_revealed_all': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      // When
      final model = PlayerGridModel.fromJson(json);

      // Then
      expect(model.gridCards, isEmpty);
      expect(model.actionCards, isEmpty);
      expect(model.score, equals(0));
    });
  });
}