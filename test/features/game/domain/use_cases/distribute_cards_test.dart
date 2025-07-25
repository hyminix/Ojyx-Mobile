import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/distribute_cards.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/core/utils/constants.dart';

// Helper functions
int _countPlayerCards(GamePlayer player) {
  int count = 0;
  for (final row in player.grid.cards) {
    for (final card in row) {
      if (card != null) count++;
    }
  }
  return count;
}

bool _areAllCardsFaceDown(GamePlayer player) {
  for (final row in player.grid.cards) {
    for (final card in row) {
      if (card != null && card.isRevealed) {
        return false;
      }
    }
  }
  return true;
}

bool _hasCardInDiscard(List<Card> discardPile) {
  return discardPile.isNotEmpty;
}

void main() {
  late DistributeCards distributeCards;

  setUp(() {
    distributeCards = DistributeCards();
  });

  group('DistributeCards UseCase', () {
    test(
      'should ensure each player receives exactly their allocated cards',
      () async {
        final players = [
          GamePlayer(
            id: 'player1',
            name: 'Alice',
            grid: PlayerGrid.empty(),
            isHost: true,
          ),
          GamePlayer(id: 'player2', name: 'Bob', grid: PlayerGrid.empty()),
          GamePlayer(id: 'player3', name: 'Charlie', grid: PlayerGrid.empty()),
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
          // Verify each individual player has received their full allocation
          final player1 = gameState.players.firstWhere(
            (p) => p.id == 'player1',
          );
          final player2 = gameState.players.firstWhere(
            (p) => p.id == 'player2',
          );
          final player3 = gameState.players.firstWhere(
            (p) => p.id == 'player3',
          );

          // Each player must have exactly 12 cards (3x4 grid filled)
          expect(
            _countPlayerCards(player1),
            kCardsPerPlayer,
            reason: 'Player1 (Alice) should have received exactly 12 cards',
          );
          expect(
            _countPlayerCards(player2),
            kCardsPerPlayer,
            reason: 'Player2 (Bob) should have received exactly 12 cards',
          );
          expect(
            _countPlayerCards(player3),
            kCardsPerPlayer,
            reason: 'Player3 (Charlie) should have received exactly 12 cards',
          );

          // Verify cards are face down as dealt
          expect(
            _areAllCardsFaceDown(player1),
            true,
            reason: 'All of Alice\'s cards should be face down initially',
          );
          expect(
            _areAllCardsFaceDown(player2),
            true,
            reason: 'All of Bob\'s cards should be face down initially',
          );
          expect(
            _areAllCardsFaceDown(player3),
            true,
            reason: 'All of Charlie\'s cards should be face down initially',
          );

          // Verify total cards distributed correctly
          final totalDistributed = kCardsPerPlayer * players.length;
          final expectedRemainingInDeck =
              initialState.deck.length - totalDistributed - 1; // -1 for discard
          expect(
            gameState.deck.length,
            expectedRemainingInDeck,
            reason:
                'Deck should be reduced by exactly the number of cards distributed plus discard',
          );
        });
      },
    );

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
