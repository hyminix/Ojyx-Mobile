import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/start_game.dart';
import 'package:ojyx/features/game/domain/use_cases/distribute_cards.dart';
import 'package:ojyx/features/game/domain/use_cases/reveal_initial_cards.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  late StartGame startGame;
  late DistributeCards distributeCards;
  late RevealInitialCards revealInitialCards;

  setUp(() {
    distributeCards = DistributeCards();
    revealInitialCards = RevealInitialCards();
    startGame = StartGame(
      distributeCards: distributeCards,
      revealInitialCards: revealInitialCards,
    );
  });

  group('StartGame UseCase', () {
    test(
      'should create fully playable competitive game environment with strategic card distribution',
      () async {
        // Test behavior: Game initialization creates a complete competitive environment where
        // players can immediately begin strategic gameplay with properly distributed cards

        final gameScenarios = [
          // Scenario 1: Standard 2-player competitive match
          {
            'description': 'head-to-head competitive match',
            'players': [
              GamePlayer(
                id: 'champion-123',
                name: 'Tournament Champion',
                grid: PlayerGrid.empty(),
                isHost: true,
              ),
              GamePlayer(
                id: 'challenger-456',
                name: 'Rising Challenger',
                grid: PlayerGrid.empty(),
              ),
            ],
            'initialPositions': {
              'champion-123': [(0, 0), (2, 3)], // Strategic corners
              'challenger-456': [(0, 1), (2, 2)], // Central positions
            },
            'expectedBehavior': (GameState result) {
              // Verify complete game readiness
              expect(
                result.startedAt,
                isNotNull,
                reason: 'Game must track start time for match duration',
              );

              // Verify turn order established
              expect(result.currentPlayerIndex, isNotNull);
              expect(
                result.currentPlayerIndex >= 0 &&
                    result.currentPlayerIndex < result.players.length,
                true,
                reason: 'Valid player must have first turn',
              );

              // Verify each player has complete setup
              for (final player in result.players) {
                int cardCount = 0;
                int revealedCount = 0;

                for (final row in player.grid.cards) {
                  for (final card in row) {
                    if (card != null) {
                      cardCount++;
                      if (card.isRevealed) {
                        revealedCount++;
                      }
                    }
                  }
                }

                expect(
                  cardCount,
                  kCardsPerPlayer,
                  reason:
                      'Player ${player.name} must have full deck distributed',
                );
                expect(
                  revealedCount,
                  kInitialRevealedCards,
                  reason:
                      'Player ${player.name} must have strategic initial visibility',
                );
              }

              // Verify shared game elements
              expect(
                result.discardPile.length,
                1,
                reason: 'Must have initial discard to start gameplay',
              );
              expect(
                result.discardPile.first.isRevealed,
                true,
                reason: 'Initial discard must be visible to all',
              );
              expect(
                result.deck.isNotEmpty,
                true,
                reason: 'Deck must have cards for drawing',
              );
            },
          },

          // Scenario 2: Large tournament with maximum players
          {
            'description': 'maximum player tournament',
            'players': List.generate(
              kMaxPlayers,
              (i) => GamePlayer(
                id: 'tournament-player-$i',
                name: 'Player ${i + 1}',
                grid: PlayerGrid.empty(),
                isHost: i == 0,
              ),
            ),
            'initialPositions': null, // Use default positions
            'expectedBehavior': (GameState result) {
              // Verify all players properly initialized
              expect(result.players.length, kMaxPlayers);

              // Verify fair card distribution across all players
              final totalCardsDistributed = result.players.fold<int>(0, (
                sum,
                player,
              ) {
                int playerCards = 0;
                for (final row in player.grid.cards) {
                  playerCards += row.where((card) => card != null).length;
                }
                return sum + playerCards;
              });

              expect(
                totalCardsDistributed,
                kMaxPlayers * kCardsPerPlayer,
                reason: 'All players must receive equal card distribution',
              );

              // Verify each player has initial reveals
              for (final player in result.players) {
                int reveals = 0;
                for (final row in player.grid.cards) {
                  reveals += row
                      .where((card) => card?.isRevealed == true)
                      .length;
                }
                expect(
                  reveals,
                  kInitialRevealedCards,
                  reason: 'Player ${player.name} must have standard reveals',
                );
              }
            },
          },

          // Scenario 3: Minimum viable game
          {
            'description': 'minimum player count',
            'players': [
              GamePlayer(
                id: 'player1',
                name: 'Player 1',
                grid: PlayerGrid.empty(),
                isHost: true,
              ),
              GamePlayer(
                id: 'player2',
                name: 'Player 2',
                grid: PlayerGrid.empty(),
              ),
            ],
            'initialPositions': null, // Test default position assignment
            'expectedBehavior': (GameState result) {
              // Verify defaults work correctly
              for (final player in result.players) {
                int revealedCards = 0;
                for (final row in player.grid.cards) {
                  for (final card in row) {
                    if (card?.isRevealed == true) {
                      revealedCards++;
                    }
                  }
                }
                expect(
                  revealedCards,
                  kInitialRevealedCards,
                  reason:
                      'Default positions must reveal correct number of cards',
                );
              }
            },
          },
        ];

        // Execute scenarios
        for (final scenario in gameScenarios) {
          final initialState = GameState.initial(
            roomId: 'competitive-room-${DateTime.now().millisecondsSinceEpoch}',
            players: scenario['players'] as List<GamePlayer>,
          );

          final result = await startGame(
            StartGameParams(
              gameState: initialState,
              playerInitialPositions:
                  scenario['initialPositions']
                      as Map<String, List<(int, int)>>?,
            ),
          );

          expect(
            result.isRight(),
            true,
            reason:
                'Scenario "${scenario['description']}" should start successfully',
          );

          result.fold(
            (failure) =>
                fail('Should not fail for "${scenario['description']}"'),
            (gameState) {
              // Verify game is playable
              expect(
                gameState.status,
                GameStatus.playing,
                reason:
                    'Game must be in playing state for "${scenario['description']}"',
              );

              // Execute scenario-specific verification
              (scenario['expectedBehavior'] as Function)(gameState);
            },
          );
        }

        // Validation scenarios that should fail
        final validationScenarios = [
          {
            'description': 'insufficient players',
            'setup': () => GameState.initial(
              roomId: 'invalid-room-1',
              players: [
                GamePlayer(
                  id: 'solo',
                  name: 'Solo Player',
                  grid: PlayerGrid.empty(),
                  isHost: true,
                ),
              ],
            ),
            'positions': {
              'solo': [(0, 0), (1, 1)],
            },
          },
          {
            'description': 'already started game',
            'setup': () => GameState.initial(
              roomId: 'invalid-room-2',
              players: [
                GamePlayer(
                  id: 'p1',
                  name: 'P1',
                  grid: PlayerGrid.empty(),
                  isHost: true,
                ),
                GamePlayer(id: 'p2', name: 'P2', grid: PlayerGrid.empty()),
              ],
            ).copyWith(status: GameStatus.playing),
            'positions': {
              'p1': [(0, 0), (1, 1)],
              'p2': [(0, 1), (1, 2)],
            },
          },
        ];

        for (final validation in validationScenarios) {
          final gameState = (validation['setup'] as Function)();
          final result = await startGame(
            StartGameParams(
              gameState: gameState,
              playerInitialPositions:
                  validation['positions'] as Map<String, List<(int, int)>>,
            ),
          );

          expect(
            result.isLeft(),
            true,
            reason: 'Should reject "${validation['description']}"',
          );
        }
      },
    );
  });
}
