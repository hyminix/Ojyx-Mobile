import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/player_grid_model.dart';
import 'package:ojyx/features/game/data/models/db_player_grid_model.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('PlayerGridModel', () {
    test('should preserve competitive game state when converting to domain entity', () {
      // Given: A player grid with revealed cards and strategic action cards
      final gridModel = PlayerGridModel(
        id: 'grid-1',
        gameStateId: 'game-1',
        playerId: 'player-1',
        gridCards: [
          {'value': 10, 'is_revealed': true},
          {'value': -2, 'is_revealed': true},
          {'value': 5, 'is_revealed': false},
          {'value': 0, 'is_revealed': false},
          ...List.generate(8, (i) => {'value': i + 1, 'is_revealed': false}),
        ],
        actionCards: [
          {
            'id': 'action-1',
            'type': 'turnAround',
            'name': 'Demi-tour',
            'description': 'Inverse le sens',
            'timing': 'immediate',
            'target': 'all',
            'parameters': {},
          },
        ],
        score: 37,
        position: 2,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // When: Converting to domain entity
      final domainGrid = gridModel.toDomain();
      
      // Then: Game state is preserved for competitive play
      expect(domainGrid.cards, hasLength(3));
      expect(domainGrid.cards[0], hasLength(4));
      
      final revealedCards = domainGrid.cards
          .expand((row) => row)
          .where((card) => card?.isRevealed == true)
          .toList();
      expect(revealedCards, hasLength(2));
      expect(revealedCards.any((card) => card?.value == 10), isTrue);
      expect(revealedCards.any((card) => card?.value == -2), isTrue);
    });
    
    test('should maintain game integrity when converting to database format', () {
      // Given: A player grid with game state
      final gridModel = PlayerGridModel(
        id: 'grid-1',
        gameStateId: 'game-1',
        playerId: 'player-1',
        gridCards: List.generate(12, (i) => {'value': i, 'is_revealed': false}),
        actionCards: [],
        score: 25,
        position: 1,
        isActive: true,
        hasRevealedAll: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // When: Converting to database model
      final dbModel = gridModel.toDbPlayerGrid();
      
      // Then: Critical game data is preserved
      expect(dbModel.id, equals('grid-1'));
      expect(dbModel.gameStateId, equals('game-1'));
      expect(dbModel.playerId, equals('player-1'));
      expect(dbModel.gridCards, hasLength(12));
      expect(dbModel.score, equals(25));
      expect(dbModel.position, equals(1));
      expect(dbModel.isActive, isTrue);
    });

    test('should maintain data integrity through API serialization for reliable multiplayer synchronization', () {
      // Test behavior: JSON serialization must maintain perfect data fidelity for
      // real-time multiplayer synchronization via Supabase WebSockets, ensuring
      // all players see consistent game state across network boundaries
      
      // Given: Various game states representing different multiplayer scenarios
      final scenarios = [
        // Scenario 1: End-game state with full revelation
        (
          name: 'Endgame Revelation',
          model: PlayerGridModel(
            id: 'endgame-grid-001',
            gameStateId: 'final-round-game',
            playerId: 'initiator-player',
            gridCards: List.generate(12, (i) => {
              'value': i <= 5 ? i : -i, // Mix of positive and negative
              'is_revealed': true, // All revealed in endgame
            }),
            actionCards: [], // All action cards used
            score: 15, // Low competitive score
            position: 1, // Leading position
            isActive: true,
            hasRevealedAll: true, // Triggered game end
            createdAt: DateTime(2024, 1, 20, 18, 0),
            updatedAt: DateTime(2024, 1, 20, 18, 45),
          ),
          expectations: {
            'all_revealed': true,
            'action_cards_empty': true,
            'competitive_score': true,
          }
        ),
        // Scenario 2: Mid-game strategic state
        (
          name: 'Strategic Midgame',
          model: PlayerGridModel(
            id: 'midgame-grid-002',
            gameStateId: 'tactical-game',
            playerId: 'strategic-player',
            gridCards: [
              // Corner cards revealed for column strategy
              {'value': 5, 'is_revealed': true},
              {'value': 5, 'is_revealed': false},
              {'value': 5, 'is_revealed': false}, // Potential column
              {'value': 8, 'is_revealed': true},
              ...List.generate(8, (i) => {'value': i + 1, 'is_revealed': false}),
            ],
            actionCards: [
              {
                'id': 'swap-1',
                'type': 'swap',
                'name': 'Échange Stratégique',
                'description': 'Échange avec un adversaire',
                'timing': 'optional',
                'target': 'opponent',
                'parameters': {'range': 1},
              },
              {
                'id': 'peek-1',
                'type': 'peek',
                'name': 'Vision',
                'description': 'Regardez 2 cartes cachées',
                'timing': 'optional',
                'target': 'any',
                'parameters': {'count': 2},
              },
            ],
            score: 28,
            position: 3,
            isActive: true,
            hasRevealedAll: false,
            createdAt: DateTime(2024, 1, 20, 17, 30),
            updatedAt: DateTime(2024, 1, 20, 17, 35),
          ),
          expectations: {
            'partial_reveal': true,
            'has_action_cards': true,
            'mid_range_score': true,
          }
        ),
        // Scenario 3: Disconnected player state
        (
          name: 'Disconnected Player',
          model: PlayerGridModel(
            id: 'disconnected-grid-003',
            gameStateId: 'ongoing-game',
            playerId: 'timeout-player',
            gridCards: List.generate(12, (i) => {
              'value': i,
              'is_revealed': i < 4, // Some early reveals
            }),
            actionCards: [
              {
                'id': 'stored-1',
                'type': 'stored',
                'name': 'Action Stockée',
                'description': 'Non utilisée avant déconnexion',
                'timing': 'optional',
                'target': 'self',
                'parameters': {},
              },
            ],
            score: 35,
            position: 5,
            isActive: false, // Disconnected
            hasRevealedAll: false,
            createdAt: DateTime(2024, 1, 20, 16, 0),
            updatedAt: DateTime(2024, 1, 20, 17, 58), // 2 minutes before timeout
          ),
          expectations: {
            'inactive_state': true,
            'preserved_cards': true,
            'timeout_eligible': true,
          }
        ),
      ];
      
      // When/Then: Each scenario maintains data integrity through serialization
      for (final scenario in scenarios) {
        final json = scenario.model.toJson();
        
        // Verify JSON structure completeness
        expect(json.containsKey('id'), isTrue, 
            reason: '${scenario.name}: Must include ID for synchronization');
        expect(json.containsKey('game_state_id'), isTrue,
            reason: '${scenario.name}: Must include game reference');
        expect(json.containsKey('player_id'), isTrue,
            reason: '${scenario.name}: Must include player reference');
        expect(json.containsKey('grid_cards'), isTrue,
            reason: '${scenario.name}: Must include grid state');
        expect(json.containsKey('action_cards'), isTrue,
            reason: '${scenario.name}: Must include action cards');
        expect(json.containsKey('score'), isTrue,
            reason: '${scenario.name}: Must include current score');
        expect(json.containsKey('position'), isTrue,
            reason: '${scenario.name}: Must include ranking');
        expect(json.containsKey('is_active'), isTrue,
            reason: '${scenario.name}: Must include connection status');
        expect(json.containsKey('has_revealed_all'), isTrue,
            reason: '${scenario.name}: Must include endgame trigger status');
        
        // Verify round-trip fidelity
        final deserialized = PlayerGridModel.fromJson(json);
        
        expect(deserialized.id, equals(scenario.model.id),
            reason: '${scenario.name}: ID must survive serialization');
        expect(deserialized.gridCards.length, equals(scenario.model.gridCards.length),
            reason: '${scenario.name}: Grid size must be preserved');
        expect(deserialized.actionCards.length, equals(scenario.model.actionCards.length),
            reason: '${scenario.name}: Action cards must be preserved');
        expect(deserialized.score, equals(scenario.model.score),
            reason: '${scenario.name}: Score must be exact');
        expect(deserialized.position, equals(scenario.model.position),
            reason: '${scenario.name}: Position must be preserved');
        expect(deserialized.isActive, equals(scenario.model.isActive),
            reason: '${scenario.name}: Activity status must be preserved');
        expect(deserialized.hasRevealedAll, equals(scenario.model.hasRevealedAll),
            reason: '${scenario.name}: Endgame trigger must be preserved');
        
        // Verify scenario-specific expectations
        if (scenario.expectations['all_revealed'] == true) {
          final revealedCount = (deserialized.gridCards as List)
              .where((card) => card['is_revealed'] == true)
              .length;
          expect(revealedCount, equals(12),
              reason: '${scenario.name}: Endgame should have all cards revealed');
        }
        
        if (scenario.expectations['action_cards_empty'] == true) {
          expect(deserialized.actionCards, isEmpty,
              reason: '${scenario.name}: Endgame should have no action cards');
        }
        
        if (scenario.expectations['inactive_state'] == true) {
          expect(deserialized.isActive, isFalse,
              reason: '${scenario.name}: Disconnected player should be inactive');
        }
      }
    });
  });
}
