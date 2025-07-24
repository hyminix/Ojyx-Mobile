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
    test('should reveal all cards for all players except initiator', () async {
      // Create grids with some hidden cards
      final grid1 = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: true), 0, 0)
          .placeCard(const Card(value: 10, isRevealed: false), 0, 1)
          .placeCard(const Card(value: 3, isRevealed: false), 1, 0);

      final grid2 = PlayerGrid.empty()
          .placeCard(const Card(value: 8, isRevealed: false), 0, 0)
          .placeCard(const Card(value: 2, isRevealed: true), 0, 1)
          .placeCard(const Card(value: 7, isRevealed: false), 1, 0);

      final players = [
        GamePlayer(id: 'player1', name: 'GamePlayer 1', grid: grid1, isHost: true),
        GamePlayer(id: 'player2', name: 'GamePlayer 2', grid: grid2),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            endRoundInitiator: 'player1', // GamePlayer 1 is initiator
          );

      final result = await processLastRound(
        ProcessLastRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // GamePlayer 1 (initiator) cards should remain as they were
        final player1 = newState.players[0];
        expect(player1.grid.cards[0][0]?.isRevealed, true); // Was revealed
        expect(player1.grid.cards[0][1]?.isRevealed, false); // Stays hidden
        expect(player1.grid.cards[1][0]?.isRevealed, false); // Stays hidden

        // GamePlayer 2 cards should all be revealed
        final player2 = newState.players[1];
        expect(player2.grid.cards[0][0]?.isRevealed, true);
        expect(player2.grid.cards[0][1]?.isRevealed, true);
        expect(player2.grid.cards[1][0]?.isRevealed, true);
      });
    });

    test('should not change status during last round processing', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(id: 'player2', name: 'GamePlayer 2', grid: PlayerGrid.empty()),
      ];

      final gameState = GameState.initial(
        roomId: 'room123',
        players: players,
      ).copyWith(status: GameStatus.lastRound, endRoundInitiator: 'player1');

      final result = await processLastRound(
        ProcessLastRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        expect(newState.status, GameStatus.lastRound);
      });
    });

    test('should handle case when initiator is not found', () async {
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: false), 0, 0)
          .placeCard(const Card(value: 10, isRevealed: false), 0, 1);

      final players = [
        GamePlayer(id: 'player1', name: 'GamePlayer 1', grid: grid, isHost: true),
        GamePlayer(id: 'player2', name: 'GamePlayer 2', grid: grid),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            endRoundInitiator: 'player3', // Non-existent player
          );

      final result = await processLastRound(
        ProcessLastRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // All players should have cards revealed
        for (final player in newState.players) {
          expect(player.grid.cards[0][0]?.isRevealed, true);
          expect(player.grid.cards[0][1]?.isRevealed, true);
        }
      });
    });

    test('should reveal cards only in occupied positions', () async {
      // Grid with some empty positions
      final grid = PlayerGrid.empty()
          .placeCard(const Card(value: 5, isRevealed: false), 0, 0)
          .placeCard(const Card(value: 10, isRevealed: false), 1, 1);
      // Other positions are empty

      final players = [
        GamePlayer(id: 'player1', name: 'GamePlayer 1', grid: grid, isHost: true),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            endRoundInitiator: 'player2', // Different player is initiator
          );

      final result = await processLastRound(
        ProcessLastRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        final player = newState.players[0];
        // Check revealed cards
        expect(player.grid.cards[0][0]?.isRevealed, true);
        expect(player.grid.cards[1][1]?.isRevealed, true);
        // Check empty positions remain null
        expect(player.grid.cards[0][1], isNull);
        expect(player.grid.cards[1][0], isNull);
      });
    });

    test('should handle multiple players correctly', () async {
      final players = List.generate(
        5,
        (index) => GamePlayer(
          id: 'player$index',
          name: 'GamePlayer $index',
          grid: PlayerGrid.empty().placeCard(
            Card(value: index, isRevealed: false),
            0,
            0,
          ),
          isHost: index == 0,
        ),
      );

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.lastRound,
            endRoundInitiator: 'player2', // GamePlayer 2 is initiator
          );

      final result = await processLastRound(
        ProcessLastRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        for (int i = 0; i < newState.players.length; i++) {
          final player = newState.players[i];
          if (player.id == 'player2') {
            // Initiator's cards stay hidden
            expect(player.grid.cards[0][0]?.isRevealed, false);
          } else {
            // Other players' cards are revealed
            expect(player.grid.cards[0][0]?.isRevealed, true);
          }
        }
      });
    });

    test('should do nothing if not in last round', () async {
      final grid = PlayerGrid.empty().placeCard(
        const Card(value: 5, isRevealed: false),
        0,
        0,
      );

      final players = [
        GamePlayer(id: 'player1', name: 'GamePlayer 1', grid: grid, isHost: true),
      ];

      final gameState = GameState.initial(roomId: 'room123', players: players)
          .copyWith(
            status: GameStatus.playing, // Not in last round
          );

      final result = await processLastRound(
        ProcessLastRoundParams(gameState: gameState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (newState) {
        // Card should remain hidden
        expect(newState.players[0].grid.cards[0][0]?.isRevealed, false);
      });
    });
  });
}
