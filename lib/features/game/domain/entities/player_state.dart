import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@Freezed()
abstract class PlayerState with _$PlayerState {
  const factory PlayerState({
    required String playerId,
    required List<Card?> cards,
    required int currentScore,
    required int revealedCount,
    required List<int> identicalColumns,
    required bool hasFinished,
  }) = _PlayerState;

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}
