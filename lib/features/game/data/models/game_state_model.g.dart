// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameStateModel _$GameStateModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_GameStateModel',
  json,
  ($checkedConvert) {
    final val = _GameStateModel(
      id: $checkedConvert('id', (v) => v as String),
      roomId: $checkedConvert('room_id', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String),
      currentPlayerId: $checkedConvert('current_player_id', (v) => v as String),
      turnNumber: $checkedConvert('turn_number', (v) => (v as num).toInt()),
      roundNumber: $checkedConvert('round_number', (v) => (v as num).toInt()),
      gameData: $checkedConvert('game_data', (v) => v as Map<String, dynamic>),
      winnerId: $checkedConvert('winner_id', (v) => v as String?),
      endedAt: $checkedConvert(
        'ended_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      createdAt: $checkedConvert(
        'created_at',
        (v) => DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'roomId': 'room_id',
    'currentPlayerId': 'current_player_id',
    'turnNumber': 'turn_number',
    'roundNumber': 'round_number',
    'gameData': 'game_data',
    'winnerId': 'winner_id',
    'endedAt': 'ended_at',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$GameStateModelToJson(_GameStateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'status': instance.status,
      'current_player_id': instance.currentPlayerId,
      'turn_number': instance.turnNumber,
      'round_number': instance.roundNumber,
      'game_data': instance.gameData,
      'winner_id': instance.winnerId,
      'ended_at': instance.endedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
