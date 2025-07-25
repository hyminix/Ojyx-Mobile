import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/usecases/usecase.dart';
import 'package:ojyx/core/utils/constants.dart';
import '../entities/game_state.dart';
import 'distribute_cards.dart';
import 'reveal_initial_cards.dart';

class StartGameParams {
  final GameState gameState;
  final Map<String, List<(int, int)>>? playerInitialPositions;

  const StartGameParams({required this.gameState, this.playerInitialPositions});
}

class StartGame implements UseCase<GameState, StartGameParams> {
  final DistributeCards distributeCards;
  final RevealInitialCards revealInitialCards;

  const StartGame({
    required this.distributeCards,
    required this.revealInitialCards,
  });

  @override
  Future<Either<Failure, GameState>> call(StartGameParams params) async {
    try {
      final gameState = params.gameState;

      // Validate game can start
      if (!gameState.canStart) {
        return const Left(
          Failure.validation(
            message: 'Cannot start game',
            errors: {
              'players': 'Need between $kMinPlayers and $kMaxPlayers players',
            },
          ),
        );
      }

      // Check if game already started
      if (gameState.status != GameStatus.waitingToStart) {
        return const Left(
          Failure.gameLogic(
            message: 'Game has already started',
            code: 'GAME_ALREADY_STARTED',
          ),
        );
      }

      // Update game status to playing
      var updatedState = gameState.copyWith(
        status: GameStatus.playing,
        startedAt: DateTime.now(),
      );

      // Distribute cards without revealing
      final distributeResult = await distributeCards(
        DistributeCardsParams(
          gameState: updatedState,
          revealInitialCards: false,
        ),
      );

      if (distributeResult.isLeft()) {
        return distributeResult;
      }

      updatedState = distributeResult.getOrElse((failure) => updatedState);

      // Reveal initial cards for each player
      final positions = params.playerInitialPositions ?? {};

      for (final player in updatedState.players) {
        final playerPositions = positions[player.id] ?? _getDefaultPositions();

        final revealResult = await revealInitialCards(
          RevealInitialCardsParams(
            gameState: updatedState,
            playerId: player.id,
            positions: playerPositions,
          ),
        );

        if (revealResult.isLeft()) {
          return revealResult;
        }

        updatedState = revealResult.getOrElse((failure) => updatedState);
      }

      return Right(updatedState);
    } catch (e) {
      return Left(Failure.unknown(message: 'Failed to start game', error: e));
    }
  }

  List<(int, int)> _getDefaultPositions() {
    // Default positions for initial reveal
    // Could be randomized in future
    return [(0, 0), (2, 3)];
  }
}
