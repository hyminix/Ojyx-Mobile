// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerModelImpl _$$PlayerModelImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PlayerModelImpl',
      json,
      ($checkedConvert) {
        final val = _$PlayerModelImpl(
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
            (v) => v as String,
          ),
          currentRoomId: $checkedConvert(
            'current_room_id',
            (v) => v as String?,
          ),
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

Map<String, dynamic> _$$PlayerModelImplToJson(_$PlayerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_seen_at': instance.lastSeenAt.toIso8601String(),
      'connection_status': instance.connectionStatus,
      'current_room_id': instance.currentRoomId,
    };
