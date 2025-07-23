import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/start_game.dart';
import 'package:ojyx/features/game/domain/use_cases/distribute_cards.dart';
import 'package:ojyx/features/game/domain/use_cases/reveal_initial_cards.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
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
    test('should start game with proper distribution', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
      ];

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await startGame(
        StartGameParams(
          gameState: initialState,
          playerInitialPositions: {
            'player1': [(0, 0), (2, 3)],
            'player2': [(0, 1), (2, 2)],
          },
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (gameState) {
        // Game should be in playing status
        expect(gameState.status, GameStatus.playing);
        expect(gameState.startedAt, isNotNull);

        // Each player should have cards distributed
        for (final player in gameState.players) {
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

          expect(cardCount, kCardsPerPlayer);
          expect(revealedCount, kInitialRevealedCards);
        }

        // Should have initial discard pile
        expect(gameState.discardPile.length, 1);
        expect(gameState.discardPile.first.isRevealed, true);
      });
    });

    test('should fail if not enough players', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
      ];

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await startGame(
        StartGameParams(
          gameState: initialState,
          playerInitialPositions: {
            'player1': [(0, 0), (2, 3)],
          },
        ),
      );

      expect(result.isLeft(), true);
    });

    test('should fail if game already started', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
      ];

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      ).copyWith(status: GameStatus.playing);

      final result = await startGame(
        StartGameParams(
          gameState: initialState,
          playerInitialPositions: {
            'player1': [(0, 0), (2, 3)],
            'player2': [(0, 1), (2, 2)],
          },
        ),
      );

      expect(result.isLeft(), true);
    });

    test('should use default positions if not provided', () async {
      final players = [
        Player(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        Player(id: 'player2', name: 'Player 2', grid: PlayerGrid.empty()),
      ];

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await startGame(StartGameParams(gameState: initialState));

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (gameState) {
        // Each player should still have 2 cards revealed
        for (final player in gameState.players) {
          int revealedCount = 0;

          for (final row in player.grid.cards) {
            for (final card in row) {
              if (card != null && card.isRevealed) {
                revealedCount++;
              }
            }
          }

          expect(revealedCount, kInitialRevealedCards);
        }
      });
    });

    test('should handle maximum players', () async {
      final players = List.generate(
        kMaxPlayers,
        (index) => Player(
          id: 'player$index',
          name: 'Player $index',
          grid: PlayerGrid.empty(),
          isHost: index == 0,
        ),
      );

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await startGame(StartGameParams(gameState: initialState));

      expect(result.isRight(), true);
    });
  });
}
