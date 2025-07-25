import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/process_last_round.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  late ProcessLastRound processLastRound;

  setUp(() {
    processLastRound = ProcessLastRound();
  });

  group('ProcessLastRound UseCase', () {
    test(
      'should enable strategic endgame information asymmetry for competitive advantage',
      () async {
        // Test behavior: Last round creates strategic information asymmetry where the initiator
        // maintains hidden information while forcing opponents to reveal their positions

        // Setup competitive endgame scenario
        final strategicScenarios = [
          // Scenario 1: Initiator maintains secrecy while opponents reveal
          {
            'description': 'initiator advantage through hidden cards',
            'initiatorId': 'strategic-master-123',
            'players': [
              GamePlayer(
                id: 'strategic-master-123',
                name: 'Strategic Master',
                grid: PlayerGrid.empty()
                    .placeCard(
                      const Card(value: -2, isRevealed: true),
                      0,
                      0,
                    ) // Known low card
                    .placeCard(
                      const Card(value: 12, isRevealed: false),
                      0,
                      1,
                    ) // Hidden high card
                    .placeCard(
                      const Card(value: 0, isRevealed: false),
                      1,
                      0,
                    ) // Hidden neutral
                    .placeCard(
                      const Card(value: -1, isRevealed: false),
                      2,
                      2,
                    ), // Hidden bonus
                isHost: true,
              ),
              GamePlayer(
                id: 'challenger-456',
                name: 'Challenger',
                grid: PlayerGrid.empty()
                    .placeCard(
                      const Card(value: 3, isRevealed: false),
                      0,
                      0,
                    ) // Will be revealed
                    .placeCard(
                      const Card(value: 7, isRevealed: false),
                      0,
                      1,
                    ) // Will be revealed
                    .placeCard(
                      const Card(value: -2, isRevealed: true),
                      1,
                      0,
                    ) // Already visible
                    .placeCard(
                      const Card(value: 5, isRevealed: false),
                      2,
                      3,
                    ), // Will be revealed
              ),
              GamePlayer(
                id: 'competitor-789',
                name: 'Competitor',
                grid: PlayerGrid.empty()
                    .placeCard(
                      const Card(value: 10, isRevealed: false),
                      0,
                      0,
                    ) // Will be revealed
                    .placeCard(
                      const Card(value: 2, isRevealed: false),
                      1,
                      1,
                    ) // Will be revealed
                    .placeCard(
                      const Card(value: 8, isRevealed: false),
                      2,
                      2,
                    ) // Will be revealed
                    .placeCard(
                      const Card(value: 1, isRevealed: false),
                      2,
                      3,
                    ), // Will be revealed
              ),
            ],
            'expectedBehavior': (GameState result) {
              // Initiator maintains strategic advantage
              final initiator = result.players.firstWhere(
                (p) => p.id == 'strategic-master-123',
              );
              expect(
                initiator.grid.cards[0][0]?.isRevealed,
                true,
                reason: 'Previously revealed stays visible',
              );
              expect(
                initiator.grid.cards[0][1]?.isRevealed,
                false,
                reason: 'Hidden high card stays secret',
              );
              expect(
                initiator.grid.cards[1][0]?.isRevealed,
                false,
                reason: 'Hidden neutral stays secret',
              );
              expect(
                initiator.grid.cards[2][2]?.isRevealed,
                false,
                reason: 'Hidden bonus stays secret',
              );

              // Challenger forced to reveal all
              final challenger = result.players.firstWhere(
                (p) => p.id == 'challenger-456',
              );
              expect(
                challenger.grid.cards[0][0]?.isRevealed,
                true,
                reason: 'Hidden cards now visible',
              );
              expect(
                challenger.grid.cards[0][1]?.isRevealed,
                true,
                reason: 'All cards exposed',
              );
              expect(
                challenger.grid.cards[1][0]?.isRevealed,
                true,
                reason: 'Already visible stays visible',
              );
              expect(
                challenger.grid.cards[2][3]?.isRevealed,
                true,
                reason: 'Strategic position revealed',
              );

              // Competitor fully exposed
              final competitor = result.players.firstWhere(
                (p) => p.id == 'competitor-789',
              );
              for (int row = 0; row < 3; row++) {
                for (int col = 0; col < 4; col++) {
                  final card = competitor.grid.cards[row][col];
                  if (card != null) {
                    expect(
                      card.isRevealed,
                      true,
                      reason: 'All competitor cards must be visible',
                    );
                  }
                }
              }
            },
          },

          // Scenario 2: Large tournament with strategic information control
          {
            'description': 'tournament finals information warfare',
            'initiatorId': 'tournament-leader-001',
            'players': List.generate(
              8,
              (i) => GamePlayer(
                id: i == 3 ? 'tournament-leader-001' : 'tournament-player-$i',
                name: i == 3 ? 'Tournament Leader' : 'Player ${i + 1}',
                grid: PlayerGrid.empty()
                    .placeCard(Card(value: i - 2, isRevealed: i % 3 == 0), 0, 0)
                    .placeCard(
                      Card(value: (i * 2) % 13 - 2, isRevealed: false),
                      0,
                      1,
                    )
                    .placeCard(Card(value: 12 - i, isRevealed: false), 1, 0)
                    .placeCard(Card(value: i % 5, isRevealed: i == 3), 1, 1),
                isHost: i == 0,
              ),
            ),
            'expectedBehavior': (GameState result) {
              // Tournament leader maintains strategic secrecy
              final leader = result.players.firstWhere(
                (p) => p.id == 'tournament-leader-001',
              );
              int hiddenCount = 0;
              int revealedCount = 0;

              for (final row in leader.grid.cards) {
                for (final card in row) {
                  if (card != null) {
                    if (card.isRevealed) {
                      revealedCount++;
                    } else {
                      hiddenCount++;
                    }
                  }
                }
              }

              expect(
                hiddenCount > 0,
                true,
                reason: 'Leader must maintain some hidden information',
              );

              // All other players fully exposed
              for (final player in result.players) {
                if (player.id != 'tournament-leader-001') {
                  for (final row in player.grid.cards) {
                    for (final card in row) {
                      if (card != null) {
                        expect(
                          card.isRevealed,
                          true,
                          reason:
                              'Player ${player.name} must have all cards visible in endgame',
                        );
                      }
                    }
                  }
                }
              }
            },
          },

          // Scenario 3: Fallback behavior when initiator disconnected
          {
            'description': 'fair play when initiator cannot be determined',
            'initiatorId': 'disconnected-player-999', // Non-existent
            'players': [
              GamePlayer(
                id: 'active-player-1',
                name: 'Active Player 1',
                grid: PlayerGrid.empty()
                    .placeCard(const Card(value: 5, isRevealed: false), 0, 0)
                    .placeCard(const Card(value: 10, isRevealed: false), 0, 1),
                isHost: true,
              ),
              GamePlayer(
                id: 'active-player-2',
                name: 'Active Player 2',
                grid: PlayerGrid.empty()
                    .placeCard(const Card(value: 3, isRevealed: false), 0, 0)
                    .placeCard(const Card(value: 7, isRevealed: false), 0, 1),
              ),
            ],
            'expectedBehavior': (GameState result) {
              // When initiator cannot be found, all players' cards are revealed for fairness
              for (final player in result.players) {
                for (final row in player.grid.cards) {
                  for (final card in row) {
                    if (card != null) {
                      expect(
                        card.isRevealed,
                        true,
                        reason:
                            'Without clear initiator, all cards visible for fair endgame',
                      );
                    }
                  }
                }
              }
            },
          },
        ];

        // Execute all strategic scenarios
        for (final scenario in strategicScenarios) {
          final gameState =
              GameState.initial(
                roomId:
                    'competitive-room-${DateTime.now().millisecondsSinceEpoch}',
                players: scenario['players'] as List<GamePlayer>,
              ).copyWith(
                status: GameStatus.lastRound,
                endRoundInitiator: scenario['initiatorId'] as String,
              );

          final result = await processLastRound(
            ProcessLastRoundParams(gameState: gameState),
          );

          expect(
            result.isRight(),
            true,
            reason:
                'Scenario "${scenario['description']}" should process successfully',
          );

          result.fold(
            (failure) => fail(
              'Should not fail for scenario "${scenario['description']}"',
            ),
            (newState) {
              // Verify game continues in last round
              expect(
                newState.status,
                GameStatus.lastRound,
                reason: 'Game must continue in last round for final plays',
              );

              // Execute scenario-specific behavior verification
              (scenario['expectedBehavior'] as Function)(newState);
            },
          );
        }

        // Additional test: Non-last-round preservation
        final regularGameState = GameState.initial(
          roomId: 'regular-game',
          players: [
            GamePlayer(
              id: 'player1',
              name: 'Regular Player',
              grid: PlayerGrid.empty()
                  .placeCard(const Card(value: 5, isRevealed: false), 0, 0)
                  .placeCard(const Card(value: 8, isRevealed: false), 1, 1),
              isHost: true,
            ),
          ],
        ).copyWith(status: GameStatus.playing); // Not in last round

        final regularResult = await processLastRound(
          ProcessLastRoundParams(gameState: regularGameState),
        );

        expect(regularResult.isRight(), true);
        regularResult.fold(
          (failure) => fail('Should handle non-last-round gracefully'),
          (newState) {
            // Cards should remain unchanged when not in last round
            expect(newState.players[0].grid.cards[0][0]?.isRevealed, false);
            expect(newState.players[0].grid.cards[1][1]?.isRevealed, false);
            expect(newState.status, GameStatus.playing);
          },
        );
      },
    );
  });
}
