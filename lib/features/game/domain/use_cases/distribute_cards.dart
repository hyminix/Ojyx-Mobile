import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../entities/game_state.dart';
import '../entities/game_player.dart';
import '../entities/player_grid.dart';
import '../entities/card.dart';

class DistributeCardsParams {
  final GameState gameState;
  final bool revealInitialCards;

  const DistributeCardsParams({
    required this.gameState,
    this.revealInitialCards = false,
  });
}

class DistributeCards implements UseCase<GameState, DistributeCardsParams> {
  @override
  Future<Either<Failure, GameState>> call(DistributeCardsParams params) async {
    try {
      final gameState = params.gameState;
      final deck = List<Card>.from(gameState.deck);
      final updatedPlayers = <GamePlayer>[];

      // Verify we have enough cards
      final requiredCards =
          gameState.players.length * kCardsPerPlayer + 1; // +1 for discard
      if (deck.length < requiredCards) {
        return const Left(
          Failure.gameLogic(
            message: 'Not enough cards in deck for distribution',
            code: 'INSUFFICIENT_CARDS',
          ),
        );
      }

      // Distribute cards to each player
      for (final player in gameState.players) {
        final playerCards = <Card>[];

        // Take 12 cards from deck
        for (int i = 0; i < kCardsPerPlayer; i++) {
          if (deck.isEmpty) {
            return const Left(
              Failure.gameLogic(
                message: 'Deck ran out of cards during distribution',
                code: 'DECK_EMPTY',
              ),
            );
          }
          playerCards.add(deck.removeAt(0));
        }

        // Create grid from cards
        var updatedGrid = PlayerGrid.fromCards(playerCards);

        // Reveal initial cards if requested
        if (params.revealInitialCards) {
          // Reveal 2 random cards
          final positions = _selectRandomPositions();
          for (final (row, col) in positions) {
            updatedGrid = updatedGrid.revealCard(row, col);
          }
        }

        updatedPlayers.add(player.copyWith(grid: updatedGrid));
      }

      // Create initial discard pile
      if (deck.isEmpty) {
        return const Left(
          Failure.gameLogic(
            message: 'No cards left for discard pile',
            code: 'DECK_EMPTY',
          ),
        );
      }

      final discardCard = deck.removeAt(0).reveal();
      final discardPile = [discardCard];

      // Update game state
      final newGameState = gameState.copyWith(
        players: updatedPlayers,
        deck: deck,
        discardPile: discardPile,
      );

      return Right(newGameState);
    } catch (e) {
      return Left(
        Failure.unknown(message: 'Failed to distribute cards', error: e),
      );
    }
  }

  List<(int, int)> _selectRandomPositions() {
    // For MVP, we'll use fixed positions for initial reveal
    // In a real game, these could be randomized
    return [(0, 0), (2, 3)]; // Top-left and bottom-right
  }
}
