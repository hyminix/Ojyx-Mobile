import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/play_direction.dart';

part 'game_animation_provider.freezed.dart';

@freezed
class GameAnimationState with _$GameAnimationState {
  const factory GameAnimationState({
    @Default(false) bool showingDirectionChange,
    @Default(PlayDirection.forward) PlayDirection direction,
  }) = _GameAnimationState;
}

class GameAnimationNotifier extends StateNotifier<GameAnimationState> {
  GameAnimationNotifier() : super(const GameAnimationState());

  void showDirectionChange(PlayDirection direction) {
    if (!state.showingDirectionChange) {
      state = state.copyWith(
        showingDirectionChange: true,
        direction: direction,
      );
    }
  }

  void hideDirectionChange() {
    state = state.copyWith(showingDirectionChange: false);
  }
}

final gameAnimationProvider =
    StateNotifierProvider<GameAnimationNotifier, GameAnimationState>(
      (ref) => GameAnimationNotifier(),
    );
