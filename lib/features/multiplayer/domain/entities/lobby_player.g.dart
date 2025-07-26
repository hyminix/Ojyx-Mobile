// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LobbyPlayer _$LobbyPlayerFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_LobbyPlayer',
  json,
  ($checkedConvert) {
    final val = _LobbyPlayer(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
      createdAt: $checkedConvert(
        'created_at',
        (v) => DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => DateTime.parse(v as String),
      ),
      lastSeenAt: $checkedConvert(
        'last_seen_at',
        (v) => DateTime.parse(v as String),
      ),
      connectionStatus: $checkedConvert(
        'connection_status',
        (v) => $enumDecode(_$ConnectionStatusEnumMap, v),
      ),
      currentRoomId: $checkedConvert('current_room_id', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'avatarUrl': 'avatar_url',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
    'lastSeenAt': 'last_seen_at',
    'connectionStatus': 'connection_status',
    'currentRoomId': 'current_room_id',
  },
);

Map<String, dynamic> _$LobbyPlayerToJson(
  _LobbyPlayer instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_url': instance.avatarUrl,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'last_seen_at': instance.lastSeenAt.toIso8601String(),
  'connection_status': _$ConnectionStatusEnumMap[instance.connectionStatus]!,
  'current_room_id': instance.currentRoomId,
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.online: 'online',
  ConnectionStatus.offline: 'offline',
  ConnectionStatus.away: 'away',
};
