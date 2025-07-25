import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_card_state_provider_v2.g.dart';
part 'action_card_state_provider_v2.freezed.dart';

@Freezed()
abstract class ActionCardState with _$ActionCardState {
  const factory ActionCardState({
    required int drawPileCount,
    required int discardPileCount,
    required bool isLoading,
  }) = _ActionCardState;
}

@riverpod
class ActionCardStateNotifier extends _$ActionCardStateNotifier {
  @override
  ActionCardState build() {
    return const ActionCardState(
      drawPileCount: 37, // Initial deck size
      discardPileCount: 0,
      isLoading: false,
    );
  }

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
