import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/action_card.dart';
import '../repositories/game_state_repository.dart';

class UseActionCardParams {
  final String gameStateId;
  final String playerId;
  final ActionCardType actionCardType;
  final Map<String, dynamic>? targetData;

  UseActionCardParams({
    required this.gameStateId,
    required this.playerId,
    required this.actionCardType,
    this.targetData,
  });
}

class UseActionCardUseCase extends UseCase<Map<String, dynamic>, UseActionCardParams> {
  final GameStateRepository _gameStateRepository;

  UseActionCardUseCase(this._gameStateRepository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(UseActionCardParams params) async {
    try {
      // Validate action card usage with server-side validation
      final result = await _gameStateRepository.useActionCard(
        gameStateId: params.gameStateId,
        playerId: params.playerId,
        actionCardType: params.actionCardType,
        targetData: params.targetData,
      );

      // Check if the server returned a valid result
      if (result['valid'] != true) {
        final errorMessage = result['error'] as String? ?? 'Unknown error';
        return Left(_mapServerErrorToFailure(errorMessage, result));
      }

      return Right(result);
    } catch (e) {
      return Left(
        Failure.unknown(
          message: 'Failed to use action card: ${e.toString()}',
          error: e,
        ),
      );
    }
  }

  /// Validate an action card use without applying it (for UI feedback)
  Future<Either<Failure, Map<String, dynamic>>> validateOnly(
    UseActionCardParams params,
  ) async {
    try {
      // This would use a validate_action_card_use function without processing
      final response = await _gameStateRepository.useActionCard(
        gameStateId: params.gameStateId,
        playerId: params.playerId,
        actionCardType: params.actionCardType,
        targetData: params.targetData,
      );

      if (response['valid'] != true) {
        final errorMessage = response['error'] as String? ?? 'Unknown error';
        return Left(_mapServerErrorToFailure(errorMessage, response));
      }

      return Right(response);
    } catch (e) {
      return Left(
        Failure.unknown(
          message: 'Failed to validate action card use: ${e.toString()}',
          error: e,
        ),
      );
    }
  }

  /// Map server error messages to appropriate Failure types
  Failure _mapServerErrorToFailure(String errorMessage, Map<String, dynamic> response) {
    switch (errorMessage.toLowerCase()) {
      case 'game not found':
      case 'game not active':
        return Failure.gameLogic(
          message: errorMessage,
          code: 'GAME_STATE_INVALID',
        );
      
      case 'not your turn':
        return Failure.gameLogic(
          message: errorMessage,
          code: 'NOT_YOUR_TURN',
        );
      
      case 'action card not available':
        return Failure.gameLogic(
          message: errorMessage,
          code: 'CARD_NOT_OWNED',
        );
      
      case 'invalid positions':
      case 'cannot swap card with itself':
      case 'cannot swap revealed card':
        return Failure.validation(
          message: errorMessage,
          errors: {'target': errorMessage},
        );
      
      case 'player not in game':
        return Failure.authentication(message: errorMessage);
      
      default:
        return Failure.server(
          message: errorMessage,
          error: response,
        );
    }
  }

  /// Helper method to check if an action card requires target data
  static bool requiresTargetData(ActionCardType cardType) {
    switch (cardType) {
      case ActionCardType.teleport:
      case ActionCardType.swap:
      case ActionCardType.steal:
      case ActionCardType.peek:
      case ActionCardType.reveal:
      case ActionCardType.curse:
      case ActionCardType.gift:
        return true;
      default:
        return false;
    }
  }

  /// Helper method to get action card timing for UI purposes
  static ActionTiming getActionTiming(ActionCardType cardType) {
    switch (cardType) {
      case ActionCardType.turnAround:
        return ActionTiming.immediate;
      case ActionCardType.shield:
      case ActionCardType.mirror:
        return ActionTiming.reactive;
      default:
        return ActionTiming.optional;
    }
  }
}
