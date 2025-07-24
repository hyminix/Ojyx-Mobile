import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_state.dart';

part 'game_state_model.freezed.dart';
part 'game_state_model.g.dart';

@freezed
class GameStateModel with _$GameStateModel {
  const factory GameStateModel({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    required String status,
    @JsonKey(name: 'current_player_id') required String currentPlayerId,
    @JsonKey(name: 'turn_number') required int turnNumber,
    @JsonKey(name: 'round_number') required int roundNumber,
    @JsonKey(name: 'game_data') required Map<String, dynamic> gameData,
    @JsonKey(name: 'winner_id') String? winnerId,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _GameStateModel;

  const GameStateModel._();

  factory GameStateModel.fromJson(Map<String, dynamic> json) => _$GameStateModelFromJson(json);

  factory GameStateModel.fromDomain(GameState gameState) {
    return GameStateModel(
      id: gameState.id,
      roomId: gameState.roomId,
      status: gameState.status.name,
      currentPlayerId: gameState.currentPlayerId,
      turnNumber: gameState.turnNumber,
      roundNumber: gameState.roundNumber,
      gameData: gameState.gameData,
      winnerId: gameState.winnerId,
      endedAt: gameState.endedAt,
      createdAt: gameState.createdAt,
      updatedAt: gameState.updatedAt,
    );
  }

  GameState toDomain() {
    return GameState(
      id: id,
      roomId: roomId,
      status: GameStatus.values.firstWhere(
        (status) => status.name == this.status,
        orElse: () => GameStatus.waiting,
      ),
      currentPlayerId: currentPlayerId,
      turnNumber: turnNumber,
      roundNumber: roundNumber,
      gameData: gameData,
      winnerId: winnerId,
      endedAt: endedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'room_id': roomId,
      'status': status,
      'current_player_id': currentPlayerId,
      'turn_number': turnNumber,
      'round_number': roundNumber,
      'game_data': gameData,
      'winner_id': winnerId,
      'ended_at': endedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
