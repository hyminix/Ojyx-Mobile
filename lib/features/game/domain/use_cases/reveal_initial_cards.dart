import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../entities/game_state.dart';
import '../entities/player.dart';

class RevealInitialCardsParams {
  final GameState gameState;
  final String playerId;
  final List<(int, int)> positions;

  const RevealInitialCardsParams({
    required this.gameState,
    required this.playerId,
    required this.positions,
  });
}

class RevealInitialCards
    implements UseCase<GameState, RevealInitialCardsParams> {
  @override
  Future<Either<Failure, GameState>> call(
    RevealInitialCardsParams params,
  ) async {
    try {
      // Validate positions count
      if (params.positions.length != kInitialRevealedCards) {
        return Left(
          Failure.validation(
            message: 'Must reveal exactly $kInitialRevealedCards cards',
            errors: {
              'positions':
                  'Expected $kInitialRevealedCards positions, got ${params.positions.length}',
            },
          ),
        );
      }

      // Find player
      final playerIndex = params.gameState.players.indexWhere(
        (p) => p.id == params.playerId,
      );

      if (playerIndex == -1) {
        return Left(
          Failure.gameLogic(
            message: 'GamePlayer not found',
            code: 'PLAYER_NOT_FOUND',
          ),
        );
      }

      final player = params.gameState.players[playerIndex];
      var updatedGrid = player.grid;

      // Validate and reveal each position
      for (final (row, col) in params.positions) {
        // Validate position
        if (row < 0 || row >= kGridRows || col < 0 || col >= kGridColumns) {
          return Left(
            Failure.validation(
              message: 'Invalid card position',
              errors: {'position': 'Position ($row, $col) is out of bounds'},
            ),
          );
        }

        // Check if card exists at position
        final card = updatedGrid.getCard(row, col);
        if (card == null) {
          return Left(
            Failure.gameLogic(
              message: 'No card at position ($row, $col)',
              code: 'CARD_NOT_FOUND',
            ),
          );
        }

        // Check if already revealed
        if (card.isRevealed) {
          return Left(
            Failure.gameLogic(
              message: 'Card at position ($row, $col) is already revealed',
              code: 'CARD_ALREADY_REVEALED',
            ),
          );
        }

        // Reveal the card
        updatedGrid = updatedGrid.revealCard(row, col);
      }

      // Update player with new grid
      final updatedPlayer = player.copyWith(grid: updatedGrid);

      // Update players list
      final updatedPlayers = List<GamePlayer>.from(params.gameState.players);
      updatedPlayers[playerIndex] = updatedPlayer;

      // Return updated game state
      return Right(params.gameState.copyWith(players: updatedPlayers));
    } catch (e) {
      return Left(
        Failure.unknown(message: 'Failed to reveal initial cards', error: e),
      );
    }
  }
}
