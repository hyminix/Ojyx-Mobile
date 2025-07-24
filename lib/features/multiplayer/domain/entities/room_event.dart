import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../game/domain/entities/game_state.dart';
import '../../../game/domain/entities/card.dart';
import '../../data/converters/game_state_converter.dart';

part 'room_event.freezed.dart';
part 'room_event.g.dart';

@freezed
class RoomEvent with _$RoomEvent {
  const factory RoomEvent.playerJoined({
    required String playerId,
    required String playerName,
  }) = PlayerJoined;

  const factory RoomEvent.playerLeft({required String playerId}) = PlayerLeft;

  const factory RoomEvent.gameStarted({
    required String gameId,
    @GameStateConverter() required GameState initialState,
  }) = GameStarted;

  const factory RoomEvent.gameStateUpdated({
    @GameStateConverter() required GameState newState,
  }) = GameStateUpdated;

  const factory RoomEvent.playerAction({
    required String playerId,
    required PlayerActionType actionType,
    Map<String, dynamic>? actionData,
  }) = PlayerAction;

  factory RoomEvent.fromJson(Map<String, dynamic> json) =>
      _$RoomEventFromJson(json);
}

enum PlayerActionType {
  drawCard,
  discardCard,
  revealCard,
  playActionCard,
  endTurn,
  drawActionCard,
  useActionCard,
  discardActionCard,
}
