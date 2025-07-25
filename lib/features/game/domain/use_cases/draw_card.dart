import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import '../entities/game_state.dart';
import '../entities/card.dart';

enum DrawSource { deck, discard }

class DrawCardParams {
  final GameState gameState;
  final String playerId;
  final DrawSource source;

  const DrawCardParams({
    required this.gameState,
    required this.playerId,
    required this.source,
  });
}

class DrawCard implements UseCase<GameState, DrawCardParams> {
  @override
  Future<Either<Failure, GameState>> call(DrawCardParams params) async {
    try {
      final gameState = params.gameState;
      final playerId = params.playerId;

      // Validate it's player's turn
      final currentPlayer = gameState.currentPlayer;
      if (currentPlayer.id != playerId) {
        return const Left(
          Failure.gameLogic(message: 'Not your turn', code: 'NOT_YOUR_TURN'),
        );
      }

      // Check if already drawn
      if (gameState.drawnCard != null) {
        return const Left(
          Failure.gameLogic(
            message: 'Already drawn a card this turn',
            code: 'ALREADY_DRAWN',
          ),
        );
      }

      // Validate game status
      if (gameState.status != GameStatus.playing &&
          gameState.status != GameStatus.drawPhase) {
        return const Left(
          Failure.gameLogic(
            message: 'Cannot draw card in current game status',
            code: 'INVALID_STATUS',
          ),
        );
      }

      Card drawnCard;
      GameState newState;

      if (params.source == DrawSource.deck) {
        // Draw from deck
        var deck = List<Card>.from(gameState.deck);
        var discardPile = List<Card>.from(gameState.discardPile);

        // Check if deck needs reshuffling
        if (deck.isEmpty && discardPile.length > 1) {
          // Reshuffle all discard cards except the top one
          final topDiscard = discardPile.removeAt(0);
          deck = discardPile.map((c) => c.copyWith(isRevealed: false)).toList()
            ..shuffle();
          discardPile = [topDiscard];
        }

        if (deck.isEmpty) {
          return const Left(
            Failure.gameLogic(message: 'Deck is empty', code: 'DECK_EMPTY'),
          );
        }

        drawnCard = deck.removeAt(0);
        newState = gameState.copyWith(
          deck: deck,
          discardPile: discardPile,
          drawnCard: drawnCard,
          status: GameStatus.drawPhase,
        );
      } else {
        // Draw from discard pile
        if (gameState.discardPile.isEmpty) {
          return const Left(
            Failure.gameLogic(
              message: 'Discard pile is empty',
              code: 'DISCARD_EMPTY',
            ),
          );
        }

        final discardPile = List<Card>.from(gameState.discardPile);
        drawnCard = discardPile.removeAt(0);

        newState = gameState.copyWith(
          discardPile: discardPile,
          drawnCard: drawnCard,
          status: GameStatus.drawPhase,
        );
      }

      return Right(newState);
    } catch (e) {
      return Left(Failure.unknown(message: 'Failed to draw card', error: e));
    }
  }
}
