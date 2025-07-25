import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'player_grid.dart';
import 'action_card.dart';

part 'game_player.freezed.dart';
part 'game_player.g.dart';

@freezed
class GamePlayer with _$GamePlayer {
  @Assert('actionCards.length <= kMaxActionCardsInHand')
  const factory GamePlayer({
    required String id,
    required String name,
    required PlayerGrid grid,
    @Default([]) List<ActionCard> actionCards,
    @Default(true) bool isConnected,
    @Default(false) bool isHost,
    @Default(false) bool hasFinishedRound,
    @Default(1) int scoreMultiplier,
  }) = _GamePlayer;

  const GamePlayer._();

  factory GamePlayer.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerFromJson(json);

  int get currentScore => grid.totalScore * scoreMultiplier;

  GamePlayer addActionCard(ActionCard card) {
    assert(actionCards.length < kMaxActionCardsInHand);
    return copyWith(actionCards: [...actionCards, card]);
  }

  GamePlayer removeActionCard(String cardId) {
    return copyWith(
      actionCards: actionCards.where((card) => card.id != cardId).toList(),
    );
  }

  GamePlayer updateGrid(PlayerGrid newGrid) {
    return copyWith(grid: newGrid);
  }

  GamePlayer disconnect() {
    return copyWith(isConnected: false);
  }

  GamePlayer reconnect() {
    return copyWith(isConnected: true);
  }

  GamePlayer markRoundFinished() {
    return copyWith(hasFinishedRound: true);
  }
}
