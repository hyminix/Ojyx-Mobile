import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';

part 'global_score_model.freezed.dart';
part 'global_score_model.g.dart';

@freezed
class GlobalScoreModel with _$GlobalScoreModel {
  const GlobalScoreModel._();

  const factory GlobalScoreModel({
    required String id,
    @JsonKey(name: 'player_id') required String playerId,
    @JsonKey(name: 'player_name') required String playerName,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'total_score') required int totalScore,
    @JsonKey(name: 'round_number') required int roundNumber,
    required int position,
    @JsonKey(name: 'is_winner') required bool isWinner,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'game_ended_at') DateTime? gameEndedAt,
  }) = _GlobalScoreModel;

  factory GlobalScoreModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalScoreModelFromJson(json);

  factory GlobalScoreModel.fromDomain(GlobalScore score) {
    return GlobalScoreModel(
      id: score.id,
      playerId: score.playerId,
      playerName: score.playerName,
      roomId: score.roomId,
      totalScore: score.totalScore,
      roundNumber: score.roundNumber,
      position: score.position,
      isWinner: score.isWinner,
      createdAt: score.createdAt,
      gameEndedAt: score.gameEndedAt,
    );
  }

  GlobalScore toDomain() {
    return GlobalScore(
      id: id,
      playerId: playerId,
      playerName: playerName,
      roomId: roomId,
      totalScore: totalScore,
      roundNumber: roundNumber,
      position: position,
      isWinner: isWinner,
      createdAt: createdAt,
      gameEndedAt: gameEndedAt,
    );
  }

  Map<String, dynamic> toSupabaseJson() {
    final json = toJson();
    // Remove id if empty for new records
    if (id.isEmpty) {
      json.remove('id');
    }
    return json;
  }
}
