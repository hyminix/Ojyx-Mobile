import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/room.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@Freezed()
abstract class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    @JsonKey(name: 'creator_id') required String creatorId,
    @JsonKey(name: 'player_ids') required List<String> playerIds,
    required String status,
    @JsonKey(name: 'max_players') required int maxPlayers,
    @JsonKey(name: 'current_game_id') String? currentGameId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}

extension RoomModelX on RoomModel {
  Room toDomain() {
    return Room(
      id: id,
      creatorId: creatorId,
      playerIds: playerIds,
      status: _parseRoomStatus(status),
      maxPlayers: maxPlayers,
      currentGameId: currentGameId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static RoomStatus _parseRoomStatus(String status) {
    switch (status) {
      case 'waiting':
        return RoomStatus.waiting;
      case 'in_game':
        return RoomStatus.inGame;
      case 'finished':
        return RoomStatus.finished;
      case 'cancelled':
        return RoomStatus.cancelled;
      default:
        return RoomStatus.waiting;
    }
  }
}
