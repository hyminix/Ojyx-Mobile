import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_player.freezed.dart';
part 'lobby_player.g.dart';

enum ConnectionStatus { online, offline, away }

@freezed
class LobbyPlayer with _$LobbyPlayer {
  const factory LobbyPlayer({
    required String id,
    required String name,
    String? avatarUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime lastSeenAt,
    required ConnectionStatus connectionStatus,
    String? currentRoomId,
  }) = _LobbyPlayer;

  factory LobbyPlayer.fromJson(Map<String, dynamic> json) =>
      _$LobbyPlayerFromJson(json);
}
