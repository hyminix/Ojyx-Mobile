import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/action_card.dart';

part 'game_state_model.freezed.dart';
part 'game_state_model.g.dart';

@freezed
class GameStateModel with _$GameStateModel {
  const factory GameStateModel({
    required String roomId,
    required List<Player> players,
    required int currentPlayerIndex,
    required List<Card> deck,
    required List<Card> discardPile,
    required List<ActionCard> actionDeck,
    required List<ActionCard> actionDiscard,
    required GameStatus status,
    required TurnDirection turnDirection,
    required bool lastRound,
    String? initiatorPlayerId,
    String? endRoundInitiator,
    Card? drawnCard,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
  }) = _GameStateModel;

  const GameStateModel._();

  factory GameStateModel.fromJson(Map<String, dynamic> json) =>
      _$GameStateModelFromJson(json);

  // Conversion methods
  factory GameStateModel.fromDomain(GameState entity) {
    return GameStateModel(
      roomId: entity.roomId,
      players: entity.players,
      currentPlayerIndex: entity.currentPlayerIndex,
      deck: entity.deck,
      discardPile: entity.discardPile,
      actionDeck: entity.actionDeck,
      actionDiscard: entity.actionDiscard,
      status: entity.status,
      turnDirection: entity.turnDirection,
      lastRound: entity.lastRound,
      initiatorPlayerId: entity.initiatorPlayerId,
      endRoundInitiator: entity.endRoundInitiator,
      drawnCard: entity.drawnCard,
      createdAt: entity.createdAt,
      startedAt: entity.startedAt,
      finishedAt: entity.finishedAt,
    );
  }

  GameState toDomain() {
    return GameState(
      roomId: roomId,
      players: players,
      currentPlayerIndex: currentPlayerIndex,
      deck: deck,
      discardPile: discardPile,
      actionDeck: actionDeck,
      actionDiscard: actionDiscard,
      status: status,
      turnDirection: turnDirection,
      lastRound: lastRound,
      initiatorPlayerId: initiatorPlayerId,
      endRoundInitiator: endRoundInitiator,
      drawnCard: drawnCard,
      createdAt: createdAt,
      startedAt: startedAt,
      finishedAt: finishedAt,
    );
  }
}
