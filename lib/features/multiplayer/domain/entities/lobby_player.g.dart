// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LobbyPlayer _$LobbyPlayerFromJson(Map<String, dynamic> json) =>
    _$$LobbyPlayerImplFromJson(json);

_$LobbyPlayerImpl _$$LobbyPlayerImplFromJson(Map<String, dynamic> json) =>
    _$LobbyPlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
      connectionStatus: $enumDecode(_$ConnectionStatusEnumMap, json['connection_status']),
      currentRoomId: json['current_room_id'] as String?,
    );

Map<String, dynamic> _$$LobbyPlayerImplToJson(_$LobbyPlayerImpl instance) =>
    <String, dynamic>{
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