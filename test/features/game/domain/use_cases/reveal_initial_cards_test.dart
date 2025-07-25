import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/reveal_initial_cards.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  late RevealInitialCards revealInitialCards;

  setUp(() {
    revealInitialCards = RevealInitialCards();
  });

  group('RevealInitialCards UseCase', () {
    test(
      'should enable strategic card reveal system for competitive gameplay initialization',
      () async {
        // Test behavior: Initial card reveal system creates strategic starting positions
        // where each player selects exactly 2 cards to reveal, creating information asymmetry

        final strategicScenarios = [
          // Scenario 1: Valid strategic reveal choices
          {
            'description': 'strategic corner reveal for maximum information',
            'playerId': 'strategic-player-123',
            'positions': [(0, 0), (2, 3)], // Top-left and bottom-right corners
            'setupGrid': () => PlayerGrid.fromCards(
              List.generate(
                kCardsPerPlayer,
                (i) => Card(value: i % 13 - 2, isRevealed: false),
              ),
            ),
            'expectedSuccess': true,
            'expectedBehavior': (GamePlayer player) {
              // Verify strategic positions are revealed
              expect(
                player.grid.getCard(0, 0)?.isRevealed,
                true,
                reason: 'Top-left corner should be visible for edge strategy',
              );
              expect(
                player.grid.getCard(2, 3)?.isRevealed,
                true,
                reason:
                    'Bottom-right corner should be visible for diagonal coverage',
              );

              // Verify exactly 2 cards revealed (no more, no less)
              int revealedCount = 0;
              for (int row = 0; row < kGridRows; row++) {
                for (int col = 0; col < kGridColumns; col++) {
                  if (player.grid.getCard(row, col)?.isRevealed == true) {
                    revealedCount++;
                  }
                }
              }
              expect(
                revealedCount,
                kInitialRevealedCards,
                reason:
                    'Must reveal exactly $kInitialRevealedCards cards for fair play',
              );
            },
          },

          // Scenario 2: Invalid reveal attempts - wrong number of positions
          {
            'description': 'insufficient reveal positions',
            'playerId': 'cheating-player-456',
            'positions': [(0, 0)], // Only 1 position instead of required 2
            'setupGrid': () => PlayerGrid.fromCards(
              List.generate(kCardsPerPlayer, (i) => Card(value: i)),
            ),
            'expectedSuccess': false,
            'expectedError': 'wrong number of positions',
          },

          // Scenario 3: Invalid reveal attempts - out of bounds
          {
            'description': 'out of bounds reveal attempt',
            'playerId': 'confused-player-789',
            'positions': [(0, 0), (5, 5)], // Invalid grid position
            'setupGrid': () => PlayerGrid.fromCards(
              List.generate(kCardsPerPlayer, (i) => Card(value: i)),
            ),
            'expectedSuccess': false,
            'expectedError': 'invalid position',
          },

          // Scenario 4: Invalid reveal attempts - already revealed card
          {
            'description': 'duplicate reveal attempt',
            'playerId': 'duplicate-player-012',
            'positions': [(0, 0), (1, 1)], // (0,0) is already revealed
            'setupGrid': () => PlayerGrid.fromCards(
              List.generate(
                kCardsPerPlayer,
                (i) => Card(
                  value: i,
                  isRevealed:
                      i == 0, // First card (position 0,0) already revealed
                ),
              ),
            ),
            'expectedSuccess': false,
            'expectedError': 'already revealed',
          },
        ];

        // Execute individual player scenarios
        for (final scenario in strategicScenarios) {
          final grid = (scenario['setupGrid'] as Function)();
          final players = [
            GamePlayer(
              id: scenario['playerId'] as String,
              name: 'Test Player',
              grid: grid,
              isHost: true,
            ),
            GamePlayer(
              id: 'opponent-999',
              name: 'Opponent',
              grid: PlayerGrid.fromCards(
                List.generate(kCardsPerPlayer, (i) => Card(value: i)),
              ),
            ),
          ];

          final gameState = GameState.initial(
            roomId: 'strategic-room-${DateTime.now().millisecondsSinceEpoch}',
            players: players,
          );

          final result = await revealInitialCards(
            RevealInitialCardsParams(
              gameState: gameState,
              playerId: scenario['playerId'] as String,
              positions: scenario['positions'] as List<(int, int)>,
            ),
          );

          if (scenario['expectedSuccess'] as bool) {
            expect(
              result.isRight(),
              true,
              reason: 'Scenario "${scenario['description']}" should succeed',
            );

            result.fold(
              (failure) => fail(
                'Should not fail for scenario "${scenario['description']}"',
              ),
              (updatedState) {
                final player = updatedState.players.firstWhere(
                  (p) => p.id == scenario['playerId'],
                );

                if (scenario['expectedBehavior'] != null) {
                  (scenario['expectedBehavior'] as Function)(player);
                }
              },
            );
          } else {
            expect(
              result.isLeft(),
              true,
              reason: 'Scenario "${scenario['description']}" should fail',
            );
          }
        }

        // Scenario 5: Multi-player tournament initialization
        final tournamentPlayers = [
          'champion-001',
          'challenger-002',
          'contender-003',
          'rookie-004',
        ];
        final revealStrategies = [
          (
            playerId: 'champion-001',
            positions: [(0, 0), (2, 3)],
            strategy: 'corner coverage',
          ),
          (
            playerId: 'challenger-002',
            positions: [(0, 1), (2, 2)],
            strategy: 'vertical sampling',
          ),
          (
            playerId: 'contender-003',
            positions: [(1, 0), (1, 3)],
            strategy: 'middle row focus',
          ),
          (
            playerId: 'rookie-004',
            positions: [(0, 2), (2, 1)],
            strategy: 'diagonal pattern',
          ),
        ];

        final tournamentCards = List.generate(
          kCardsPerPlayer,
          (i) => Card(value: i % 13 - 2),
        );
        var tournamentState = GameState.initial(
          roomId: 'tournament-arena',
          players: tournamentPlayers
              .map(
                (id) => GamePlayer(
                  id: id,
                  name: 'Player $id',
                  grid: PlayerGrid.fromCards(List.from(tournamentCards)),
                ),
              )
              .toList(),
        );

        // Process each player's strategic reveal
        for (final strategy in revealStrategies) {
          final result = await revealInitialCards(
            RevealInitialCardsParams(
              gameState: tournamentState,
              playerId: strategy.playerId,
              positions: strategy.positions,
            ),
          );

          expect(
            result.isRight(),
            true,
            reason:
                'Player ${strategy.playerId} using "${strategy.strategy}" should succeed',
          );

          result.fold(
            (failure) => fail('Should not fail for ${strategy.playerId}'),
            (newState) {
              tournamentState = newState;
              final player = newState.players.firstWhere(
                (p) => p.id == strategy.playerId,
              );

              // Verify strategic positions are revealed
              for (final pos in strategy.positions) {
                expect(
                  player.grid.getCard(pos.$1, pos.$2)?.isRevealed,
                  true,
                  reason:
                      'Card at (${pos.$1},${pos.$2}) should be revealed for ${strategy.strategy}',
                );
              }

              // Verify no interference between players
              for (final otherPlayer in newState.players) {
                if (otherPlayer.id != strategy.playerId) {
                  int otherRevealCount = 0;
                  for (int row = 0; row < kGridRows; row++) {
                    for (int col = 0; col < kGridColumns; col++) {
                      if (otherPlayer.grid.getCard(row, col)?.isRevealed ==
                          true) {
                        otherRevealCount++;
                      }
                    }
                  }
                  // Other players should only have their own reveals
                  expect(
                    otherRevealCount <= kInitialRevealedCards,
                    true,
                    reason:
                        'Other players should not be affected by ${strategy.playerId} reveal',
                  );
                }
              }
            },
          );
        }

        // Scenario 6: Non-existent player validation
        final ghostResult = await revealInitialCards(
          RevealInitialCardsParams(
            gameState: tournamentState,
            playerId: 'ghost-player-999',
            positions: [(0, 0), (1, 1)],
          ),
        );

        expect(
          ghostResult.isLeft(),
          true,
          reason: 'Non-existent player should not be able to reveal cards',
        );
      },
    );
  });
}
