import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@Freezed()
abstract class Room with _$Room {
  const factory Room({
    required String id,
    required String creatorId,
    required List<String> playerIds,
    required RoomStatus status,
    required int maxPlayers,
    String? currentGameId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

enum RoomStatus { waiting, inGame, finished, cancelled }
