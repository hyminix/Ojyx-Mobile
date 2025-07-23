import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/action_card_local_datasource.dart';
import '../../data/datasources/action_card_local_datasource_impl.dart';
import '../../data/repositories/action_card_repository_impl.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../../domain/use_cases/use_action_card_use_case.dart';

part 'action_card_providers.g.dart';

@riverpod
ActionCardLocalDataSource actionCardLocalDataSource(
  ActionCardLocalDataSourceRef ref,
) {
  return ActionCardLocalDataSourceImpl();
}

@riverpod
ActionCardRepository actionCardRepository(ActionCardRepositoryRef ref) {
  final localDataSource = ref.watch(actionCardLocalDataSourceProvider);
  return ActionCardRepositoryImpl(localDataSource);
}

@riverpod
UseActionCardUseCase useActionCardUseCase(UseActionCardUseCaseRef ref) {
  final repository = ref.watch(actionCardRepositoryProvider);
  return UseActionCardUseCase(repository);
}

@riverpod
List<ActionCard> playerActionCards(PlayerActionCardsRef ref, String playerId) {
  final repository = ref.watch(actionCardRepositoryProvider);
  return repository.getPlayerActionCards(playerId);
}

@riverpod
bool canUseActionCard(
  CanUseActionCardRef ref,
  ({String playerId, ActionCard? actionCard}) params,
) {
  if (params.actionCard == null) return false;

  final playerCards = ref.watch(playerActionCardsProvider(params.playerId));
  return playerCards.contains(params.actionCard);
}

@riverpod
class ActionCardNotifier extends _$ActionCardNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<Either<Failure, GameState>> useActionCard({
    required String playerId,
    required ActionCard actionCard,
    required GameState gameState,
    Map<String, dynamic>? targetData,
  }) async {
    state = const AsyncLoading();

    try {
      final useCase = ref.read(useActionCardUseCaseProvider);
      final params = UseActionCardParams(
        playerId: playerId,
        actionCard: actionCard,
        gameState: gameState,
        targetData: targetData,
      );

      final result = await useCase(params);

      result.fold(
        (failure) => state = AsyncError(failure, StackTrace.current),
        (_) => state = const AsyncData(null),
      );

      return result;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return Left(
        Failure.unknown(message: 'Failed to use action card', error: e),
      );
    }
  }
}
