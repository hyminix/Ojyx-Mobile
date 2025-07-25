import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('GameStateModel', () {
    late GameState testGameState;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime.now();

      final testPlayers = [
        GamePlayer(
          id: 'player1',
          name: 'Test GamePlayer 1',
          grid: PlayerGrid.empty(),
          actionCards: [],
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'Test GamePlayer 2',
          grid: PlayerGrid.empty(),
          actionCards: [],
          isHost: false,
        ),
      ];

      final testDeck = [
        const Card(value: 5, isRevealed: false),
        const Card(value: 10, isRevealed: false),
      ];

      final testDiscardPile = [const Card(value: 7, isRevealed: true)];

      final testActionDeck = [
        const ActionCard(
          id: 'action1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport to a new position',
        ),
      ];

      testGameState = GameState(
        roomId: 'room123',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        createdAt: testDateTime,
      );
    });

    // Test de getters/setters supprimé - violation du Principe n°4 (Bonne Granularité)
    // Les tests triviaux des propriétés auto-générées n'apportent aucune valeur

    test('should enable seamless game state persistence across clean architecture boundaries', () {
      // Test behavior: GameStateModel serves as the data layer adapter that enables
      // the domain layer to remain pure while supporting complex persistence needs
      // including partial updates, crash recovery, and multi-platform synchronization
      
      // Given: Various game states representing different persistence scenarios
      final persistenceScenarios = [
        // Scenario 1: Initial game creation
        (
          name: 'Game Initialization',
          domainState: GameState(
            roomId: 'new-game-room',
            players: [
              GamePlayer(id: 'host', name: 'Game Host', grid: PlayerGrid.empty(), isHost: true),
              GamePlayer(id: 'guest', name: 'First Guest', grid: PlayerGrid.empty()),
            ],
            currentPlayerIndex: 0,
            deck: List.generate(52, (i) => Card(value: i % 13 - 2)),
            discardPile: [],
            actionDeck: List.generate(20, (i) => ActionCard(
              id: 'action-$i',
              type: ActionCardType.values[i % ActionCardType.values.length],
              name: 'Action $i',
              description: 'Description for action $i',
            )),
            actionDiscard: [],
            status: GameStatus.waitingToStart,
            turnDirection: TurnDirection.clockwise,
            lastRound: false,
            createdAt: DateTime(2024, 1, 25, 14, 0),
          ),
          modelParams: {
            'id': 'new-game-123',
            'turnNumber': 0,
            'roundNumber': 0,
            'updatedAt': DateTime(2024, 1, 25, 14, 0),
          },
          expectations: {
            'preserves_initial_state': true,
            'no_game_progression': true,
          }
        ),
        // Scenario 2: Mid-game with complex state
        (
          name: 'Complex Mid-Game',
          domainState: GameState(
            roomId: 'active-game-room',
            players: [
              GamePlayer(
                id: 'player1',
                name: 'Leader',
                grid: PlayerGrid(cards: [
                  [const Card(value: 5, isRevealed: true), const Card(value: 5, isRevealed: false),
                   const Card(value: 5, isRevealed: false), const Card(value: -2, isRevealed: true)],
                  [const Card(value: 8, isRevealed: false), const Card(value: 3, isRevealed: true),
                   const Card(value: 0, isRevealed: false), const Card(value: 10, isRevealed: false)],
                  [const Card(value: 1, isRevealed: false), const Card(value: 4, isRevealed: false),
                   const Card(value: 7, isRevealed: false), const Card(value: 2, isRevealed: false)],
                ]),
                actionCards: [
                  const ActionCard(id: 'stored-1', type: ActionCardType.peek, name: 'Vision', description: 'Regarde une carte'),
                  const ActionCard(id: 'stored-2', type: ActionCardType.swap, name: 'Échange', description: 'Échange deux cartes'),
                ],
                isHost: true,
                // score calculated automatically via currentScore getter
              ),
              GamePlayer(
                id: 'player2',
                name: 'Challenger',
                grid: PlayerGrid(cards: List.generate(3, (r) => 
                  List.generate(4, (c) => Card(value: r * 4 + c, isRevealed: r == 0 && c < 2))
                )),
                actionCards: [],
                // score calculated automatically
              ),
            ],
            currentPlayerIndex: 1,
            deck: List.generate(25, (i) => Card(value: i % 13 - 2)), // Partially depleted
            discardPile: List.generate(15, (i) => Card(value: i % 13 - 2, isRevealed: true)),
            actionDeck: List.generate(5, (i) => ActionCard(id: 'deck-$i', type: ActionCardType.draw, name: 'Pioche', description: 'Piocher une carte')),
            actionDiscard: List.generate(8, (i) => ActionCard(id: 'used-$i', type: ActionCardType.shield, name: 'Used', description: 'Carte utilisée')),
            status: GameStatus.playing,
            turnDirection: TurnDirection.counterClockwise,
            lastRound: false,
            drawnCard: const Card(value: 6),
            initiatorPlayerId: 'player1',
            createdAt: DateTime(2024, 1, 25, 13, 0),
            startedAt: DateTime(2024, 1, 25, 13, 5),
          ),
          modelParams: {
            'id': 'active-game-456',
            'turnNumber': 23,
            'roundNumber': 1,
            'updatedAt': DateTime(2024, 1, 25, 13, 30),
          },
          expectations: {
            'preserves_game_progression': true,
            'maintains_drawn_card': true,
            'tracks_card_depletion': true,
          }
        ),
        // Scenario 3: End game state
        (
          name: 'Completed Game',
          domainState: GameState(
            roomId: 'finished-game-room',
            players: [
              GamePlayer(
                id: 'winner',
                name: 'Champion',
                grid: PlayerGrid(cards: List.generate(3, (r) => 
                  List.generate(4, (c) => Card(value: c <= 1 ? 0 : c, isRevealed: true))
                )),
                actionCards: [],
                isHost: true,
                // score calculated automatically
              ),
              GamePlayer(
                id: 'second',
                name: 'Runner Up',
                grid: PlayerGrid(cards: List.generate(3, (r) => 
                  List.generate(4, (c) => Card(value: r + c + 3, isRevealed: true))
                )),
                actionCards: [],
                // score calculated automatically
              ),
            ],
            currentPlayerIndex: 0,
            deck: [], // Exhausted
            discardPile: List.generate(40, (i) => Card(value: i % 13 - 2, isRevealed: true)),
            actionDeck: [],
            actionDiscard: List.generate(20, (i) => ActionCard(id: 'all-used-$i', type: ActionCardType.scout, name: 'Used', description: 'Carte utilisée')),
            status: GameStatus.finished,
            turnDirection: TurnDirection.clockwise,
            lastRound: true,
            initiatorPlayerId: 'winner',
            endRoundInitiator: 'winner',
            createdAt: DateTime(2024, 1, 25, 12, 0),
            startedAt: DateTime(2024, 1, 25, 12, 5),
            finishedAt: DateTime(2024, 1, 25, 12, 45),
          ),
          modelParams: {
            'id': 'finished-game-789',
            'turnNumber': 67,
            'roundNumber': 3,
            'updatedAt': DateTime(2024, 1, 25, 12, 45),
            'winnerId': 'winner',
          },
          expectations: {
            'game_completed': true,
            'winner_recorded': true,
            'all_cards_revealed': true,
          }
        ),
      ];
      
      // When/Then: Each scenario demonstrates proper clean architecture separation
      for (final scenario in persistenceScenarios) {
        // Domain to Model conversion (for persistence)
        final model = GameStateModel.fromDomainComplete(
          scenario.domainState,
          id: scenario.modelParams['id'] as String,
          turnNumber: scenario.modelParams['turnNumber'] as int,
          roundNumber: scenario.modelParams['roundNumber'] as int,
          updatedAt: scenario.modelParams['updatedAt'] as DateTime,
          // winnerId removed from constructor
        );
        
        // Verify model captures persistence metadata
        expect(model.id, equals(scenario.modelParams['id']),
            reason: '${scenario.name}: Model must have persistence ID');
        expect(model.turnNumber, equals(scenario.modelParams['turnNumber']),
            reason: '${scenario.name}: Model must track turn progression');
        expect(model.roundNumber, equals(scenario.modelParams['roundNumber']),
            reason: '${scenario.name}: Model must track round progression');
        expect(model.updatedAt, equals(scenario.modelParams['updatedAt']),
            reason: '${scenario.name}: Model must track update time');
        
        // Model to Domain conversion (for business logic)
        final reconstructed = model.toDomainComplete();
        
        // Verify domain integrity is maintained
        expect(reconstructed.roomId, equals(scenario.domainState.roomId),
            reason: '${scenario.name}: Room association must persist');
        expect(reconstructed.players.length, equals(scenario.domainState.players.length),
            reason: '${scenario.name}: Player count must persist');
        expect(reconstructed.status, equals(scenario.domainState.status),
            reason: '${scenario.name}: Game status must persist');
        expect(reconstructed.turnDirection, equals(scenario.domainState.turnDirection),
            reason: '${scenario.name}: Turn direction must persist');
        
        // Scenario-specific validations
        if (scenario.expectations['preserves_initial_state'] == true) {
          expect(reconstructed.status, equals(GameStatus.waitingToStart),
              reason: '${scenario.name}: Initial state should be waiting');
          expect(reconstructed.deck.length, equals(52),
              reason: '${scenario.name}: Initial deck should be complete');
          expect(reconstructed.actionDeck.length, equals(20),
              reason: '${scenario.name}: Initial action deck should be complete');
        }
        
        if (scenario.expectations['maintains_drawn_card'] == true) {
          expect(reconstructed.drawnCard, isNotNull,
              reason: '${scenario.name}: Drawn card must persist during play');
          expect(reconstructed.drawnCard?.value, equals(scenario.domainState.drawnCard?.value),
              reason: '${scenario.name}: Drawn card value must match');
        }
        
        if (scenario.expectations['game_completed'] == true) {
          expect(reconstructed.status, equals(GameStatus.finished),
              reason: '${scenario.name}: Completed game must have finished status');
          expect(reconstructed.finishedAt, isNotNull,
              reason: '${scenario.name}: Completed game must have finish timestamp');
          expect(model.winnerId, equals('winner'),
              reason: '${scenario.name}: Winner must be recorded in model');
        }
        
        // Verify complex nested data preservation
        if (scenario.domainState.players.isNotEmpty) {
          final firstPlayer = reconstructed.players[0];
          final originalFirst = scenario.domainState.players[0];
          
          expect(firstPlayer.id, equals(originalFirst.id),
              reason: '${scenario.name}: Player ID must persist');
          expect(firstPlayer.name, equals(originalFirst.name),
              reason: '${scenario.name}: Player name must persist');
          expect(firstPlayer.isHost, equals(originalFirst.isHost),
              reason: '${scenario.name}: Host status must persist');
          expect(firstPlayer.actionCards.length, equals(originalFirst.actionCards.length),
              reason: '${scenario.name}: Action card count must persist');
          
          // Verify grid if it has revealed cards
          final revealedCards = firstPlayer.grid.cards
              .expand((row) => row)
              .where((card) => card?.isRevealed == true)
              .length;
          final originalRevealed = originalFirst.grid.cards
              .expand((row) => row)
              .where((card) => card?.isRevealed == true)
              .length;
          expect(revealedCards, equals(originalRevealed),
              reason: '${scenario.name}: Revealed card count must persist');
        }
      }
    });

    test('should maintain data contract stability for API and storage compatibility', () {
      // Test behavior: JSON serialization must maintain a stable contract for
      // API compatibility, database storage, and cross-platform synchronization
      // while handling version migrations and backward compatibility
      
      // Given: Different serialization scenarios
      final serializationScenarios = [
        // Scenario 1: Minimal valid game state
        (
          name: 'Minimal Contract',
          model: GameStateModel(
            id: 'minimal-123',
            roomId: 'room-minimal',
            status: 'waitingToStart',
            currentPlayerId: 'player1',
            turnNumber: 0,
            roundNumber: 0,
            gameData: {
              'players': [],
              'deck': [],
              'discardPile': [],
              'currentPlayerIndex': 0,
              'turnDirection': 'clockwise',
              'lastRound': false,
            },
            // winnerId removed
            endedAt: null,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          expectations: {
            'minimal_fields': true,
            'no_optional_fields': true,
          }
        ),
        // Scenario 2: Complex game with all features
        (
          name: 'Full Contract',
          model: GameStateModel(
            id: 'complex-456',
            roomId: 'tournament-final',
            status: 'playing',
            currentPlayerId: 'pro-player-1',
            turnNumber: 45,
            roundNumber: 2,
            gameData: {
              'players': [
                {
                  'id': 'pro-player-1',
                  'name': 'Alice Pro',
                  'grid': {
                    'cards': List.generate(12, (i) => {'value': i, 'isRevealed': i < 4}),
                  },
                  'actionCards': [
                    {'id': 'ac1', 'type': 'swap', 'name': 'Tactical Swap'},
                    {'id': 'ac2', 'type': 'peek', 'name': 'Strategic Vision'},
                  ],
                  'isHost': true,
                  'score': 23,
                },
                {
                  'id': 'pro-player-2',
                  'name': 'Bob Master',
                  'grid': {
                    'cards': List.generate(12, (i) => {'value': i + 2, 'isRevealed': i < 2}),
                  },
                  'actionCards': [],
                  'isHost': false,
                  'score': 31,
                },
              ],
              'deck': List.generate(30, (i) => {'value': i % 13 - 2, 'isRevealed': false}),
              'discardPile': List.generate(15, (i) => {'value': i % 13 - 2, 'isRevealed': true}),
              'actionDeck': List.generate(5, (i) => {
                'id': 'deck-action-$i',
                'type': 'draw',
                'name': 'Draw Card',
              }),
              'actionDiscard': List.generate(10, (i) => {
                'id': 'used-action-$i',
                'type': 'shield',
                'name': 'Used Shield',
              }),
              'currentPlayerIndex': 0,
              'turnDirection': 'counterclockwise',
              'lastRound': false,
              'drawnCard': {'value': 7, 'isRevealed': false},
              'initiatorPlayerId': 'pro-player-1',
              'endRoundInitiator': null,
              'startedAt': '2024-01-25T14:00:00.000Z',
              'finishedAt': null,
            },
            // winnerId removed
            endedAt: null,
            createdAt: DateTime(2024, 1, 25, 13, 0),
            updatedAt: DateTime(2024, 1, 25, 14, 30),
          ),
          expectations: {
            'all_fields_present': true,
            'complex_nested_data': true,
          }
        ),
        // Scenario 3: Completed game for historical data
        (
          name: 'Historical Record',
          model: GameStateModel(
            id: 'archived-789',
            roomId: 'past-game-2023',
            status: 'finished',
            currentPlayerId: 'winner-id', // Last active player
            turnNumber: 89,
            roundNumber: 4,
            gameData: {
              'players': [
                {
                  'id': 'winner-id',
                  'name': 'Champion 2023',
                  'grid': {'cards': List.generate(12, (i) => {'value': 0, 'isRevealed': true})},
                  'actionCards': [],
                  'isHost': true,
                  'score': 8, // Exceptional score
                },
                {
                  'id': 'loser-id',
                  'name': 'Runner Up',
                  'grid': {'cards': List.generate(12, (i) => {'value': 5, 'isRevealed': true})},
                  'actionCards': [],
                  'isHost': false,
                  'score': 60,
                },
              ],
              'deck': [], // Exhausted
              'discardPile': List.generate(50, (i) => {'value': i % 13 - 2, 'isRevealed': true}),
              'actionDeck': [],
              'actionDiscard': List.generate(20, (i) => {'id': 'historic-$i', 'type': 'various'}),
              'currentPlayerIndex': 0,
              'turnDirection': 'clockwise',
              'lastRound': true,
              'initiatorPlayerId': 'winner-id',
              'endRoundInitiator': 'winner-id',
              'startedAt': '2023-12-31T20:00:00.000Z',
              'finishedAt': '2023-12-31T21:30:00.000Z',
            },
            winnerId: 'winner-id',
            endedAt: DateTime(2023, 12, 31, 21, 30),
            createdAt: DateTime(2023, 12, 31, 20, 0),
            updatedAt: DateTime(2023, 12, 31, 21, 30),
          ),
          expectations: {
            'historical_completeness': true,
            'winner_recorded': true,
            'timestamps_complete': true,
          }
        ),
      ];
      
      // When/Then: Verify serialization contract stability
      for (final scenario in serializationScenarios) {
        // Standard JSON serialization
        final json = scenario.model.toJson();
        
        // Verify required fields always present
        final requiredFields = ['id', 'room_id', 'status', 'current_player_id', 
                               'turn_number', 'round_number', 'game_data', 
                               'created_at', 'updated_at'];
        for (final field in requiredFields) {
          expect(json.containsKey(field), isTrue,
              reason: '${scenario.name}: Required field "$field" must be present');
          expect(json[field], isNotNull,
              reason: '${scenario.name}: Required field "$field" cannot be null');
        }
        
        // Verify optional fields handling
        if (scenario.model.winnerId == null) {
          expect(json['winner_id'], isNull,
              reason: '${scenario.name}: Null winner should serialize as null');
        } else {
          expect(json['winner_id'], equals(scenario.model.winnerId),
              reason: '${scenario.name}: Winner ID must be preserved');
        }
        
        if (scenario.model.endedAt == null) {
          expect(json['ended_at'], isNull,
              reason: '${scenario.name}: Null end time should serialize as null');
        } else {
          expect(json['ended_at'], isA<String>(),
              reason: '${scenario.name}: End time must serialize as ISO string');
        }
        
        // Verify round-trip stability
        final deserialized = GameStateModel.fromJson(json);
        final reserializedJson = deserialized.toJson();
        
        expect(reserializedJson, equals(json),
            reason: '${scenario.name}: JSON must be stable through round-trip');
        
        // Supabase-specific format validation
        final supabaseJson = scenario.model.toSupabaseJson();
        
        // Verify snake_case conversion
        expect(supabaseJson.containsKey('room_id'), isTrue,
            reason: '${scenario.name}: Supabase format must use snake_case');
        expect(supabaseJson.containsKey('current_player_id'), isTrue,
            reason: '${scenario.name}: Supabase format must use snake_case');
        expect(supabaseJson.containsKey('turn_number'), isTrue,
            reason: '${scenario.name}: Supabase format must use snake_case');
        expect(supabaseJson.containsKey('game_data'), isTrue,
            reason: '${scenario.name}: Supabase format must include game_data');
        
        // Verify timestamp format for Supabase
        expect(supabaseJson['created_at'], matches(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}$'),
            reason: '${scenario.name}: Timestamps must be ISO8601 with milliseconds');
        expect(supabaseJson['updated_at'], matches(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}$'),
            reason: '${scenario.name}: Timestamps must be ISO8601 with milliseconds');
        
        // Scenario-specific validations
        if (scenario.expectations['minimal_fields'] == true) {
          expect(json['winner_id'], isNull,
              reason: '${scenario.name}: Minimal state should have no winner');
          expect(json['ended_at'], isNull,
              reason: '${scenario.name}: Minimal state should have no end time');
        }
        
        if (scenario.expectations['complex_nested_data'] == true) {
          final gameData = json['game_data'] as Map<String, dynamic>;
          expect(gameData['players'], hasLength(2),
              reason: '${scenario.name}: Complex state should preserve player data');
          expect(gameData['deck'], hasLength(30),
              reason: '${scenario.name}: Complex state should preserve deck size');
          expect(gameData['drawnCard'], isNotNull,
              reason: '${scenario.name}: Complex state should preserve drawn card');
        }
        
        if (scenario.expectations['historical_completeness'] == true) {
          expect(json['winner_id'], equals('winner-id'),
              reason: '${scenario.name}: Historical record must preserve winner');
          expect(json['ended_at'], isNotNull,
              reason: '${scenario.name}: Historical record must have end timestamp');
          final gameData = json['game_data'] as Map<String, dynamic>;
          expect(gameData['finishedAt'], isNotNull,
              reason: '${scenario.name}: Historical record must preserve finish time in game data');
        }
      }
    });
  });
}
