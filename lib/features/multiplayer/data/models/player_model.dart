import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/lobby_player.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    required String id,
    required String name,
    String? avatarUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime lastSeenAt,
    required String connectionStatus,
    String? currentRoomId,
  }) = _PlayerModel;

  const PlayerModel._();

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  factory PlayerModel.fromDomain(LobbyPlayer player) {
    return PlayerModel(
      id: player.id,
      name: player.name,
      avatarUrl: player.avatarUrl,
      createdAt: player.createdAt,
      updatedAt: player.updatedAt,
      lastSeenAt: player.lastSeenAt,
      connectionStatus: player.connectionStatus.name,
      currentRoomId: player.currentRoomId,
    );
  }

  LobbyPlayer toDomain() {
    return LobbyPlayer(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastSeenAt: lastSeenAt,
      connectionStatus: ConnectionStatus.values.firstWhere(
        (status) => status.name == connectionStatus,
        orElse: () => ConnectionStatus.offline,
      ),
      currentRoomId: currentRoomId,
    );
  }

  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_seen_at': lastSeenAt.toIso8601String(),
      'connection_status': connectionStatus,
      'current_room_id': currentRoomId,
    };
  }
}
