import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/end_turn.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/errors/failures.dart';

void main() {
  late EndTurn endTurn;

  setUp(() {
    endTurn = EndTurn();
  });

  group('EndTurn UseCase', () {
    // Parameterized test for different turn validation scenarios
    final turnValidationCases = [
      {
        'description':
            'should validate and clear completed columns when all conditions are met',
        'setupGrid': () => PlayerGrid.empty()
            .placeCard(const Card(value: 5, isRevealed: true), 0, 1)
            .placeCard(const Card(value: 5, isRevealed: true), 1, 1)
            .placeCard(const Card(value: 5, isRevealed: true), 2, 1)
            .placeCard(const Card(value: 8), 0, 0)
            .placeCard(const Card(value: 2), 1, 2),
        'expectedColumnCleared': true,
        'expectedCardsInDiscard': 3,
        'expectedRemainingCards': [8, 2],
      },
      {
        'description':
            'should not clear columns when cards are not all revealed',
        'setupGrid': () => PlayerGrid.empty()
            .placeCard(const Card(value: 5, isRevealed: true), 0, 1)
            .placeCard(
              const Card(value: 5, isRevealed: false),
              1,
              1,
            ) // Not revealed
            .placeCard(const Card(value: 5, isRevealed: true), 2, 1),
        'expectedColumnCleared': false,
        'expectedCardsInDiscard': 0,
        'expectedRemainingCards': [5], // All cards remain
      },
      {
        'description':
            'should handle multiple completed columns simultaneously',
        'setupGrid': () => PlayerGrid.empty()
            // Column 0: all 3s
            .placeCard(const Card(value: 3, isRevealed: true), 0, 0)
            .placeCard(const Card(value: 3, isRevealed: true), 1, 0)
            .placeCard(const Card(value: 3, isRevealed: true), 2, 0)
            // Column 2: all 7s
            .placeCard(const Card(value: 7, isRevealed: true), 0, 2)
            .placeCard(const Card(value: 7, isRevealed: true), 1, 2)
            .placeCard(const Card(value: 7, isRevealed: true), 2, 2)
            // Other cards
            .placeCard(const Card(value: 1), 0, 1)
            .placeCard(const Card(value: 2), 1, 3),
        'expectedColumnCleared': true,
        'expectedCardsInDiscard': 6, // 3 + 3 cards cleared
        'expectedRemainingCards': [1, 2],
      },
    ];

    for (final testCase in turnValidationCases) {
      test(testCase['description'] as String, () async {
        final grid = (testCase['setupGrid'] as Function)();
        final players = [
          GamePlayer(
            id: 'player1',
            name: 'GamePlayer 1',
            grid: grid,
            isHost: true,
          ),
          GamePlayer(
            id: 'player2',
            name: 'GamePlayer 2',
            grid: PlayerGrid.empty(),
          ),
        ];

        final gameState = GameState.initial(
          roomId: 'room123',
          players: players,
        ).copyWith(status: GameStatus.playing, currentPlayerIndex: 0);

        final result = await endTurn(
          EndTurnParams(gameState: gameState, playerId: 'player1'),
        );

        expect(result.isRight(), true);

        result.fold((failure) => fail('Should not fail'), (newState) {
          final updatedPlayer = newState.players.first;
          final expectedColumnCleared =
              testCase['expectedColumnCleared'] as bool;
          final expectedCardsInDiscard =
              testCase['expectedCardsInDiscard'] as int;
          final expectedRemainingCards =
              testCase['expectedRemainingCards'] as List<int>;

          if (expectedColumnCleared) {
            // Verify columns are properly cleared
            if (testCase['description'].toString().contains('multiple')) {
              // Multiple columns test - check both columns 0 and 2
              expect(updatedPlayer.grid.cards[0][0], isNull);
              expect(updatedPlayer.grid.cards[0][2], isNull);
            } else {
              // Single column test - check column 1
              expect(updatedPlayer.grid.cards[0][1], isNull);
              expect(updatedPlayer.grid.cards[1][1], isNull);
              expect(updatedPlayer.grid.cards[2][1], isNull);
            }
          } else {
            // Verify columns are not cleared when conditions not met
            expect(updatedPlayer.grid.cards[0][1], isNotNull);
            expect(updatedPlayer.grid.cards[1][1], isNotNull);
            expect(updatedPlayer.grid.cards[2][1], isNotNull);
          }

          // Verify remaining cards are preserved
          for (final expectedValue in expectedRemainingCards) {
            bool foundCard = false;
            for (final row in updatedPlayer.grid.cards) {
              for (final card in row) {
                if (card?.value == expectedValue) {
                  foundCard = true;
                  break;
                }
              }
              if (foundCard) break;
            }
            expect(
              foundCard,
              true,
              reason: 'Expected card with value $expectedValue to remain',
            );
          }
        });
      });
    }

    test('should trigger last round when player reveals all cards', () async {
      // Create a grid with all cards revealed
      var grid = PlayerGrid.empty();
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 4; col++) {
          grid = grid.placeCard(
            Card(value: row + col, isRevealed: true),
            row,
            col,
          );
        }
      }

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(
        roomId: 'room123',
        players: players,
      ).copyWith(status: GameStatus.playing, currentPlayerIndex: 0);

      final result = await endTurn(
        EndTurnParams(gameState: gameState, playerId: 'player1'),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Should trigger end round
        expect(newState.status, GameStatus.lastRound);
        expect(newState.endRoundInitiator, 'player1');
      });
    });

    test(
      'should calculate player score correctly and reject wrong player turns',
      () async {
        final grid = PlayerGrid.empty()
            .placeCard(const Card(value: 5, isRevealed: true), 0, 0)
            .placeCard(const Card(value: -2, isRevealed: true), 0, 1)
            .placeCard(const Card(value: 10, isRevealed: false), 1, 0)
            .placeCard(const Card(value: 0, isRevealed: true), 1, 1);

        final players = [
          GamePlayer(
            id: 'player1',
            name: 'GamePlayer 1',
            grid: grid,
            isHost: true,
          ),
          GamePlayer(
            id: 'player2',
            name: 'GamePlayer 2',
            grid: PlayerGrid.empty(),
          ),
        ];

        final gameState = GameState.initial(
          roomId: 'room123',
          players: players,
        ).copyWith(status: GameStatus.playing, currentPlayerIndex: 0);

        // Test correct player turn
        final validResult = await endTurn(
          EndTurnParams(gameState: gameState, playerId: 'player1'),
        );

        expect(validResult.isRight(), true);
        validResult.fold((failure) => fail('Should not fail'), (newState) {
          final updatedPlayer = newState.players.first;
          // Score: 5 + (-2) + 10 + 0 = 13
          expect(updatedPlayer.currentScore, 13);
        });

        // Test wrong player turn
        final invalidResult = await endTurn(
          EndTurnParams(
            gameState: gameState,
            playerId: 'player2',
          ), // Wrong player
        );

        expect(invalidResult.isLeft(), true);
        invalidResult.fold((failure) {
          failure.when(
            gameLogic: (message, code) => expect(code, 'NOT_YOUR_TURN'),
            server: (_, _, __) => fail('Wrong failure type'),
            network: (_, _, __) => fail('Wrong failure type'),
            validation: (_, _) => fail('Wrong failure type'),
            authentication: (_, _) => fail('Wrong failure type'),
            timeout: (_, _) => fail('Wrong failure type'),
            unknown: (_, _, __) => fail('Wrong failure type'),
          );
        }, (_) => fail('Should have failed'));
      },
    );
  });
}
