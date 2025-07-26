// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalScoreModel _$GlobalScoreModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_GlobalScoreModel',
      json,
      ($checkedConvert) {
        final val = _GlobalScoreModel(
          id: $checkedConvert('id', (v) => v as String),
          playerId: $checkedConvert('player_id', (v) => v as String),
          playerName: $checkedConvert('player_name', (v) => v as String),
          roomId: $checkedConvert('room_id', (v) => v as String),
          totalScore: $checkedConvert('total_score', (v) => (v as num).toInt()),
          roundNumber: $checkedConvert(
            'round_number',
            (v) => (v as num).toInt(),
          ),
          position: $checkedConvert('position', (v) => (v as num).toInt()),
          isWinner: $checkedConvert('is_winner', (v) => v as bool),
          createdAt: $checkedConvert(
            'created_at',
            (v) => DateTime.parse(v as String),
          ),
          gameEndedAt: $checkedConvert(
            'game_ended_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'playerId': 'player_id',
        'playerName': 'player_name',
        'roomId': 'room_id',
        'totalScore': 'total_score',
        'roundNumber': 'round_number',
        'isWinner': 'is_winner',
        'createdAt': 'created_at',
        'gameEndedAt': 'game_ended_at',
      },
    );

Map<String, dynamic> _$GlobalScoreModelToJson(_GlobalScoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player_id': instance.playerId,
      'player_name': instance.playerName,
      'room_id': instance.roomId,
      'total_score': instance.totalScore,
      'round_number': instance.roundNumber,
      'position': instance.position,
      'is_winner': instance.isWinner,
      'created_at': instance.createdAt.toIso8601String(),
      'game_ended_at': instance.gameEndedAt?.toIso8601String(),
    };
