import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('GameStateModel - Complete Mapping', () {
    test(
      'should preserve complete game state through domain-model-domain transformation for reliable persistence',
      () {
        // Test behavior: GameStateModel must act as a perfect bridge between the domain layer
        // and persistence layer, maintaining all game state details including player positions,
        // card distributions, action cards, and game flow metadata without data loss

        // Given: A complex mid-game state with all features active
        final complexGameState = GameState(
          roomId: 'tournament-final-2024',
          players: [
            GamePlayer(
              id: 'champion-player',
              name: 'Alice Champion',
              grid: const PlayerGrid(
                cards: [
                  [
                    Card(value: 5, isRevealed: true),
                    Card(value: 5, isRevealed: true),
                    Card(value: 5, isRevealed: false),
                    Card(value: -2, isRevealed: true),
                  ],
                  [
                    Card(value: 10, isRevealed: false),
                    Card(value: 3, isRevealed: false),
                    Card(value: 7, isRevealed: false),
                    Card(value: 0, isRevealed: true),
                  ],
                  [
                    Card(value: 1, isRevealed: false),
                    Card(value: 9, isRevealed: false),
                    Card(value: 2, isRevealed: false),
                    Card(value: 4, isRevealed: false),
                  ],
                ],
              ),
              actionCards: [
                const ActionCard(
                  id: 'strategic-teleport',
                  type: ActionCardType.teleport,
                  name: 'Téléportation Précise',
                  description: 'Optimisez votre grille',
                  timing: ActionTiming.optional,
                  target: ActionTarget.self,
                ),
                const ActionCard(
                  id: 'defensive-peek',
                  type: ActionCardType.peek,
                  name: 'Vision Défensive',
                  description: 'Anticipez les menaces',
                  timing: ActionTiming.optional,
                  target: ActionTarget.allPlayers,
                ),
              ],
              isHost: true,
              // score calculated automatically via currentScore getter
            ),
            GamePlayer(
              id: 'challenger-player',
              name: 'Bob Challenger',
              grid: const PlayerGrid(
                cards: [
                  [
                    Card(value: 8, isRevealed: true),
                    Card(value: 6, isRevealed: false),
                    Card(value: 1, isRevealed: false),
                    Card(value: 11, isRevealed: false),
                  ],
                  [
                    Card(value: -1, isRevealed: false),
                    Card(value: 4, isRevealed: true),
                    Card(value: 4, isRevealed: false),
                    Card(value: 4, isRevealed: false),
                  ],
                  [
                    Card(value: 2, isRevealed: false),
                    Card(value: 3, isRevealed: false),
                    Card(value: 7, isRevealed: false),
                    Card(value: 9, isRevealed: false),
                  ],
                ],
              ),
              actionCards: [
                const ActionCard(
                  id: 'offensive-swap',
                  type: ActionCardType.swap,
                  name: 'Échange Agressif',
                  description: 'Perturbez l\'adversaire',
                  timing: ActionTiming.optional,
                  target: ActionTarget.singleOpponent,
                ),
              ],
              isHost: false,
              // score calculated automatically
            ),
            GamePlayer(
              id: 'tactical-player',
              name: 'Charlie Tactical',
              grid: PlayerGrid(
                cards: List.generate(
                  3,
                  (r) => List.generate(
                    4,
                    (c) => Card(value: r * 4 + c, isRevealed: false),
                  ),
                ),
              ),
              actionCards: List.filled(
                3,
                const ActionCard(
                  // Maximum capacity
                  id: 'stored-action',
                  type: ActionCardType.draw,
                  name: 'Pioche Stockée',
                  description: 'Action en réserve',
                ),
              ),
              isHost: false,
              // score calculated automatically
            ),
          ],
          currentPlayerIndex: 1, // Challenger's turn
          deck: List.generate(
            30,
            (i) => Card(value: (i % 13) - 2),
          ), // Partial deck
          discardPile: [
            const Card(value: 6, isRevealed: true),
            const Card(value: 10, isRevealed: true),
            const Card(value: -2, isRevealed: true),
          ],
          actionDeck: [
            const ActionCard(
              id: 'deck-1',
              type: ActionCardType.turnAround,
              name: 'Demi-tour',
              description: 'Change le sens du jeu',
            ),
            const ActionCard(
              id: 'deck-2',
              type: ActionCardType.scout,
              name: 'Espionnage',
              description: 'Observe les cartes adverses',
            ),
          ],
          actionDiscard: [
            const ActionCard(
              id: 'used-1',
              type: ActionCardType.shield,
              name: 'Bouclier Usé',
              description: 'Protection utilisée',
            ),
          ],
          status: GameStatus.playing,
          turnDirection: TurnDirection.counterClockwise, // Recently reversed
          lastRound: false,
          initiatorPlayerId: null,
          endRoundInitiator: null,
          drawnCard: const Card(value: 7, isRevealed: false), // Card in hand
          createdAt: DateTime(2024, 1, 15, 19, 0),
          startedAt: DateTime(2024, 1, 15, 19, 5),
          finishedAt: null,
        );

        // When: Converting to model for persistence
        final persistenceModel = GameStateModel.fromDomainComplete(
          complexGameState,
          id: 'tournament-game-456',
          turnNumber: 47, // Deep into the game
          roundNumber: 2,
          updatedAt: DateTime(2024, 1, 15, 19, 35),
        );

        // Then: Model captures all game complexity
        expect(persistenceModel.id, equals('tournament-game-456'));
        expect(persistenceModel.roomId, equals('tournament-final-2024'));
        expect(persistenceModel.status, equals('playing'));
        expect(persistenceModel.currentPlayerId, equals('challenger-player'));
        expect(persistenceModel.turnNumber, equals(47));
        expect(persistenceModel.roundNumber, equals(2));

        // Verify gameData contains complete state
        final gameData = persistenceModel.gameData;
        expect(gameData['players'], hasLength(3));
        expect(gameData['deck'], hasLength(30));
        expect(gameData['discardPile'], hasLength(3));
        expect(gameData['actionDeck'], hasLength(2));
        expect(gameData['actionDiscard'], hasLength(1));
        expect(gameData['turnDirection'], equals('counterClockwise'));
        expect(gameData['drawnCard'], isNotNull);

        // When: Reconstructing from persistence
        final reconstructedState = persistenceModel.toDomainComplete();

        // Then: Perfect fidelity in complex state reconstruction
        expect(reconstructedState.roomId, equals(complexGameState.roomId));
        expect(reconstructedState.status, equals(complexGameState.status));
        expect(reconstructedState.currentPlayerIndex, equals(1));
        expect(
          reconstructedState.turnDirection,
          equals(TurnDirection.counterClockwise),
        );
        expect(reconstructedState.lastRound, isFalse);

        // Verify player states preserved
        expect(reconstructedState.players, hasLength(3));
        final alice = reconstructedState.players[0];
        expect(alice.id, equals('champion-player'));
        expect(alice.name, equals('Alice Champion'));
        expect(alice.actionCards, hasLength(2));
        expect(alice.isHost, isTrue);

        // Verify grid reconstruction (spot check)
        expect(alice.grid.cards[0][0]?.value, equals(5));
        expect(alice.grid.cards[0][0]?.isRevealed, isTrue);
        expect(alice.grid.cards[0][2]?.value, equals(5));
        expect(alice.grid.cards[0][2]?.isRevealed, isFalse);

        // Verify challenger player
        final bob = reconstructedState.players[1];
        expect(bob.actionCards, hasLength(1));
        expect(bob.actionCards[0].type, equals(ActionCardType.swap));
        expect(bob.actionCards[0].target, equals(ActionTarget.singleOpponent));

        // Verify tactical player at capacity
        final charlie = reconstructedState.players[2];
        expect(
          charlie.actionCards,
          hasLength(3),
          reason: 'Should be at max capacity',
        );

        // Verify deck states
        expect(reconstructedState.deck, hasLength(30));
        expect(reconstructedState.discardPile, hasLength(3));
        expect(reconstructedState.actionDeck, hasLength(2));
        expect(reconstructedState.actionDiscard, hasLength(1));

        // Verify drawn card preservation
        expect(reconstructedState.drawnCard?.value, equals(7));
        expect(reconstructedState.drawnCard?.isRevealed, isFalse);

        // Verify timestamps
        expect(
          reconstructedState.createdAt,
          equals(complexGameState.createdAt),
        );
        expect(
          reconstructedState.startedAt,
          equals(complexGameState.startedAt),
        );
        expect(reconstructedState.finishedAt, isNull);
      },
    );

    test(
      'should gracefully handle edge cases and incomplete states for robust error recovery',
      () {
        // Test behavior: System must handle various edge cases including disconnections,
        // incomplete initializations, and error states without data corruption

        final edgeCaseScenarios = [
          // Scenario 1: Pre-game lobby state
          (
            name: 'Lobby State',
            gameState: GameState(
              roomId: 'lobby-waiting-room',
              players: [
                GamePlayer(
                  id: 'host-waiting',
                  name: 'Host Player',
                  grid: PlayerGrid.empty(),
                  isHost: true,
                ),
                GamePlayer(
                  id: 'guest-1',
                  name: 'Guest One',
                  grid: PlayerGrid.empty(),
                ),
                GamePlayer(
                  id: 'guest-2',
                  name: 'Guest Two',
                  grid: PlayerGrid.empty(),
                ),
              ],
              currentPlayerIndex: 0,
              deck: [], // Not yet created
              discardPile: [],
              actionDeck: [],
              actionDiscard: [],
              status: GameStatus.waitingToStart,
              turnDirection: TurnDirection.clockwise,
              lastRound: false,
            ),
            expectations: {
              'empty_decks': true,
              'no_timestamps': true,
              'waiting_status': true,
            },
          ),
          // Scenario 2: Aborted game with partial state
          (
            name: 'Aborted Game',
            gameState: GameState(
              roomId: 'aborted-game-123',
              players: [
                GamePlayer(
                  id: 'rage-quitter',
                  name: 'Disconnected Player',
                  grid: const PlayerGrid(
                    cards: [
                      [Card(value: 5, isRevealed: true), null, null, null],
                      [null, null, null, null],
                      [null, null, null, null],
                    ],
                  ),
                  actionCards: [],
                ),
              ],
              currentPlayerIndex: 0,
              deck: List.generate(5, (i) => Card(value: i)), // Partial deck
              discardPile: [const Card(value: 10, isRevealed: true)],
              actionDeck: [],
              actionDiscard: [],
              status: GameStatus.cancelled,
              turnDirection: TurnDirection.clockwise,
              lastRound: false,
              drawnCard: const Card(value: 7), // Card left in hand
              startedAt: DateTime(2024, 1, 10, 15, 0),
              finishedAt: DateTime(2024, 1, 10, 15, 5), // Quick abort
            ),
            expectations: {
              'partial_grid': true,
              'cancelled_status': true,
              'has_timestamps': true,
            },
          ),
          // Scenario 3: Completed game with winner
          (
            name: 'Completed Game',
            gameState: GameState(
              roomId: 'finished-game-999',
              players: [
                GamePlayer(
                  id: 'winner-player',
                  name: 'Victory Player',
                  grid: PlayerGrid(
                    cards: List.generate(
                      3,
                      (r) => List.generate(
                        4,
                        (c) => const Card(value: 0, isRevealed: true),
                      ), // Perfect score
                    ),
                  ),
                  actionCards: [],
                  // score calculated automatically
                ),
                GamePlayer(
                  id: 'loser-player',
                  name: 'Second Place',
                  grid: PlayerGrid(
                    cards: List.generate(
                      3,
                      (r) => List.generate(
                        4,
                        (c) => const Card(value: 5, isRevealed: true),
                      ),
                    ),
                  ),
                  actionCards: [],
                  // score calculated automatically
                ),
              ],
              currentPlayerIndex: 0,
              deck: [], // Exhausted
              discardPile: List.generate(
                50,
                (i) => Card(value: i % 13 - 2, isRevealed: true),
              ),
              actionDeck: [],
              actionDiscard: List.generate(
                10,
                (i) => ActionCard(
                  id: 'used-$i',
                  type: ActionCardType.values[i % ActionCardType.values.length],
                  name: 'Used Action $i',
                  description: 'Action card used $i',
                ),
              ),
              status: GameStatus.finished,
              turnDirection: TurnDirection.clockwise,
              lastRound: true,
              initiatorPlayerId: 'winner-player',
              endRoundInitiator: 'winner-player',
              startedAt: DateTime(2024, 1, 10, 14, 0),
              finishedAt: DateTime(2024, 1, 10, 14, 45),
            ),
            expectations: {
              'finished_status': true,
              'has_winner': true,
              'exhausted_deck': true,
            },
          ),
        ];

        // When/Then: Each edge case maintains data integrity
        for (final scenario in edgeCaseScenarios) {
          final model = GameStateModel.fromDomainComplete(
            scenario.gameState,
            id: '${scenario.name.toLowerCase().replaceAll(' ', '-')}-id',
            turnNumber: scenario.gameState.status == GameStatus.waitingToStart
                ? 0
                : 10,
            roundNumber: scenario.gameState.status == GameStatus.waitingToStart
                ? 0
                : 1,
            updatedAt: DateTime.now(),
          );

          final reconstructed = model.toDomainComplete();

          // Verify core state preservation
          expect(
            reconstructed.roomId,
            equals(scenario.gameState.roomId),
            reason: '${scenario.name}: Room ID must be preserved',
          );
          expect(
            reconstructed.status,
            equals(scenario.gameState.status),
            reason: '${scenario.name}: Status must be preserved',
          );
          expect(
            reconstructed.players.length,
            equals(scenario.gameState.players.length),
            reason: '${scenario.name}: Player count must be preserved',
          );

          // Verify scenario-specific expectations
          if (scenario.expectations['empty_decks'] == true) {
            expect(
              reconstructed.deck,
              isEmpty,
              reason: '${scenario.name}: Pre-game should have empty deck',
            );
            expect(
              reconstructed.actionDeck,
              isEmpty,
              reason:
                  '${scenario.name}: Pre-game should have empty action deck',
            );
          }

          if (scenario.expectations['no_timestamps'] == true) {
            expect(
              reconstructed.startedAt,
              isNull,
              reason:
                  '${scenario.name}: Waiting game should not have start time',
            );
            expect(
              reconstructed.finishedAt,
              isNull,
              reason: '${scenario.name}: Waiting game should not have end time',
            );
          }

          if (scenario.expectations['cancelled_status'] == true) {
            expect(
              reconstructed.status,
              equals(GameStatus.cancelled),
              reason: '${scenario.name}: Cancelled status must be preserved',
            );
            expect(
              reconstructed.finishedAt,
              isNotNull,
              reason: '${scenario.name}: Cancelled game should have end time',
            );
          }

          if (scenario.expectations['finished_status'] == true) {
            expect(
              reconstructed.status,
              equals(GameStatus.finished),
              reason: '${scenario.name}: Finished status must be preserved',
            );
            expect(
              reconstructed.lastRound,
              isTrue,
              reason:
                  '${scenario.name}: Finished game should have lastRound true',
            );
            expect(
              reconstructed.initiatorPlayerId,
              isNotNull,
              reason: '${scenario.name}: Finished game should have initiator',
            );
          }

          // Always verify optional field handling
          if (scenario.gameState.drawnCard != null) {
            expect(
              reconstructed.drawnCard?.value,
              equals(scenario.gameState.drawnCard?.value),
              reason:
                  '${scenario.name}: Drawn card must be preserved when present',
            );
          } else {
            expect(
              reconstructed.drawnCard,
              isNull,
              reason: '${scenario.name}: Null drawn card must remain null',
            );
          }
        }
      },
    );

    test(
      'should format data correctly for Supabase real-time synchronization and webhooks',
      () {
        // Test behavior: Supabase JSON format must conform to database schema constraints
        // and support real-time subscriptions, webhooks, and row-level security policies

        // Given: Various game states that test Supabase integration requirements
        final supabaseScenarios = [
          // Active game for real-time sync
          (
            name: 'Real-time Active Game',
            state: GameState(
              roomId: 'realtime-room-001',
              players: [
                GamePlayer(
                  id: 'sub-player-1',
                  name: 'Subscriber One',
                  grid: PlayerGrid.empty(),
                ),
                GamePlayer(
                  id: 'sub-player-2',
                  name: 'Subscriber Two',
                  grid: PlayerGrid.empty(),
                ),
              ],
              currentPlayerIndex: 0,
              deck: List.generate(52, (i) => Card(value: i % 13 - 2)),
              discardPile: [],
              actionDeck: [],
              actionDiscard: [],
              status: GameStatus.playing,
              turnDirection: TurnDirection.clockwise,
              lastRound: false,
              createdAt: DateTime(2024, 1, 20, 10, 0),
              startedAt: DateTime(2024, 1, 20, 10, 5),
            ),
            model: {
              'id': 'realtime-game-001',
              'turnNumber': 15,
              'roundNumber': 1,
              'updatedAt': DateTime(2024, 1, 20, 10, 20),
            },
            expectations: {
              'has_room_id': true,
              'has_current_player': true,
              'has_timestamps': true,
              'webhook_ready': true,
            },
          ),
          // Finished game for leaderboard webhook
          (
            name: 'Leaderboard Update',
            state: GameState(
              roomId: 'tournament-room-999',
              players: [
                GamePlayer(
                  id: 'champion',
                  name: 'Tournament Champion',
                  grid: PlayerGrid.empty(),
                ),
                GamePlayer(
                  id: 'runner-up',
                  name: 'Second Place',
                  grid: PlayerGrid.empty(),
                ),
                GamePlayer(
                  id: 'third',
                  name: 'Third Place',
                  grid: PlayerGrid.empty(),
                ),
              ],
              currentPlayerIndex: 0,
              deck: [],
              discardPile: [],
              actionDeck: [],
              actionDiscard: [],
              status: GameStatus.finished,
              turnDirection: TurnDirection.clockwise,
              lastRound: true,
              initiatorPlayerId: 'champion',
              endRoundInitiator: 'champion',
              createdAt: DateTime(2024, 1, 20, 9, 0),
              startedAt: DateTime(2024, 1, 20, 9, 5),
              finishedAt: DateTime(2024, 1, 20, 9, 45),
            ),
            model: {
              'id': 'tournament-game-999',
              'turnNumber': 89,
              'roundNumber': 3,
              'updatedAt': DateTime(2024, 1, 20, 9, 45),
              'winnerId': 'champion',
            },
            expectations: {
              'has_winner': true,
              'has_ended_at': true,
              'leaderboard_ready': true,
            },
          ),
        ];

        for (final scenario in supabaseScenarios) {
          // When: Creating Supabase JSON from complex state
          final model = GameStateModel.fromDomainComplete(
            scenario.state,
            id: scenario.model['id'] as String,
            turnNumber: scenario.model['turnNumber'] as int,
            roundNumber: scenario.model['roundNumber'] as int,
            updatedAt: scenario.model['updatedAt'] as DateTime,
          );

          final supabaseJson = model.toSupabaseJson();

          // Then: JSON conforms to Supabase requirements

          // Required fields for all states
          expect(
            supabaseJson.containsKey('id'),
            isTrue,
            reason: '${scenario.name}: Must have primary key',
          );
          expect(
            supabaseJson.containsKey('room_id'),
            isTrue,
            reason: '${scenario.name}: Must have room reference for RLS',
          );
          expect(
            supabaseJson.containsKey('status'),
            isTrue,
            reason: '${scenario.name}: Must have status for filtering',
          );
          expect(
            supabaseJson.containsKey('game_data'),
            isTrue,
            reason: '${scenario.name}: Must have JSONB game data',
          );
          expect(
            supabaseJson.containsKey('created_at'),
            isTrue,
            reason: '${scenario.name}: Must have creation timestamp',
          );
          expect(
            supabaseJson.containsKey('updated_at'),
            isTrue,
            reason: '${scenario.name}: Must have update timestamp',
          );

          // Verify data types for Supabase schema
          expect(
            supabaseJson['id'],
            isA<String>(),
            reason: '${scenario.name}: ID must be string',
          );
          expect(
            supabaseJson['room_id'],
            isA<String>(),
            reason: '${scenario.name}: Room ID must be string',
          );
          expect(
            supabaseJson['status'],
            isA<String>(),
            reason: '${scenario.name}: Status must be string enum',
          );
          expect(
            supabaseJson['turn_number'],
            isA<int>(),
            reason: '${scenario.name}: Turn number must be integer',
          );
          expect(
            supabaseJson['round_number'],
            isA<int>(),
            reason: '${scenario.name}: Round number must be integer',
          );
          expect(
            supabaseJson['game_data'],
            isA<Map<String, dynamic>>(),
            reason: '${scenario.name}: Game data must be JSONB-compatible map',
          );

          // Verify timestamp format for Supabase
          expect(
            supabaseJson['created_at'],
            matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}'),
            reason: '${scenario.name}: Created at must be ISO8601 format',
          );
          expect(
            supabaseJson['updated_at'],
            matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}'),
            reason: '${scenario.name}: Updated at must be ISO8601 format',
          );

          // Scenario-specific validations
          if (scenario.expectations['has_current_player'] == true) {
            expect(
              supabaseJson['current_player_id'],
              isA<String>(),
              reason: '${scenario.name}: Active game must have current player',
            );
            expect(
              supabaseJson['current_player_id'],
              isIn(scenario.state.players.map((p) => p.id)),
              reason:
                  '${scenario.name}: Current player must be valid player ID',
            );
          }

          if (scenario.expectations['has_winner'] == true) {
            expect(
              supabaseJson['winner_id'],
              isA<String>(),
              reason: '${scenario.name}: Finished game must have winner',
            );
            expect(
              supabaseJson['winner_id'],
              equals('champion'),
              reason: '${scenario.name}: Winner must be the champion',
            );
          }

          if (scenario.expectations['has_ended_at'] == true) {
            expect(
              supabaseJson['ended_at'],
              isA<String>(),
              reason: '${scenario.name}: Finished game must have end timestamp',
            );
            expect(
              supabaseJson['ended_at'],
              matches(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}'),
              reason: '${scenario.name}: Ended at must be ISO8601 format',
            );
          }

          // Verify game_data structure for real-time subscriptions
          final gameData = supabaseJson['game_data'] as Map<String, dynamic>;
          expect(
            gameData.containsKey('players'),
            isTrue,
            reason:
                '${scenario.name}: Game data must include players for subscriptions',
          );
          expect(
            gameData.containsKey('currentPlayerIndex'),
            isTrue,
            reason:
                '${scenario.name}: Game data must include current player index',
          );
          expect(
            gameData.containsKey('turnDirection'),
            isTrue,
            reason: '${scenario.name}: Game data must include turn direction',
          );

          // Verify no null values in required fields (Supabase constraint)
          final requiredFields = [
            'id',
            'room_id',
            'status',
            'turn_number',
            'round_number',
            'game_data',
            'created_at',
            'updated_at',
          ];
          for (final field in requiredFields) {
            expect(
              supabaseJson[field],
              isNotNull,
              reason: '${scenario.name}: Required field $field cannot be null',
            );
          }
        }
      },
    );
  });
}
