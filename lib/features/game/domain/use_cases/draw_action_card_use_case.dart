import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/constants.dart';
import '../entities/game_state.dart';
import '../entities/game_player.dart';
import '../entities/card.dart' as game_card;
import '../repositories/action_card_repository.dart';

class DrawActionCardParams {
  final String playerId;
  final GameState gameState;

  DrawActionCardParams({required this.playerId, required this.gameState});
}

class DrawActionCardUseCase extends UseCase<GameState, DrawActionCardParams> {
  final ActionCardRepository _repository;

  DrawActionCardUseCase(this._repository);

  @override
  Future<Either<Failure, GameState>> call(DrawActionCardParams params) async {
    try {
      // Check if game is in progress
      if (params.gameState.status != GameStatus.playing) {
        return const Left(
          Failure.gameLogic(
            message: 'Game is not in progress',
            code: 'GAME_NOT_IN_PROGRESS',
          ),
        );
      }

      // Check if it's the player's turn
      final currentPlayer = params.gameState.currentPlayer;
      if (currentPlayer.id != params.playerId) {
        return const Left(
          Failure.gameLogic(
            message: 'It is not your turn',
            code: 'NOT_YOUR_TURN',
          ),
        );
      }

      // Check if player has already drawn a card this turn
      if (params.gameState.drawnCard != null) {
        return const Left(
          Failure.gameLogic(
            message: 'You have already drawn a card this turn',
            code: 'ALREADY_DRAWN',
          ),
        );
      }

      // Find the player
      final playerIndex = params.gameState.players.indexWhere(
        (p) => p.id == params.playerId,
      );
      if (playerIndex == -1) {
        return const Left(
          Failure.gameLogic(
            message: 'GamePlayer not found',
            code: 'PLAYER_NOT_FOUND',
          ),
        );
      }

      final player = params.gameState.players[playerIndex];

      // Check if player can draw more action cards
      if (player.actionCards.length >= kMaxActionCardsInHand) {
        return const Left(
          Failure.gameLogic(
            message:
                'You cannot draw more action cards (max $kMaxActionCardsInHand)',
            code: 'ACTION_CARDS_FULL',
          ),
        );
      }

      // Draw an action card from the repository
      final drawnCard = await _repository.drawActionCard();
      if (drawnCard == null) {
        return const Left(
          Failure.gameLogic(
            message: 'No action cards available in the deck',
            code: 'NO_ACTION_CARDS',
          ),
        );
      }

      // Add the card to the player's hand
      await _repository.addActionCardToPlayer(params.playerId, drawnCard);

      // Update the player in game state
      final updatedPlayer = player.addActionCard(drawnCard);
      final updatedPlayers = List<GamePlayer>.from(params.gameState.players);
      updatedPlayers[playerIndex] = updatedPlayer;

      // Create updated game state
      final updatedGameState = params.gameState.copyWith(
        players: updatedPlayers,
        // Mark that a card was drawn this turn with a marker card
        drawnCard: const game_card.Card(value: 0, isRevealed: true),
      );

      // Note: For immediate action cards, the UI will handle forcing the player
      // to use the card immediately. We don't need a separate pending action system.

      return Right(updatedGameState);
    } catch (e) {
      return Left(
        Failure.unknown(message: 'Failed to draw action card', error: e),
      );
    }
  }
}
