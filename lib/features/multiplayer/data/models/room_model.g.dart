// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_RoomModel',
  json,
  ($checkedConvert) {
    final val = _RoomModel(
      id: $checkedConvert('id', (v) => v as String),
      creatorId: $checkedConvert('creator_id', (v) => v as String),
      playerIds: $checkedConvert(
        'player_ids',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      status: $checkedConvert('status', (v) => v as String),
      maxPlayers: $checkedConvert('max_players', (v) => (v as num).toInt()),
      currentGameId: $checkedConvert('current_game_id', (v) => v as String?),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'creatorId': 'creator_id',
    'playerIds': 'player_ids',
    'maxPlayers': 'max_players',
    'currentGameId': 'current_game_id',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'player_ids': instance.playerIds,
      'status': instance.status,
      'max_players': instance.maxPlayers,
      'current_game_id': instance.currentGameId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
