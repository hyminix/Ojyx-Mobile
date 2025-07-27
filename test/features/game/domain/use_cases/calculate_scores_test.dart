import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/calculate_scores.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import '../../../../helpers/test_data_builders.dart';
import '../../../../helpers/custom_matchers.dart';

void main() {
  late CalculateScores calculateScores;

  setUp(() {
    calculateScores = CalculateScores();
  });

  group('CalculateScores Use Case', () {
    // Test constants for clarity
    const int NEGATIVE_BONUS_VALUE = -2;
    const int ZERO_VALUE = 0;
    const int LOW_PENALTY_VALUE = 3;
    const int MEDIUM_PENALTY_VALUE = 7;
    const int HIGH_PENALTY_VALUE = 10;
    const double PENALTY_MULTIPLIER = 2.0;

    group('Basic Score Calculation', () {
      test(
        'should_calculate_sum_of_revealed_cards_when_only_revealed_is_true',
        () async {
          // Arrange
          final playerGrid = PlayerGridBuilder().withCards([
            CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
            CardBuilder().withValue(MEDIUM_PENALTY_VALUE).revealed().build(),
            CardBuilder()
                .withValue(HIGH_PENALTY_VALUE)
                .hidden()
                .build(), // Should be ignored
          ]).build();

          final playerState = PlayerStateBuilder()
              .withPlayerId('player-1')
              .withGrid(playerGrid)
              .build();

          final gameState = GameStateBuilder()
              .withPlayers([GamePlayerBuilder().withId('player-1').build()])
              .withPlayerStates({'player-1': playerState})
              .build();

          // Act
          final result = await calculateScores(
            CalculateScoresParams(
              gameState: gameState,
              onlyRevealed: true,
              sorted: false,
            ),
          );

          // Assert
          expect(
            result.isRight(),
            true,
            reason: 'Score calculation should succeed for valid game state',
          );

          result.fold(
            (failure) => fail('Should not fail with valid parameters'),
            (scores) {
              expect(
                scores['player-1'],
                LOW_PENALTY_VALUE + MEDIUM_PENALTY_VALUE, // 3 + 7 = 10
                reason: 'Score should equal sum of revealed card values only',
              );
            },
          );
        },
      );

      test(
        'should_calculate_sum_of_all_cards_when_only_revealed_is_false',
        () async {
          // Arrange
          final playerGrid = PlayerGridBuilder().withCards([
            CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
            CardBuilder().withValue(MEDIUM_PENALTY_VALUE).revealed().build(),
            CardBuilder().withValue(HIGH_PENALTY_VALUE).hidden().build(),
          ]).build();

          final playerState = PlayerStateBuilder()
              .withPlayerId('player-1')
              .withGrid(playerGrid)
              .build();

          final gameState = GameStateBuilder()
              .withPlayers([GamePlayerBuilder().withId('player-1').build()])
              .withPlayerStates({'player-1': playerState})
              .build();

          // Act
          final result = await calculateScores(
            CalculateScoresParams(
              gameState: gameState,
              onlyRevealed: false,
              sorted: false,
            ),
          );

          // Assert
          expect(
            result.isRight(),
            true,
            reason: 'Score calculation should succeed for valid game state',
          );

          result.fold(
            (failure) => fail('Should not fail with valid parameters'),
            (scores) {
              expect(
                scores['player-1'],
                LOW_PENALTY_VALUE +
                    MEDIUM_PENALTY_VALUE +
                    HIGH_PENALTY_VALUE, // 3 + 7 + 10 = 20
                reason: 'Score should equal sum of all card values',
              );
            },
          );
        },
      );

      test(
        'should_handle_negative_scores_when_player_has_bonus_cards',
        () async {
          // Arrange
          final playerGrid = PlayerGridBuilder().withCards([
            CardBuilder().withValue(NEGATIVE_BONUS_VALUE).revealed().build(),
            CardBuilder().withValue(NEGATIVE_BONUS_VALUE).revealed().build(),
            CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
          ]).build();

          final playerState = PlayerStateBuilder()
              .withPlayerId('bonus-player')
              .withGrid(playerGrid)
              .build();

          final gameState = GameStateBuilder()
              .withPlayers([GamePlayerBuilder().withId('bonus-player').build()])
              .withPlayerStates({'bonus-player': playerState})
              .build();

          // Act
          final result = await calculateScores(
            CalculateScoresParams(gameState: gameState),
          );

          // Assert
          result.fold(
            (failure) => fail('Should not fail with negative scores'),
            (scores) {
              expect(
                scores['bonus-player'],
                NEGATIVE_BONUS_VALUE +
                    NEGATIVE_BONUS_VALUE +
                    LOW_PENALTY_VALUE, // -2 + -2 + 3 = -1
                reason: 'Negative scores should be correctly calculated',
              );
            },
          );
        },
      );
    });

    group('Score Multiplier Application', () {
      test('should_apply_multiplier_when_player_has_penalty', () async {
        // Arrange
        final playerGrid = PlayerGridBuilder().withCards([
          CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
          CardBuilder().withValue(MEDIUM_PENALTY_VALUE).revealed().build(),
        ]).build();

        final playerState = PlayerStateBuilder()
            .withPlayerId('penalized-player')
            .withGrid(playerGrid)
            .build();

        final gameState = GameStateBuilder()
            .withPlayers([
              GamePlayerBuilder().withId('penalized-player').build(),
            ])
            .withPlayerStates({'penalized-player': playerState})
            .build()
            .copyWith(
              playerStates: {
                'penalized-player': playerState.copyWith(
                  scoreMultiplier: PENALTY_MULTIPLIER,
                ),
              },
            );

        // Act
        final result = await calculateScores(
          CalculateScoresParams(gameState: gameState),
        );

        // Assert
        result.fold((failure) => fail('Should not fail with multiplier'), (
          scores,
        ) {
          final baseScore = LOW_PENALTY_VALUE + MEDIUM_PENALTY_VALUE; // 10
          final expectedScore = (baseScore * PENALTY_MULTIPLIER).toInt(); // 20

          expect(
            scores['penalized-player'],
            expectedScore,
            reason: 'Score should be multiplied by penalty factor',
          );
        });
      });

      test('should_not_apply_multiplier_when_multiplier_is_one', () async {
        // Arrange
        final playerGrid = PlayerGridBuilder().withCards([
          CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
          CardBuilder().withValue(MEDIUM_PENALTY_VALUE).revealed().build(),
        ]).build();

        final playerState = PlayerStateBuilder()
            .withPlayerId('normal-player')
            .withGrid(playerGrid)
            .build();

        final gameState = GameStateBuilder()
            .withPlayers([GamePlayerBuilder().withId('normal-player').build()])
            .withPlayerStates({'normal-player': playerState})
            .build();

        // Act
        final result = await calculateScores(
          CalculateScoresParams(gameState: gameState),
        );

        // Assert
        result.fold(
          (failure) => fail('Should not fail with normal multiplier'),
          (scores) {
            expect(
              scores['normal-player'],
              LOW_PENALTY_VALUE + MEDIUM_PENALTY_VALUE, // 10
              reason: 'Score should not be multiplied when multiplier is 1',
            );
          },
        );
      });
    });

    group('Sorted Rankings', () {
      test('should_return_sorted_scores_when_sorted_is_true', () async {
        // Arrange
        final player1State = PlayerStateBuilder()
            .withPlayerId('player-1')
            .withGrid(
              PlayerGridBuilder().withCards([
                CardBuilder().withValue(HIGH_PENALTY_VALUE).revealed().build(),
              ]).build(),
            )
            .build();

        final player2State = PlayerStateBuilder()
            .withPlayerId('player-2')
            .withGrid(
              PlayerGridBuilder().withCards([
                CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
              ]).build(),
            )
            .build();

        final player3State = PlayerStateBuilder()
            .withPlayerId('player-3')
            .withGrid(
              PlayerGridBuilder().withCards([
                CardBuilder()
                    .withValue(MEDIUM_PENALTY_VALUE)
                    .revealed()
                    .build(),
              ]).build(),
            )
            .build();

        final gameState = GameStateBuilder()
            .withPlayers([
              GamePlayerBuilder().withId('player-1').build(),
              GamePlayerBuilder().withId('player-2').build(),
              GamePlayerBuilder().withId('player-3').build(),
            ])
            .withPlayerStates({
              'player-1': player1State,
              'player-2': player2State,
              'player-3': player3State,
            })
            .build();

        // Act
        final result = await calculateScores(
          CalculateScoresParams(gameState: gameState, sorted: true),
        );

        // Assert
        result.fold((failure) => fail('Should not fail when sorting'), (
          scores,
        ) {
          final rankedPlayers = scores.entries.toList();

          expect(
            rankedPlayers[0].key,
            'player-2',
            reason: 'Player with lowest score should rank first',
          );
          expect(
            rankedPlayers[0].value,
            LOW_PENALTY_VALUE,
            reason: 'First place score should be lowest',
          );

          expect(
            rankedPlayers[1].key,
            'player-3',
            reason: 'Player with middle score should rank second',
          );
          expect(
            rankedPlayers[1].value,
            MEDIUM_PENALTY_VALUE,
            reason: 'Second place score should be middle value',
          );

          expect(
            rankedPlayers[2].key,
            'player-1',
            reason: 'Player with highest score should rank last',
          );
          expect(
            rankedPlayers[2].value,
            HIGH_PENALTY_VALUE,
            reason: 'Last place score should be highest',
          );
        });
      });

      test('should_maintain_insertion_order_when_sorted_is_false', () async {
        // Arrange
        final player1State = PlayerStateBuilder()
            .withPlayerId('player-1')
            .withGrid(
              PlayerGridBuilder().withCards([
                CardBuilder().withValue(HIGH_PENALTY_VALUE).revealed().build(),
              ]).build(),
            )
            .build();

        final player2State = PlayerStateBuilder()
            .withPlayerId('player-2')
            .withGrid(
              PlayerGridBuilder().withCards([
                CardBuilder().withValue(LOW_PENALTY_VALUE).revealed().build(),
              ]).build(),
            )
            .build();

        final gameState = GameStateBuilder()
            .withPlayers([
              GamePlayerBuilder().withId('player-1').build(),
              GamePlayerBuilder().withId('player-2').build(),
            ])
            .withPlayerStates({
              'player-1': player1State,
              'player-2': player2State,
            })
            .build();

        // Act
        final result = await calculateScores(
          CalculateScoresParams(gameState: gameState, sorted: false),
        );

        // Assert
        result.fold((failure) => fail('Should not fail when not sorting'), (
          scores,
        ) {
          final playerIds = scores.keys.toList();

          expect(
            playerIds,
            ['player-1', 'player-2'],
            reason:
                'Order should match game state player order when not sorted',
          );
        });
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should_handle_empty_player_grid_when_calculating_scores', () async {
        // Arrange
        final playerState = PlayerStateBuilder()
            .withPlayerId('empty-grid-player')
            .withGrid(PlayerGridBuilder().withCards([]).build())
            .build();

        final gameState = GameStateBuilder()
            .withPlayers([
              GamePlayerBuilder().withId('empty-grid-player').build(),
            ])
            .withPlayerStates({'empty-grid-player': playerState})
            .build();

        // Act
        final result = await calculateScores(
          CalculateScoresParams(gameState: gameState),
        );

        // Assert
        result.fold((failure) => fail('Should handle empty grid gracefully'), (
          scores,
        ) {
          expect(
            scores['empty-grid-player'],
            0,
            reason: 'Empty grid should result in score of 0',
          );
        });
      });

      test(
        'should_calculate_scores_for_multiple_players_independently',
        () async {
          // Arrange
          final player1State = PlayerStateBuilder()
              .withPlayerId('player-1')
              .withGrid(
                PlayerGridBuilder().withCards([
                  CardBuilder().withValue(5).revealed().build(),
                  CardBuilder().withValue(3).revealed().build(),
                ]).build(),
              )
              .build();

          final player2State = PlayerStateBuilder()
              .withPlayerId('player-2')
              .withGrid(
                PlayerGridBuilder().withCards([
                  CardBuilder().withValue(-2).revealed().build(),
                  CardBuilder().withValue(7).revealed().build(),
                ]).build(),
              )
              .build();

          final gameState = GameStateBuilder()
              .withPlayers([
                GamePlayerBuilder().withId('player-1').build(),
                GamePlayerBuilder().withId('player-2').build(),
              ])
              .withPlayerStates({
                'player-1': player1State,
                'player-2': player2State,
              })
              .build();

          // Act
          final result = await calculateScores(
            CalculateScoresParams(gameState: gameState),
          );

          // Assert
          result.fold((failure) => fail('Should calculate all player scores'), (
            scores,
          ) {
            expect(
              scores['player-1'],
              8, // 5 + 3
              reason: 'Player 1 score should be calculated independently',
            );
            expect(
              scores['player-2'],
              5, // -2 + 7
              reason: 'Player 2 score should be calculated independently',
            );
          });
        },
      );
    });
  });
}
