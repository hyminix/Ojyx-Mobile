import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/draw_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/errors/failures.dart';

void main() {
  late DrawCard drawCard;

  setUp(() {
    drawCard = DrawCard();
  });

  group('DrawCard UseCase', () {
    test('should draw card from deck successfully', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.playing,
            currentPlayerIndex: 0,
            deck: [
              const Card(value: 5),
              const Card(value: 10),
              const Card(value: -2),
            ],
          );

      final result = await drawCard(
        DrawCardParams(
          gameState: gameState,
          playerId: 'player1',
          source: DrawSource.deck,
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // GamePlayer should have drawn card in hand
        expect(newState.drawnCard, isNotNull);
        expect(newState.drawnCard!.value, 5);

        // Deck should be reduced by 1
        expect(newState.deck.length, gameState.deck.length - 1);

        // Game status should be drawPhase
        expect(newState.status, GameStatus.drawPhase);
      });
    });

    test('should draw card from discard pile successfully', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'GamePlayer 2',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.playing,
            currentPlayerIndex: 0,
            discardPile: [
              const Card(value: 8, isRevealed: true),
              const Card(value: 3, isRevealed: true),
            ],
          );

      final result = await drawCard(
        DrawCardParams(
          gameState: gameState,
          playerId: 'player1',
          source: DrawSource.discard,
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // GamePlayer should have drawn top card from discard
        expect(newState.drawnCard, isNotNull);
        expect(newState.drawnCard!.value, 8);
        expect(newState.drawnCard!.isRevealed, true);

        // Discard pile should be reduced by 1
        expect(newState.discardPile.length, 1);
        expect(newState.discardPile.first.value, 3);
      });
    });

    test(
      'should fail with appropriate error code when draw conditions are invalid',
      () async {
        // Define test cases for different failure scenarios
        final testCases = [
          // Not player's turn
          () async {
            final players = [
              GamePlayer(
                id: 'player1',
                name: 'GamePlayer 1',
                grid: PlayerGrid.empty(),
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

            final result = await drawCard(
              DrawCardParams(
                gameState: gameState,
                playerId: 'player2', // Not current player
                source: DrawSource.deck,
              ),
            );

            expect(result.isLeft(), true);
            result.fold((failure) {
              expect(failure, isA<GameLogicFailure>());
              expect((failure as GameLogicFailure).code, 'NOT_YOUR_TURN');
            }, (_) => fail('Should have failed'));
          },
          // Already drawn card
          () async {
            final players = [
              GamePlayer(
                id: 'player1',
                name: 'GamePlayer 1',
                grid: PlayerGrid.empty(),
                isHost: true,
              ),
            ];
            final gameState =
                GameState.initial(roomId: 'room123', players: players).copyWith(
                  status: GameStatus.drawPhase,
                  currentPlayerIndex: 0,
                  drawnCard: const Card(value: 5),
                );

            final result = await drawCard(
              DrawCardParams(
                gameState: gameState,
                playerId: 'player1',
                source: DrawSource.deck,
              ),
            );

            expect(result.isLeft(), true);
            result.fold((failure) {
              expect(failure, isA<GameLogicFailure>());
              expect((failure as GameLogicFailure).code, 'ALREADY_DRAWN');
            }, (_) => fail('Should have failed'));
          },
          // Deck is empty
          () async {
            final players = [
              GamePlayer(
                id: 'player1',
                name: 'GamePlayer 1',
                grid: PlayerGrid.empty(),
                isHost: true,
              ),
            ];
            final gameState =
                GameState.initial(roomId: 'room123', players: players).copyWith(
                  status: GameStatus.playing,
                  currentPlayerIndex: 0,
                  deck: [],
                );

            final result = await drawCard(
              DrawCardParams(
                gameState: gameState,
                playerId: 'player1',
                source: DrawSource.deck,
              ),
            );

            expect(result.isLeft(), true);
            result.fold((failure) {
              expect(failure, isA<GameLogicFailure>());
              expect((failure as GameLogicFailure).code, 'DECK_EMPTY');
            }, (_) => fail('Should have failed'));
          },
          // Discard pile is empty
          () async {
            final players = [
              GamePlayer(
                id: 'player1',
                name: 'GamePlayer 1',
                grid: PlayerGrid.empty(),
                isHost: true,
              ),
            ];
            final gameState =
                GameState.initial(roomId: 'room123', players: players).copyWith(
                  status: GameStatus.playing,
                  currentPlayerIndex: 0,
                  discardPile: [],
                );

            final result = await drawCard(
              DrawCardParams(
                gameState: gameState,
                playerId: 'player1',
                source: DrawSource.discard,
              ),
            );

            expect(result.isLeft(), true);
            result.fold((failure) {
              expect(failure, isA<GameLogicFailure>());
              expect((failure as GameLogicFailure).code, 'DISCARD_EMPTY');
            }, (_) => fail('Should have failed'));
          },
        ];

        // Execute all test cases
        for (final testCase in testCases) {
          await testCase();
        }
      },
    );

    test('should reshuffle deck when empty except last discard', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.playing,
            currentPlayerIndex: 0,
            deck: [], // Empty deck
            discardPile: [
              const Card(value: 8, isRevealed: true),
              const Card(value: 3, isRevealed: true),
              const Card(value: 5, isRevealed: true),
              const Card(value: -1, isRevealed: true),
            ],
          );

      final result = await drawCard(
        DrawCardParams(
          gameState: gameState,
          playerId: 'player1',
          source: DrawSource.deck,
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Should have drawn a card
        expect(newState.drawnCard, isNotNull);

        // Deck should have been reshuffled with discard cards (except top)
        expect(newState.deck.length, 2); // 3 cards reshuffled - 1 drawn

        // Discard should only have the top card
        expect(newState.discardPile.length, 1);
        expect(newState.discardPile.first.value, 8);
      });
    });
  });
}
