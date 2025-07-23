import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/draw_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
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
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
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
        // Player should have drawn card in hand
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
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
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
        // Player should have drawn top card from discard
        expect(newState.drawnCard, isNotNull);
        expect(newState.drawnCard!.value, 8);
        expect(newState.drawnCard!.isRevealed, true);

        // Discard pile should be reduced by 1
        expect(newState.discardPile.length, 1);
        expect(newState.discardPile.first.value, 3);
      });
    });

    test('should fail if not player turn', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
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
        failure.when(
          gameLogic: (message, code) => expect(code, 'NOT_YOUR_TURN'),
          server: (_, __, ___) => fail('Wrong failure type'),
          network: (_, __, ___) => fail('Wrong failure type'),
          validation: (_, __) => fail('Wrong failure type'),
          authentication: (_, __) => fail('Wrong failure type'),
          timeout: (_, __) => fail('Wrong failure type'),
          unknown: (_, __, ___) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should fail if already drawn card', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.drawPhase, // Already in draw phase
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
        failure.when(
          gameLogic: (message, code) => expect(code, 'ALREADY_DRAWN'),
          server: (_, __, ___) => fail('Wrong failure type'),
          network: (_, __, ___) => fail('Wrong failure type'),
          validation: (_, __) => fail('Wrong failure type'),
          authentication: (_, __) => fail('Wrong failure type'),
          timeout: (_, __) => fail('Wrong failure type'),
          unknown: (_, __, ___) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should fail if deck is empty', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.playing,
            currentPlayerIndex: 0,
            deck: [], // Empty deck
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
        failure.when(
          gameLogic: (message, code) => expect(code, 'DECK_EMPTY'),
          server: (_, __, ___) => fail('Wrong failure type'),
          network: (_, __, ___) => fail('Wrong failure type'),
          validation: (_, __) => fail('Wrong failure type'),
          authentication: (_, __) => fail('Wrong failure type'),
          timeout: (_, __) => fail('Wrong failure type'),
          unknown: (_, __, ___) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should fail if discard pile is empty', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.playing,
            currentPlayerIndex: 0,
            discardPile: [], // Empty discard
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
        failure.when(
          gameLogic: (message, code) => expect(code, 'DISCARD_EMPTY'),
          server: (_, __, ___) => fail('Wrong failure type'),
          network: (_, __, ___) => fail('Wrong failure type'),
          validation: (_, __) => fail('Wrong failure type'),
          authentication: (_, __) => fail('Wrong failure type'),
          timeout: (_, __) => fail('Wrong failure type'),
          unknown: (_, __, ___) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should reshuffle deck when empty except last discard', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
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
