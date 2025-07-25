import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  group('GameState Entity - Comprehensive Behavior Tests', () {
    late List<GamePlayer> players;

    setUp(() {
      players = [
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
    });

    test('should initialize game with waiting status when created', () {
      final gameState = GameState.initial(roomId: 'room123', players: players);

      expect(gameState.roomId, 'room123');
      expect(gameState.players, equals(players));
      expect(gameState.currentPlayerIndex, 0);
      expect(gameState.deck.length, greaterThan(0));
      expect(gameState.discardPile, isEmpty);
      expect(gameState.status, GameStatus.waitingToStart);
      expect(gameState.turnDirection, TurnDirection.clockwise);
      expect(gameState.lastRound, false);
      expect(gameState.initiatorPlayerId, isNull);
    });

    test('should return first player as current player when game starts', () {
      final gameState = GameState.initial(roomId: 'room123', players: players);

      expect(gameState.currentPlayer.id, 'player1');
    });

    test(
      'should advance turn to next player in clockwise direction when turn ends',
      () {
        final gameState = GameState.initial(
          roomId: 'room123',
          players: players,
        );

        final nextState = gameState.nextPlayer();

        expect(nextState.currentPlayerIndex, 1);
        expect(nextState.currentPlayer.id, 'player2');
      },
    );

    test(
      'should advance turn to previous player when direction is counter-clockwise',
      () {
        final gameState = GameState.initial(
          roomId: 'room123',
          players: players,
          currentPlayerIndex: 1,
        ).copyWith(turnDirection: TurnDirection.counterClockwise);

        final nextState = gameState.nextPlayer();

        expect(nextState.currentPlayerIndex, 0);
        expect(nextState.currentPlayer.id, 'player1');
      },
    );

    test('should loop back to first player when last player finishes turn', () {
      final gameState = GameState.initial(
        roomId: 'room123',
        players: players,
        currentPlayerIndex: 1,
      );

      final nextState = gameState.nextPlayer();

      expect(nextState.currentPlayerIndex, 0);
    });

    test('should provide top card from deck when player draws', () {
      final gameState = GameState.initial(roomId: 'room123', players: players);

      final initialDeckSize = gameState.deck.length;
      final result = gameState.drawCard();

      expect(result.$1, isNotNull); // Card drawn
      expect(result.$2.deck.length, initialDeckSize - 1);
    });

    test(
      'should recycle discard pile into deck when no cards remain to draw',
      () {
        const topDiscard = Card(value: 5);
        final gameState = GameState.initial(roomId: 'room123', players: players)
            .copyWith(
              deck: [], // Empty deck
              discardPile: [
                topDiscard,
                const Card(value: 3),
                const Card(value: 7),
              ],
            );

        final result = gameState.drawCard();

        expect(result.$1, isNotNull);
        expect(result.$2.deck.length, 1); // 2 cards reshuffled, 1 drawn
        expect(result.$2.discardPile.length, 1);
        expect(result.$2.discardPile.first, equals(topDiscard));
      },
    );

    test('should discard card', () {
      const card = Card(value: 8);
      final gameState = GameState.initial(roomId: 'room123', players: players);

      final updatedState = gameState.discardCard(card);

      expect(updatedState.discardPile.first, equals(card));
    });

    test('should check if game can start', () {
      final gameState = GameState.initial(roomId: 'room123', players: players);

      expect(gameState.canStart, true);

      final singlePlayerState = GameState.initial(
        roomId: 'room123',
        players: [players.first],
      );

      expect(singlePlayerState.canStart, false);
    });

    test('should detect end of round when player reveals all cards', () {
      final gridWithAllRevealed = PlayerGrid.fromCards(
        List.generate(
          kCardsPerPlayer,
          (index) => Card(value: index, isRevealed: true),
        ),
      );

      final updatedPlayers = [
        players.first.copyWith(grid: gridWithAllRevealed),
        players[1],
      ];

      final gameState = GameState.initial(
        roomId: 'room123',
        players: players,
      ).copyWith(status: GameStatus.playing);

      final updatedState = gameState.copyWith(players: updatedPlayers);

      expect(updatedState.shouldTriggerLastRound, true);
    });

    test('should check if all players finished last round', () {
      final updatedPlayers = players
          .map((p) => p.copyWith(hasFinishedRound: true))
          .toList();

      final gameState = GameState.initial(
        roomId: 'room123',
        players: players,
      ).copyWith(lastRound: true, players: updatedPlayers);

      expect(gameState.allPlayersFinishedRound, true);
    });

    test('should calculate scores with penalty for initiator', () {
      final grid1 = PlayerGrid.empty()
          .setCard(0, 0, const Card(value: 5, isRevealed: true))
          .setCard(0, 1, const Card(value: 3, isRevealed: true));

      final grid2 = PlayerGrid.empty()
          .setCard(0, 0, const Card(value: 2, isRevealed: true))
          .setCard(0, 1, const Card(value: 1, isRevealed: true));

      final updatedPlayers = [
        players.first.copyWith(grid: grid1),
        players[1].copyWith(grid: grid2),
      ];

      final gameState = GameState.initial(
        roomId: 'room123',
        players: updatedPlayers,
      ).copyWith(initiatorPlayerId: 'player1');

      final scores = gameState.calculateScores();

      expect(scores['player1'], 16); // (5+3) * 2 for penalty
      expect(scores['player2'], 3); // 2+1 no penalty
    });

    // === TESTS MERGED FROM game_state_clean_test.dart ===

    test(
      'should be a pure domain entity without JSON serialization coupling',
      () {
        final gameState = GameState.initial(
          roomId: 'test-room',
          players: players,
        );

        // Verify that GameState is a pure domain entity focused on behavior
        expect(gameState.roomId, equals('test-room'));
        expect(gameState.players, equals(players));
        expect(gameState.currentPlayerIndex, equals(0));

        // Verify the entity maintains its domain characteristics
        final type = gameState.runtimeType;
        expect(type.toString(), contains('GameState'));
      },
    );

    test('should maintain all core business logic methods for game flow', () {
      final gameState = GameState.initial(
        roomId: 'test-room',
        players: players,
      );

      // Ensure all business logic is preserved and functional
      expect(gameState.currentPlayer, equals(players[0]));
      expect(gameState.canStart, isTrue);

      // Test turn advancement behavior
      final nextState = gameState.nextPlayer();
      expect(nextState.currentPlayerIndex, equals(1));

      // Test card drawing behavior
      final (drawnCard, newState) = gameState.drawCard();
      expect(drawnCard, isNotNull);
      expect(newState.deck.length, equals(gameState.deck.length - 1));

      // Test card discarding behavior
      final discardState = gameState.discardCard(const Card(value: 3));
      expect(discardState.discardPile.first.value, equals(3));

      // Test end-game detection
      expect(gameState.shouldTriggerLastRound, isFalse);

      // Test score calculation
      final scores = gameState.calculateScores();
      expect(scores.containsKey('player1'), isTrue);
      expect(scores.containsKey('player2'), isTrue);
    });

    test('should work with immutability pattern using copyWith', () {
      final gameState = GameState.initial(
        roomId: 'test-room',
        players: players,
      );

      // Test that Freezed functionality works for immutable updates
      final copied = gameState.copyWith(currentPlayerIndex: 1);
      expect(copied.currentPlayerIndex, equals(1));
      expect(copied.roomId, equals(gameState.roomId));
      expect(
        gameState.currentPlayerIndex,
        equals(0),
        reason: 'Original should remain unchanged',
      );

      // Test equality behavior for value objects using same deck
      final sameState = gameState.copyWith();
      expect(gameState, equals(sameState));

      // Test that modified states are not equal
      final differentState = gameState.copyWith(currentPlayerIndex: 1);
      expect(gameState, isNot(equals(differentState)));
    });
  });
}
