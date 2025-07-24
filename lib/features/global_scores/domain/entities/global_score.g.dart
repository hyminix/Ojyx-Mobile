// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlobalScoreImpl _$$GlobalScoreImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$GlobalScoreImpl',
      json,
      ($checkedConvert) {
        final val = _$GlobalScoreImpl(
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

Map<String, dynamic> _$$GlobalScoreImplToJson(_$GlobalScoreImpl instance) =>
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

_$PlayerStatsImpl _$$PlayerStatsImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PlayerStatsImpl',
      json,
      ($checkedConvert) {
        final val = _$PlayerStatsImpl(
          playerId: $checkedConvert('player_id', (v) => v as String),
          playerName: $checkedConvert('player_name', (v) => v as String),
          totalGamesPlayed: $checkedConvert(
            'total_games_played',
            (v) => (v as num).toInt(),
          ),
          totalWins: $checkedConvert('total_wins', (v) => (v as num).toInt()),
          averageScore: $checkedConvert(
            'average_score',
            (v) => (v as num).toDouble(),
          ),
          bestScore: $checkedConvert('best_score', (v) => (v as num).toInt()),
          worstScore: $checkedConvert('worst_score', (v) => (v as num).toInt()),
          averagePosition: $checkedConvert(
            'average_position',
            (v) => (v as num).toDouble(),
          ),
          totalRoundsPlayed: $checkedConvert(
            'total_rounds_played',
            (v) => (v as num).toInt(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'playerId': 'player_id',
        'playerName': 'player_name',
        'totalGamesPlayed': 'total_games_played',
        'totalWins': 'total_wins',
        'averageScore': 'average_score',
        'bestScore': 'best_score',
        'worstScore': 'worst_score',
        'averagePosition': 'average_position',
        'totalRoundsPlayed': 'total_rounds_played',
      },
    );

Map<String, dynamic> _$$PlayerStatsImplToJson(_$PlayerStatsImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'player_name': instance.playerName,
      'total_games_played': instance.totalGamesPlayed,
      'total_wins': instance.totalWins,
      'average_score': instance.averageScore,
      'best_score': instance.bestScore,
      'worst_score': instance.worstScore,
      'average_position': instance.averagePosition,
      'total_rounds_played': instance.totalRoundsPlayed,
    };
