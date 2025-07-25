import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/distribute_cards.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/core/utils/constants.dart';

void main() {
  late DistributeCards distributeCards;

  setUp(() {
    distributeCards = DistributeCards();
  });

  group('DistributeCards UseCase', () {
    test('should distribute 12 cards to each player', () async {
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

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await distributeCards(
        DistributeCardsParams(gameState: initialState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (gameState) {
        // Each player should have 12 cards
        for (final player in gameState.players) {
          int cardCount = 0;
          for (final row in player.grid.cards) {
            for (final card in row) {
              if (card != null) {
                cardCount++;
                expect(card.isRevealed, false);
              }
            }
          }
          expect(cardCount, kCardsPerPlayer);
        }

        // Deck should be reduced by the number of distributed cards
        expect(gameState.deck.length, lessThan(initialState.deck.length));
      });
    });

    test('should reveal 2 initial cards for each player', () async {
      final players = List.generate(
        2,
        (index) => GamePlayer(
          id: 'player$index',
          name: 'GamePlayer $index',
          grid: PlayerGrid.empty(),
        ),
      );

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await distributeCards(
        DistributeCardsParams(
          gameState: initialState,
          revealInitialCards: true,
        ),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (gameState) {
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

    test('should create initial discard pile', () async {
      final players = [
        GamePlayer(
          id: 'player1',
          name: 'GamePlayer 1',
          grid: PlayerGrid.empty(),
        ),
      ];

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await distributeCards(
        DistributeCardsParams(gameState: initialState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (gameState) {
        expect(gameState.discardPile.length, 1);
        expect(gameState.discardPile.first.isRevealed, true);
      });
    });

    test('should maintain unique cards in distribution', () async {
      final players = List.generate(
        4,
        (index) => GamePlayer(
          id: 'player$index',
          name: 'GamePlayer $index',
          grid: PlayerGrid.empty(),
        ),
      );

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await distributeCards(
        DistributeCardsParams(gameState: initialState),
      );

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not fail'), (gameState) {
        // Collect all distributed cards
        final distributedCards = <int>[];

        for (final player in gameState.players) {
          for (final row in player.grid.cards) {
            for (final card in row) {
              if (card != null) {
                distributedCards.add(card.value);
              }
            }
          }
        }

        // Add discard pile card
        if (gameState.discardPile.isNotEmpty) {
          distributedCards.add(gameState.discardPile.first.value);
        }

        // Cards in deck
        final deckCards = gameState.deck.map((c) => c.value).toList();

        // Total cards should equal initial deck size
        expect(
          distributedCards.length + deckCards.length,
          initialState.deck.length,
        );
      });
    });

    test('should handle maximum players', () async {
      final players = List.generate(
        kMaxPlayers,
        (index) => GamePlayer(
          id: 'player$index',
          name: 'GamePlayer $index',
          grid: PlayerGrid.empty(),
        ),
      );

      final initialState = GameState.initial(
        roomId: 'room123',
        players: players,
      );

      final result = await distributeCards(
        DistributeCardsParams(gameState: initialState),
      );

      expect(result.isRight(), true);
    });
  });
}
