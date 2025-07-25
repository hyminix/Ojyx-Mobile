import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';

class GameStateConverter
    implements JsonConverter<GameState, Map<String, dynamic>> {
  const GameStateConverter();

  @override
  GameState fromJson(Map<String, dynamic> json) {
    // When deserializing from JSON, we use a temporary GameStateModel
    // This is only used for RoomEvent serialization
    final tempModel = GameStateModel(
      id: json['id'] ?? 'temp-id',
      roomId: json['roomId'] ?? json['room_id'] ?? '',
      status: json['status'] ?? 'waitingToStart',
      currentPlayerId:
          json['currentPlayerId'] ?? json['current_player_id'] ?? '',
      turnNumber: json['turnNumber'] ?? json['turn_number'] ?? 0,
      roundNumber: json['roundNumber'] ?? json['round_number'] ?? 0,
      gameData: json['gameData'] ?? json['game_data'] ?? {},
      winnerId: json['winnerId'] ?? json['winner_id'],
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );

    return tempModel.toDomainComplete();
  }

  @override
  Map<String, dynamic> toJson(GameState gameState) {
    // When serializing to JSON, we create a temporary GameStateModel
    final tempModel = GameStateModel.fromDomainComplete(
      gameState,
      id: 'temp-id',
      turnNumber: 0,
      roundNumber: 0,
      updatedAt: DateTime.now(),
    );

    return tempModel.toJson();
  }
}
