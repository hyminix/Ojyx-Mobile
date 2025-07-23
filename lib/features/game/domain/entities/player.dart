import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'player_grid.dart';
import 'action_card.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  @Assert('actionCards.length <= kMaxActionCardsInHand')
  const factory Player({
    required String id,
    required String name,
    required PlayerGrid grid,
    @Default([]) List<ActionCard> actionCards,
    @Default(true) bool isConnected,
    @Default(false) bool isHost,
    @Default(false) bool hasFinishedRound,
    @Default(1) int scoreMultiplier,
  }) = _Player;

  const Player._();

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  int get currentScore => grid.totalScore * scoreMultiplier;

  Player addActionCard(ActionCard card) {
    assert(actionCards.length < kMaxActionCardsInHand);
    return copyWith(actionCards: [...actionCards, card]);
  }

  Player removeActionCard(String cardId) {
    return copyWith(
      actionCards: actionCards.where((card) => card.id != cardId).toList(),
    );
  }

  Player updateGrid(PlayerGrid newGrid) {
    return copyWith(grid: newGrid);
  }

  Player disconnect() {
    return copyWith(isConnected: false);
  }

  Player reconnect() {
    return copyWith(isConnected: true);
  }

  Player markRoundFinished() {
    return copyWith(hasFinishedRound: true);
  }
}
