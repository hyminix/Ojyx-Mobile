import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../data/datasources/action_card_local_datasource.dart';
import '../../data/datasources/action_card_local_datasource_impl.dart';
import '../../data/datasources/supabase_action_card_datasource.dart';
import '../../data/repositories/action_card_repository_impl.dart';
import '../../data/repositories/supabase_action_card_repository.dart';
import '../../domain/entities/action_card.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/repositories/action_card_repository.dart';
import '../../domain/use_cases/use_action_card_use_case.dart';
import 'repository_providers.dart';

part 'action_card_providers.g.dart';
part 'action_card_providers.freezed.dart';

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

// New Supabase-based providers
@riverpod
ActionCardRepository supabaseActionCardRepository(
  SupabaseActionCardRepositoryRef ref,
  String gameStateId,
) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseActionCardDataSource(supabaseClient, gameStateId);
  return SupabaseActionCardRepository(dataSource);
}

@riverpod
UseActionCardUseCase useActionCardUseCase(UseActionCardUseCaseRef ref) {
  final gameStateRepository = ref.watch(gameStateRepositoryProvider);
  return UseActionCardUseCase(gameStateRepository);
}

@riverpod
Future<List<ActionCard>> playerActionCards(
  PlayerActionCardsRef ref,
  ({String playerId, String gameStateId}) params,
) async {
  final repository = ref.watch(
    supabaseActionCardRepositoryProvider(params.gameStateId),
  );
  return await repository.getPlayerActionCards(params.playerId);
}

@riverpod
Future<bool> canUseActionCard(
  CanUseActionCardRef ref,
  ({String playerId, String gameStateId, ActionCard? actionCard}) params,
) async {
  if (params.actionCard == null) return false;

  final playerCards = await ref.watch(
    playerActionCardsProvider((
      playerId: params.playerId,
      gameStateId: params.gameStateId,
    )).future,
  );
  return playerCards.contains(params.actionCard);
}

@riverpod
class ActionCardNotifier extends _$ActionCardNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<Either<Failure, Map<String, dynamic>>> useActionCard({
    required String gameStateId,
    required String playerId,
    required ActionCardType actionCardType,
    Map<String, dynamic>? targetData,
  }) async {
    state = const AsyncLoading();

    try {
      final useCase = ref.read(useActionCardUseCaseProvider);
      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
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

// ActionCardState for UI state management
@freezed
class ActionCardState with _$ActionCardState {
  const factory ActionCardState({
    required int drawPileCount,
    required int discardPileCount,
    required bool isLoading,
  }) = _ActionCardState;
}

class ActionCardStateNotifier extends StateNotifier<ActionCardState> {
  ActionCardStateNotifier()
    : super(
        const ActionCardState(
          drawPileCount: 37, // Initial deck size
          discardPileCount: 0,
          isLoading: false,
        ),
      );

  void updateCounts({int? drawPileCount, int? discardPileCount}) {
    state = state.copyWith(
      drawPileCount: drawPileCount ?? state.drawPileCount,
      discardPileCount: discardPileCount ?? state.discardPileCount,
    );
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> drawCard() async {
    if (state.drawPileCount <= 0) return;

    setLoading(true);

    // Simulate drawing a card
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(
      drawPileCount: state.drawPileCount - 1,
      isLoading: false,
    );
  }
}

final actionCardStateNotifierProvider =
    StateNotifierProvider<ActionCardStateNotifier, ActionCardState>(
      (ref) => ActionCardStateNotifier(),
    );
