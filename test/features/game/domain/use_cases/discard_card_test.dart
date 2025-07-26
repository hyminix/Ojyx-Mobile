import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/discard_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/errors/failures.dart';

void main() {
  late DiscardCard discardCard;

  setUp(() {
    discardCard = DiscardCard();
  });

  group('DiscardCard UseCase', () {
    test('should discard drawn card successfully', () async {
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
            status: GameStatus.drawPhase,
            currentPlayerIndex: 0,
            drawnCard: const Card(value: 5),
            discardPile: [const Card(value: 8, isRevealed: true)],
          );

      final result = await discardCard(
        DiscardCardParams(gameState: gameState, playerId: 'player1'),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Drawn card should be cleared
        expect(newState.drawnCard, isNull);

        // Discard pile should have the new card on top
        expect(newState.discardPile.length, 2);
        expect(newState.discardPile.first.value, 5);
        expect(newState.discardPile.first.isRevealed, true);

        // Turn should advance
        expect(newState.currentPlayerIndex, 1);
        expect(newState.status, GameStatus.playing);
      });
    });

    test('should exchange card with grid successfully', () async {
      final grid = PlayerGrid.empty();
      final gridWithCard = grid.placeCard(const Card(value: 10), 1, 2);

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: gridWithCard,
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
            status: GameStatus.drawPhase,
            currentPlayerIndex: 0,
            drawnCard: const Card(value: 3),
            discardPile: [const Card(value: 8, isRevealed: true)],
          );

      final result = await discardCard(
        DiscardCardParams(
          gameState: gameState,
          playerId: 'player1',
          gridPosition: const GridPosition(row: 1, col: 2),
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Check grid has new card
        final updatedPlayer = newState.players.first;
        final gridCard = updatedPlayer.grid.cards[1][2];
        expect(gridCard?.value, 3);
        expect(gridCard?.isRevealed, true);

        // Old card should be in discard
        expect(newState.discardPile.first.value, 10);
        expect(newState.discardPile.first.isRevealed, true);

        // Drawn card should be cleared
        expect(newState.drawnCard, isNull);
      });
    });

    test('should fail if no drawn card', () async {
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
            drawnCard: null, // No drawn card
          );

      final result = await discardCard(
        DiscardCardParams(gameState: gameState, playerId: 'player1'),
      );

      expect(result.isLeft(), true);

      result.fold((failure) {
        failure.when(
          gameLogic: (message, code) => expect(code, 'NO_DRAWN_CARD'),
          server: (_, _, __) => fail('Wrong failure type'),
          network: (_, _, __) => fail('Wrong failure type'),
          validation: (_, _) => fail('Wrong failure type'),
          authentication: (_, _) => fail('Wrong failure type'),
          timeout: (_, _) => fail('Wrong failure type'),
          unknown: (_, _, __) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should fail if not player turn', () async {
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
            status: GameStatus.drawPhase,
            currentPlayerIndex: 0,
            drawnCard: const Card(value: 5),
          );

      final result = await discardCard(
        DiscardCardParams(
          gameState: gameState,
          playerId: 'player2', // Not current player
        ),
      );

      expect(result.isLeft(), true);

      result.fold((failure) {
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
    });

    test('should fail if grid position is empty', () async {
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
            status: GameStatus.drawPhase,
            currentPlayerIndex: 0,
            drawnCard: const Card(value: 5),
          );

      final result = await discardCard(
        DiscardCardParams(
          gameState: gameState,
          playerId: 'player1',
          gridPosition: const GridPosition(row: 1, col: 2), // Empty position
        ),
      );

      expect(result.isLeft(), true);

      result.fold((failure) {
        failure.when(
          gameLogic: (message, code) => expect(code, 'EMPTY_POSITION'),
          server: (_, _, __) => fail('Wrong failure type'),
          network: (_, _, __) => fail('Wrong failure type'),
          validation: (_, _) => fail('Wrong failure type'),
          authentication: (_, _) => fail('Wrong failure type'),
          timeout: (_, _) => fail('Wrong failure type'),
          unknown: (_, _, __) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should fail if grid position is invalid', () async {
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
            status: GameStatus.drawPhase,
            currentPlayerIndex: 0,
            drawnCard: const Card(value: 5),
          );

      final result = await discardCard(
        DiscardCardParams(
          gameState: gameState,
          playerId: 'player1',
          gridPosition: const GridPosition(row: 5, col: 5), // Invalid position
        ),
      );

      expect(result.isLeft(), true);

      result.fold((failure) {
        failure.when(
          gameLogic: (message, code) => expect(code, 'INVALID_POSITION'),
          server: (_, _, __) => fail('Wrong failure type'),
          network: (_, _, __) => fail('Wrong failure type'),
          validation: (_, _) => fail('Wrong failure type'),
          authentication: (_, _) => fail('Wrong failure type'),
          timeout: (_, _) => fail('Wrong failure type'),
          unknown: (_, _, __) => fail('Wrong failure type'),
        );
      }, (_) => fail('Should have failed'));
    });

    test('should wrap around to first player after last player turn', () async {
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
        GamePlayer(
          id: 'player3',
          name: 'GamePlayer 3',
          grid: PlayerGrid.empty(),
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.drawPhase,
            currentPlayerIndex: 2, // Last player
            drawnCard: const Card(value: 5),
          );

      final result = await discardCard(
        DiscardCardParams(gameState: gameState, playerId: 'player3'),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Should wrap to first player
        expect(newState.currentPlayerIndex, 0);
      });
    });

    test('should check for column completion after exchange', () async {
      // Create a grid with 2 matching cards in a column
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: true), 0, 1)
          .placeCard(const Card(value: 5, isRevealed: true), 1, 1)
          .placeCard(
            const Card(value: 10),
            2,
            1,
          ); // Different card that will be replaced

      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: grid,
          isHost: true,
        ),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.drawPhase,
            currentPlayerIndex: 0,
            drawnCard: const Card(value: 5), // Matching card
          );

      final result = await discardCard(
        DiscardCardParams(
          gameState: gameState,
          playerId: 'player1',
          gridPosition: const GridPosition(row: 2, col: 1), // Complete column
        ),
      );

      if (result.isLeft()) {
        result.fold((failure) => print('Failure: $failure'), (_) {});
      }
      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        final updatedPlayer = newState.players.first;
        // Check all cards in column 1 are revealed
        final card0 = updatedPlayer.grid.cards[0][1];
        final card1 = updatedPlayer.grid.cards[1][1];
        final card2 = updatedPlayer.grid.cards[2][1];

        expect(card0, isNotNull);
        expect(card1, isNotNull);
        expect(card2, isNotNull);

        expect(card0!.value, 5);
        expect(card1!.value, 5);
        expect(card2!.value, 5);

        expect(card0.isRevealed, true);
        expect(card1.isRevealed, true);
        expect(card2.isRevealed, true);
      });
    });
  });
}
