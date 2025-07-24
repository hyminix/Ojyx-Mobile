import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';

enum ConnectionStatus {
  online,
  offline,
  away,
}

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    String? avatarUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime lastSeenAt,
    required ConnectionStatus connectionStatus,
    String? currentRoomId,
  }) = _Player;
}