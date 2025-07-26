import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/play_direction.dart';

part 'game_animation_provider_v2.g.dart';
part 'game_animation_provider_v2.freezed.dart';

@Freezed()
abstract class GameAnimationState with _$GameAnimationState {
  const factory GameAnimationState({
    @Default(false) bool showingDirectionChange,
    @Default(PlayDirection.forward) PlayDirection direction,
  }) = _GameAnimationState;
}

@riverpod
class GameAnimation extends _$GameAnimation {
  @override
  GameAnimationState build() {
    return const GameAnimationState();
  }

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
