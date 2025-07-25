import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/end_turn.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

void main() {
  late EndTurn endTurn;

  setUp(() {
    endTurn = EndTurn();
  });

  group('EndTurn UseCase', () {
    test('should validate completed columns and clear them', () async {
      // Create a grid with a completed column
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: true), 0, 1)
          .placeCard(const Card(value: 5, isRevealed: true), 1, 1)
          .placeCard(const Card(value: 5, isRevealed: true), 2, 1)
          .placeCard(const Card(value: 8), 0, 0)
          .placeCard(const Card(value: 2), 1, 2);

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

        // Column 1 should be cleared
        expect(updatedPlayer.grid.cards[0][1], isNull);
        expect(updatedPlayer.grid.cards[1][1], isNull);
        expect(updatedPlayer.grid.cards[2][1], isNull);

        // Other cards should remain
        expect(updatedPlayer.grid.cards[0][0]?.value, 8);
        expect(updatedPlayer.grid.cards[1][2]?.value, 2);

        // Cards should be added to discard pile
        expect(
          newState.discardPile.where((c) => c.value == 5).length,
          greaterThanOrEqualTo(3),
        );
      });
    });

    test('should not clear column if not all cards revealed', () async {
      // Create a grid with matching values but one not revealed
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: true), 0, 1)
          .placeCard(
            const Card(value: 5, isRevealed: false),
            1,
            1,
          ) // Not revealed
          .placeCard(const Card(value: 5, isRevealed: true), 2, 1);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
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

        // Column should not be cleared
        expect(updatedPlayer.grid.cards[0][1], isNotNull);
        expect(updatedPlayer.grid.cards[1][1], isNotNull);
        expect(updatedPlayer.grid.cards[2][1], isNotNull);
      });
    });

    test('should check if player has revealed all cards', () async {
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

    test('should handle multiple completed columns', () async {
      // Create a grid with two completed columns
      final grid = PlayerGrid.empty()
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
          .placeCard(const Card(value: 2), 1, 3);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
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

        // Both columns should be cleared
        expect(updatedPlayer.grid.cards[0][0], isNull);
        expect(updatedPlayer.grid.cards[1][0], isNull);
        expect(updatedPlayer.grid.cards[2][0], isNull);

        expect(updatedPlayer.grid.cards[0][2], isNull);
        expect(updatedPlayer.grid.cards[1][2], isNull);
        expect(updatedPlayer.grid.cards[2][2], isNull);

        // Other cards should remain
        expect(updatedPlayer.grid.cards[0][1]?.value, 1);
        expect(updatedPlayer.grid.cards[1][3]?.value, 2);
      });
    });

    test('should calculate score correctly', () async {
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
        // Score: 5 + (-2) + 10 + 0 = 13
        expect(updatedPlayer.currentScore, 13);
      });
    });

    test('should not process turn for wrong player', () async {
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

      final result = await endTurn(
        EndTurnParams(
          gameState: gameState,
          playerId: 'player2', // Wrong player
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
  });
}
